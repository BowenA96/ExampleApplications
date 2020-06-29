using ClassLibrary;
using DatabaseClassLibrary;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;

namespace WebService.Controller
{
    [RoutePrefix("api/vehicle")]
    public class VehicleController : ApiController
    {
        // GET: api/vehicle/email
        [Route("{customer}")]
        [HttpGet]
        public IEnumerable<VehicleDTO> GetVehicle(string customer)
        {
            VehicleHireEntities entities = new VehicleHireEntities();
            ConcurrentBag<VehicleDTO> vehicles = new ConcurrentBag<VehicleDTO>();
            Customer c = entities.Customers.Find(customer);

            decimal basePrice = PriceScreenScraper.GetBasePrice();

            if (c != null)
            {
                if ((DateTime.Now.Year - c.DateOfBirth.Year) < 25)
                {
                    foreach(Vehicle v in entities.Vehicles)
                    {
                        if (v.Type.Equals("Small Town Car"))
                        {
                            VehicleDTO vehicle = new VehicleDTO(v.VehicleId, v.Type, v.Engine, v.Gearbox, basePrice, v.NumberAvailable);
                            vehicles.Add(vehicle);
                        }
                    };
                }
                else
                {
                    foreach (Vehicle v in entities.Vehicles)
                    {
                        decimal price = basePrice;

                        if (v.Type.Equals("Small Family Hatchback"))
                            price = basePrice * decimal.Parse(1.3.ToString());     
                        else if (v.Type.Equals("Large Family Saloon"))
                            price = basePrice * decimal.Parse(1.5.ToString());
                        else if (v.Type.Equals("Large Family Estate"))
                            price = basePrice * decimal.Parse(1.9.ToString());
                        else if (v.Type.Equals("Medium Van"))
                            price = basePrice * decimal.Parse(1.8.ToString());

                        VehicleDTO vehicle = new VehicleDTO(v.VehicleId, v.Type, v.Engine, v.Gearbox, price, v.NumberAvailable);
                        vehicles.Add(vehicle);
                    };
                }
            }
            return vehicles;
        }

        // POST: api/vehicle/available
        [Route("available")]
        [HttpPost]
        public async Task<bool> CheckVehicleAvailability()
        {
            HttpContent content = Request.Content;
            var data = await content.ReadAsFormDataAsync();
            var vehicle = data.Get("vehicle");
            var startDate = data.Get("startDate");
            var endDate = data.Get("endDate");

            long vehicleId = long.Parse(HttpUtility.UrlDecode(vehicle));
            startDate = HttpUtility.UrlDecode(startDate);
            endDate = HttpUtility.UrlDecode(endDate);

            VehicleHireEntities entities = new VehicleHireEntities();
            bool available = true;

            foreach (VehicleBooking v in entities.VehicleBookings)
            {
                if ((v.StartDateTime <= DateTime.Parse(startDate)) && (DateTime.Parse(endDate) <= v.EndDateTime) && (v.VehicleId == vehicleId))
                {
                    available = false;
                }
            };

            return available;
        }

        // POST: api/vehicle/book
        [Route("book")]
        [HttpPost]
        public async Task<long> CreateBooking()
        {
            HttpContent content = Request.Content;
            var data = await content.ReadAsFormDataAsync();
            var vehicle = data.Get("vehicle");
            var startDate = data.Get("startDate");
            var endDate = data.Get("endDate");
            var email = data.Get("email");
            var pricePerDay = decimal.Parse(data.Get("pricePerDay"));

            long vehicleId = long.Parse(HttpUtility.UrlDecode(vehicle));
            startDate = HttpUtility.UrlDecode(startDate);
            endDate = HttpUtility.UrlDecode(endDate);
            email = HttpUtility.UrlDecode(email);

            VehicleHireEntities entities = new VehicleHireEntities();

            VehicleBooking vehicleBooking = new VehicleBooking();
            vehicleBooking.Email = email;
            vehicleBooking.VehicleId = vehicleId;
            vehicleBooking.StartDateTime = DateTime.Parse(startDate);
            vehicleBooking.EndDateTime = DateTime.Parse(endDate);

            TimeSpan timeSpan = (vehicleBooking.EndDateTime - vehicleBooking.StartDateTime);
            decimal days = 0;

            if ((timeSpan.Days == 0) && (timeSpan.Hours != 10))
                days = decimal.Parse(0.5.ToString());
            else
            {
                days = decimal.Parse(timeSpan.Days.ToString());

                if (timeSpan.Hours == 5)
                    days = days + decimal.Parse(0.5.ToString());
                else if (timeSpan.Hours == 10)
                    days++;
            }

            decimal totalPrice = days * pricePerDay;


            vehicleBooking.TotalPrice = totalPrice;

            entities.VehicleBookings.Add(vehicleBooking);
            entities.SaveChanges();

            long result = 0;

            foreach (VehicleBooking v in entities.VehicleBookings)
            {
                if ((v.Email == email) && (v.VehicleId == vehicleId) && (v.StartDateTime == DateTime.Parse(startDate)) && (v.EndDateTime == DateTime.Parse(endDate)))
                {
                    result = v.VehicleBookingId;
                }
            };

            return result;
        }

        // GET: api/vehicle/customer
        [Route("booking/{customer}")]
        [HttpGet]
        public IEnumerable<VehicleBookingDTO> GetVehicleBookingsForCustomer(string customer)
        {
            VehicleHireEntities entities = new VehicleHireEntities();
            ConcurrentBag<VehicleBookingDTO> bookings = new ConcurrentBag<VehicleBookingDTO>();

            foreach (VehicleBooking v in entities.VehicleBookings)
            {
                if (v.Email == customer)
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

                            foreach (EquipmentBooking e in entities.EquipmentBookings)
                            {
                                EquipmentDTO equipment = new EquipmentDTO(e.EquipmentId, e.Equipment.Type, e.Equipment.Amount);
                                equipments.Add(equipment);
                            };

                            bookings.Add(new VehicleBookingDTO(v.VehicleBookingId, v.Email, vehicleDTO, equipments, v.StartDateTime, v.EndDateTime, v.TotalPrice, v.Collected));
                        }
                    }
                }
            };

            return bookings;
        }

        // POST: api/vehicle/cancel
        [Route("cancel")]
        [HttpPost]
        public async Task<bool> CancelBooking()
        {
            HttpContent content = Request.Content;
            var data = await content.ReadAsFormDataAsync();
            var booking = data.Get("booking");
            long bookingId = long.Parse(HttpUtility.UrlDecode(booking));
            VehicleHireEntities entities = new VehicleHireEntities();

            foreach(EquipmentBooking e in entities.EquipmentBookings)
            {
                if (e.VehicleBookingId == bookingId)
                    entities.EquipmentBookings.Remove(e);
            }
            entities.SaveChanges();

            VehicleBooking v = entities.VehicleBookings.Find(bookingId);

            if (v == null)
                return false;
            else
            {
                entities.VehicleBookings.Remove(v);
                entities.SaveChanges();
                return true;
            }
        }

        // POST: api/vehicle/cancel
        [Route("booking/extend")]
        [HttpPut]
        public async Task<bool> ExtendBooking()
        {
            HttpContent content = Request.Content;
            var data = await content.ReadAsFormDataAsync();
            var booking = data.Get("booking");
            long bookingId = long.Parse(HttpUtility.UrlDecode(booking));
            VehicleHireEntities entities = new VehicleHireEntities();

            VehicleBooking v = entities.VehicleBookings.Find(bookingId);
            DateTime dateTime = new DateTime(v.EndDateTime.Year, v.EndDateTime.Month, v.EndDateTime.Day, 16, 0, 0);

            entities.VehicleBookings.Find(bookingId).EndDateTime = dateTime;
            entities.SaveChanges();
            return true;
        }

        [Route("booking/late")]
        [HttpPut]
        public async Task<bool> LateBooking()
        {
            HttpContent content = Request.Content;
            var data = await content.ReadAsFormDataAsync();
            var booking = data.Get("booking");
            long bookingId = long.Parse(HttpUtility.UrlDecode(booking));
            VehicleHireEntities entities = new VehicleHireEntities();

            VehicleBooking v = entities.VehicleBookings.Find(bookingId);
            DateTime dateTime = new DateTime(v.EndDateTime.Year, v.EndDateTime.Month, v.EndDateTime.Day, 23, 59, 59);

            entities.VehicleBookings.Find(bookingId).EndDateTime = dateTime;
            entities.SaveChanges();
            return true;
        }

        [Route("booking/extra")]
        [HttpPost]
        public async Task<bool> ExtraBooking()
        {
            HttpContent content = Request.Content;
            var data = await content.ReadAsFormDataAsync();
            var equipment = data.Get("equipment");
            var booking = data.Get("booking");

            long equipmentId = long.Parse(HttpUtility.UrlDecode(equipment));
            long vehicleBookingId = long.Parse(HttpUtility.UrlDecode(booking));

            VehicleHireEntities entities = new VehicleHireEntities();
            VehicleBooking vehicleBooking = entities.VehicleBookings.Find(vehicleBookingId);
            bool available = true;

            foreach (VehicleBooking v in entities.VehicleBookings)
            {
                if ((v.StartDateTime <= vehicleBooking.StartDateTime) && (vehicleBooking.EndDateTime <= v.EndDateTime))
                {
                    foreach (EquipmentBooking b in entities.EquipmentBookings)
                    {
                        if (b.EquipmentId == equipmentId)
                            available = false;
                    };
                }
            };

            if (available)
            {
                EquipmentBooking equipmentBooking = new EquipmentBooking();
                equipmentBooking.EquipmentId = equipmentId;
                equipmentBooking.VehicleBookingId = vehicleBookingId;
                entities.EquipmentBookings.Add(equipmentBooking);
                entities.SaveChanges();
            }

            return available;
        }
    }
}