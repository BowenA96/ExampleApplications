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
    [RoutePrefix("api/customer")]
    public class CustomerController : ApiController
    {
        // GET: api/customer/email/password
        [Route("{email}/{password}")]
        [HttpGet]
        public bool AttemptCustomerLogin(string email, string password)
        {
            VehicleHireEntities entities = new VehicleHireEntities();
            Customer customer = entities.Customers.Find(email);

            if (customer == null)
                return false;
            else if (customer.Password == password)
                return true;
            else
                return false;
        }

        // GET: api/customer/email/blacklisted
        [Route("{email}/blacklisted")]
        [HttpGet]
        public bool GetCustomerBlacklisted(string email)
        {
            VehicleHireEntities entities = new VehicleHireEntities();
            Customer customer = entities.Customers.Find(email);

            return customer.Blacklisted;
        }

        // GET: api/customer/email
        [Route("{email}")]
        [HttpGet]
        public bool GetCustomer(string email)
        {
            VehicleHireEntities entities = new VehicleHireEntities();
            Customer c = entities.Customers.Find(email);

            if (c == null)
                return false;
            else
                return true;
        }

        // POST: api/customer/register
        [Route("register")]
        [HttpPost]
        public async Task<bool> RegisterCustomer()
        {
            HttpContent content = Request.Content;
            var data = await content.ReadAsFormDataAsync();
            var email = data.Get("email");
            var password = data.Get("password");
            var date = data.Get("date");

            email = HttpUtility.UrlDecode(email);
            date = HttpUtility.UrlDecode(date);

            VehicleHireEntities entities = new VehicleHireEntities();

            if (GetCustomer(email) == false)
            {
                Customer customer = new Customer();
                customer.Email = email;
                customer.Password = password;
                customer.DateOfBirth = Convert.ToDateTime(date);
                customer.Blacklisted = false;

                entities.Customers.Add(customer);
                entities.SaveChanges();

                return true;
            }
            else
                return false;
        }
    }
}