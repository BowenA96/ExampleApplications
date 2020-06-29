using ClassLibrary;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Forms
{
    public class WebServiceHandler
    {
        #region Properties

        public static string customer = "";
        public static VehicleDTO vehicle = null;

        #endregion

        #region Admin Handling

        public static async Task<bool> GetAdmin(string username, string password)
        {
            try
            {
                string result = await WebServiceConnection.WebServiceGetRequest($"admin/{username}/{password}");
                return bool.Parse(result);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                return false;
            }
        }

        public static async Task<List<VehicleBookingDTO>> GetPastBookings()
        {
            try
            {
                string result = await WebServiceConnection.WebServiceGetRequest("admin/bookings");
                var bookings = JsonConvert.DeserializeObject<List<VehicleBookingDTO>>(result);

                return bookings;
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                return null;
            }
        }

        public static async Task<bool> BlacklistCustomer(string email)
        {
            try
            {
                var dictionary = new Dictionary<string, string>();
                dictionary.Add("email", email);

                string result = await WebServiceConnection.WebServicePutRequest($"admin/customer", dictionary);
                return bool.Parse(result);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                return false;
            }
        }

        public static async Task<List<VehicleBookingDTO>> GetCurrentBookings()
        {
            try
            {
                string result = await WebServiceConnection.WebServiceGetRequest("admin/bookings/current");
                var bookings = JsonConvert.DeserializeObject<List<VehicleBookingDTO>>(result);

                return bookings;
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                return null;
            }
        }

        public static async Task<bool> CheckBookingCollectable(long vehicleBookingId, string firstName, string lastName, string address, string license)
        {
            try
            {
                var dictionary = new Dictionary<string, string>();
                dictionary.Add("vehicleBookingId", vehicleBookingId.ToString());
                dictionary.Add("firstName", firstName);
                dictionary.Add("lastName", lastName);
                dictionary.Add("address", address);
                dictionary.Add("license", license);

                string result = await WebServiceConnection.WebServicePutRequest($"admin/collect/check", dictionary);
                return bool.Parse(result);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                return false;
            }
        }

        public static async Task<bool> CollectBooking(long vehicleBookingId)
        {
            try
            {
                var dictionary = new Dictionary<string, string>();
                dictionary.Add("vehicleBookingId", vehicleBookingId.ToString());

                string result = await WebServiceConnection.WebServicePutRequest($"admin/collect", dictionary);
                return bool.Parse(result);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                return false;
            }
        }

        #endregion

        #region Customer Handling

        #region Customer Login

        public static async Task<bool> GetCustomer(string email, string password)
        {
            try
            {
                string result = await WebServiceConnection.WebServiceGetRequest($"customer/{email}/{password}");
                if (bool.Parse(result))
                {
                    customer = email;
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                return false;
            }
        }

        public static async Task<bool> GetCustomerBlacklisted(string email)
        {
            try
            {
                string result = await WebServiceConnection.WebServiceGetRequest($"customer/{email}/blacklisted");
                return bool.Parse(result);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                return false;
            }
        }

        public static async Task<bool> RegisterCustomer(string email, string password, DateTime dateTime)
        {
            try
            {
                var dictionary = new Dictionary<string, string>();
                dictionary.Add("email", email);
                dictionary.Add("password", password);
                dictionary.Add("date", dateTime.ToString());

                string result = await WebServiceConnection.WebServicePostRequest($"customer/register", dictionary);

                if (bool.Parse(result))
                {
                    customer = email;
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                return false;
            }
        }

        public static void LogoutCustomer()
        {
            customer = "";
        }

        #endregion

        public static async Task<List<VehicleDTO>> GetVehiclesForCustomer()
        {
            try
            {
                string result = await WebServiceConnection.WebServiceGetRequest($"vehicle/{customer}/");
                var vehicles = JsonConvert.DeserializeObject<List<VehicleDTO>>(result);

                return vehicles;
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                return null;
            }
        }

        public static async Task<List<VehicleBookingDTO>> GetBookingsForCustomer()
        {
            try
            {
                string result = await WebServiceConnection.WebServiceGetRequest($"vehicle/booking/{customer}/");
                var bookings = JsonConvert.DeserializeObject<List<VehicleBookingDTO>>(result);

                return bookings;
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                return null;
            }
        }

        

        public static async Task<List<EquipmentDTO>> GetEquipment()
        {
            try
            {
                string result = await WebServiceConnection.WebServiceGetRequest($"equipment");
                var equipment = JsonConvert.DeserializeObject<List<EquipmentDTO>>(result);

                return equipment;
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                return null;
            }
        }

        #region Check Availibility

        public static async Task<bool> CheckEquipmentAvailable(List<string> equipment, DateTime startDate, DateTime endDate)
        {
            try
            {
                bool available = true;

                foreach(string id in equipment)
                {
                    var dictionary = new Dictionary<string, string>();
                    dictionary.Add("equipment", id);
                    dictionary.Add("startDate", startDate.ToString());
                    dictionary.Add("endDate", endDate.ToString());

                    string result = await WebServiceConnection.WebServicePostRequest($"equipment/available", dictionary);

                    if (bool.Parse(result) == false)
                        available = false;
                };

                return available;
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                return false;
            }
        }

        public static async Task<bool> CheckVehicleAvailable(string vehicle, DateTime startDate, DateTime endDate)
        {
            try
            {
                var dictionary = new Dictionary<string, string>();
                dictionary.Add("vehicle", vehicle);
                dictionary.Add("startDate", startDate.ToString());
                dictionary.Add("endDate", endDate.ToString());

                string result = await WebServiceConnection.WebServicePostRequest($"vehicle/available", dictionary);
                return bool.Parse(result);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                return false;
            }
        }

        #endregion

        public static async Task<bool> CreateBooking(DateTime startDate, DateTime endDate, List<string> equipment, string vehicleId, string pricePerDay)
        {
            try
            {
                var dictionary = new Dictionary<string, string>();
                dictionary.Add("vehicle", vehicleId);
                dictionary.Add("startDate", startDate.ToString());
                dictionary.Add("endDate", endDate.ToString());
                dictionary.Add("email", customer);
                dictionary.Add("pricePerDay", pricePerDay);

                string result = await WebServiceConnection.WebServicePostRequest($"vehicle/book", dictionary);

                long bookingId = long.Parse(result);
                bool successful = true;

                foreach(string id in equipment)
                {
                    var dictionary1 = new Dictionary<string, string>();
                    dictionary1.Add("equipment", id);
                    dictionary1.Add("vehicle", bookingId.ToString());

                    result = await WebServiceConnection.WebServicePostRequest($"equipment/book", dictionary1);

                    if (bool.Parse(result) == false)
                        successful = false;
                };

                return successful;
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                return false;
            }
        }

        #region Booking Changes

        public static async Task<bool> CancelBooking(long bookingId)
        {
            try
            {
                var dictionary = new Dictionary<string, string>();
                dictionary.Add("booking", bookingId.ToString());
                string result = await WebServiceConnection.WebServicePostRequest($"vehicle/cancel", dictionary);

                return bool.Parse(result);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                return false;
            }
        }

        public static async Task<bool> ExtendBooking(long vehicleBookingId)
        {
            try
            {
                var dictionary = new Dictionary<string, string>();
                dictionary.Add("booking", vehicleBookingId.ToString());

                string result = await WebServiceConnection.WebServicePutRequest($"vehicle/booking/extend", dictionary);

                return bool.Parse(result);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                return false;
            }
        }


        public static async Task<bool> LateReturnBooking(long vehicleBookingId)
        {
            try
            {
                var dictionary = new Dictionary<string, string>();
                dictionary.Add("booking", vehicleBookingId.ToString());

                string result = await WebServiceConnection.WebServicePutRequest($"vehicle/booking/late", dictionary);

                return bool.Parse(result);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                return false;
            }
        }

        public static async Task<bool> AddExtras(long vehicleBookingId, List<string> equipment)
        {
            try
            {
                bool available = true;

                foreach(string id in equipment)
                {
                    var dictionary = new Dictionary<string, string>();
                    dictionary.Add("equipment", id);
                    dictionary.Add("booking", vehicleBookingId.ToString());

                    string result = await WebServiceConnection.WebServicePostRequest($"vehicle/booking/extra", dictionary);

                    if (bool.Parse(result) == false)
                        available = false;
                };

                return available;
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                return false;
            }
        }

        #endregion

        #endregion
    }
}