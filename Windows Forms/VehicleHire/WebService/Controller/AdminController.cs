using ClassLibrary;
using DatabaseClassLibrary;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web;
using System.Net.Mail;

namespace WebService.Controller
{
    [RoutePrefix("api/admin")]
    public class AdminController : ApiController
    {
        // GET: api/admin/username/password
        [Route("{username}/{password}")]
        [HttpGet]
        public bool GetAdmin(string username, string password)
        {
            VehicleHireEntities entities = new VehicleHireEntities();
            Admin admin = entities.Admins.Find(username);

            if (admin == null)
                return false;
            else if (admin.Password == password)
                return true;
            else
                return false;
        }

        // GET: api/admin/bookings
        [Route("bookings")]
        [HttpGet]
        public IEnumerable<VehicleBookingDTO> GetPastCustomerBookings()
        {
            VehicleHireEntities entities = new VehicleHireEntities();
            ConcurrentBag<VehicleBookingDTO> bookings = new ConcurrentBag<VehicleBookingDTO>();
            ConcurrentDictionary<string, Customer> customers = new ConcurrentDictionary<string, Customer>();

            foreach(Customer c in entities.Customers)
            {
                customers.TryAdd(c.Email, c);
            };

            foreach (VehicleBooking v in entities.VehicleBookings)
            {
                if (customers.TryGetValue(v.Email, out Customer customer))
                {
                    if ((v.EndDateTime < DateTime.Now) && (customer.Blacklisted == false))
                    {
                        if (v.Vehicle != null)
                        {
                            VehicleDTO vehicle = new VehicleDTO(v.VehicleId, v.Vehicle.Type, v.Vehicle.Engine, v.Vehicle.Gearbox, v.Vehicle.PricePerDay, v.Vehicle.NumberAvailable);
                            ConcurrentBag<EquipmentDTO> equipments = new ConcurrentBag<EquipmentDTO>();

                            foreach(EquipmentBooking e in v.EquipmentBookings)
                            {
                                EquipmentDTO equipment = new EquipmentDTO(e.EquipmentId, e.Equipment.Type, e.Equipment.Amount);
                                equipments.Add(equipment);
                            };

                            bookings.Add(new VehicleBookingDTO(v.VehicleBookingId, v.Email, vehicle, equipments, v.StartDateTime, v.EndDateTime, v.TotalPrice, v.Collected));
                        }
                        else
                        {
                            Vehicle vehicle = entities.Vehicles.Find(v.VehicleId);

                            if (vehicle != null)
                            {
                                VehicleDTO vehicleDTO = new VehicleDTO(v.VehicleId, v.Vehicle.Type, v.Vehicle.Engine, v.Vehicle.Gearbox, v.Vehicle.PricePerDay, v.Vehicle.NumberAvailable);
                                ConcurrentBag<EquipmentDTO> equipments = new ConcurrentBag<EquipmentDTO>();

                                foreach (EquipmentBooking e in v.EquipmentBookings)
                                {
                                    EquipmentDTO equipment = new EquipmentDTO(e.EquipmentId, e.Equipment.Type, e.Equipment.Amount);
                                    equipments.Add(equipment);
                                };

                                bookings.Add(new VehicleBookingDTO(v.VehicleBookingId, v.Email, vehicleDTO, equipments, v.StartDateTime, v.EndDateTime, v.TotalPrice, v.Collected));
                            }
                        }
                    }
                }
            };

            return bookings;
        }

        // PUT: api/admin/customer
        [Route("customer")]
        [HttpPut]
        public async Task<bool> BlacklistCustomer()
        {
            HttpContent content = Request.Content;
            var data = await content.ReadAsFormDataAsync();
            var email = data.Get("email");

            email = HttpUtility.UrlDecode(email);

            VehicleHireEntities entities = new VehicleHireEntities();
            Customer c = entities.Customers.Find(email);

            if (c == null)
                return false;
            else
            {
                if (c.Blacklisted == false)
                {
                    entities.Customers.Find(email).Blacklisted = true;
                    entities.SaveChanges();
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        // PUT: api/admin/collect
        [Route("collect")]
        [HttpPut]
        public async Task<bool> CollectBooking()
        {
            HttpContent content = Request.Content;
            var data = await content.ReadAsFormDataAsync();
            var vehicleBookingId = long.Parse(data.Get("vehicleBookingId"));
            
            VehicleHireEntities entities = new VehicleHireEntities();
            VehicleBooking vb = entities.VehicleBookings.Find(vehicleBookingId);

            if (vb == null)
                return false;
            else
            {
                if (vb.Collected == false)
                {
                    entities.VehicleBookings.Find(vehicleBookingId).Collected = true;
                    entities.SaveChanges();
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        // PUT: api/admin/collect/check
        [Route("collect/check")]
        [HttpPut]
        public async Task<bool> CheckBookingCollectable()
        {
            HttpContent content = Request.Content;
            var data = await content.ReadAsFormDataAsync();
            var vehicleBookingId = long.Parse(data.Get("vehicleBookingId"));

            VehicleHireEntities entities = new VehicleHireEntities();
            VehicleBooking vb = entities.VehicleBookings.Find(vehicleBookingId);

            if (vb == null)
                return false;
            else
            {
                var license = data.Get("license");
                
                if (ExcelSpreadsheetHelper.CheckSpreadsheet(license) == false)
                {
                    MailAddress mailAddress = new MailAddress("b016554e@student.staffs.ac.uk");
                    MailMessage message = new MailMessage(mailAddress, mailAddress);
                    message.Subject = "Mock Email - DVLA";
                    message.Body = $"Customer with license - {license} - attempted to collect a vehicle booking from us at {DateTime.Now}";

                    Console.WriteLine("Email to send: " + message.ToString());

                    return false;
                }

                var firstName = data.Get("firstName");
                var lastName = data.Get("lastName");
                var address = data.Get("address");

                return AccessDatabaseHelper.CheckDatabase(firstName, lastName, address);
            }
        }

        // GET: api/admin/bookings/current
        [Route("bookings/current")]
        [HttpGet]
        public IEnumerable<VehicleBookingDTO> GetCurrentCustomerBookings()
        {
            VehicleHireEntities entities = new VehicleHireEntities();
            ConcurrentBag<VehicleBookingDTO> bookings = new ConcurrentBag<VehicleBookingDTO>();
            ConcurrentDictionary<string, Customer> customers = new ConcurrentDictionary<string, Customer>();

            foreach (Customer c in entities.Customers)
            {
                customers.TryAdd(c.Email, c);
            };

            foreach (VehicleBooking v in entities.VehicleBookings)
            {
                if (customers.TryGetValue(v.Email, out Customer customer))
                {
                    if ((v.StartDateTime < DateTime.Now) && (customer.Blacklisted == false) && (v.Collected == false) && (v.EndDateTime > DateTime.Now))
                    {
                        if (v.Vehicle != null)
                        {
                            VehicleDTO vehicle = new VehicleDTO(v.VehicleId, v.Vehicle.Type, v.Vehicle.Engine, v.Vehicle.Gearbox, v.Vehicle.PricePerDay, v.Vehicle.NumberAvailable);
                            ConcurrentBag<EquipmentDTO> equipments = new ConcurrentBag<EquipmentDTO>();

                            foreach (EquipmentBooking e in v.EquipmentBookings)
                            {
                                EquipmentDTO equipment = new EquipmentDTO(e.EquipmentId, e.Equipment.Type, e.Equipment.Amount);
                                equipments.Add(equipment);
                            };

                            bookings.Add(new VehicleBookingDTO(v.VehicleBookingId, v.Email, vehicle, equipments, v.StartDateTime, v.EndDateTime, v.TotalPrice, v.Collected));
                        }
                        else
                        {
                            Vehicle vehicle = entities.Vehicles.Find(v.VehicleId);

                            if (vehicle != null)
                            {
                                VehicleDTO vehicleDTO = new VehicleDTO(v.VehicleId, v.Vehicle.Type, v.Vehicle.Engine, v.Vehicle.Gearbox, v.Vehicle.PricePerDay, v.Vehicle.NumberAvailable);
                                ConcurrentBag<EquipmentDTO> equipments = new ConcurrentBag<EquipmentDTO>();

                                foreach (EquipmentBooking e in v.EquipmentBookings)
                                {
                                    EquipmentDTO equipment = new EquipmentDTO(e.EquipmentId, e.Equipment.Type, e.Equipment.Amount);
                                    equipments.Add(equipment);
                                };

                                bookings.Add(new VehicleBookingDTO(v.VehicleBookingId, v.Email, vehicleDTO, equipments, v.StartDateTime, v.EndDateTime, v.TotalPrice, v.Collected));
                            }
                        }
                    }
                }
            };

            return bookings;
        }
    }
}