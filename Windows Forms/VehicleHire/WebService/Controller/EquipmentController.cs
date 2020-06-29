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
    [RoutePrefix("api/equipment")]
    public class EquipmentController : ApiController
    {
        // GET: api/equipment
        [Route("")]
        [HttpGet]
        public IEnumerable<EquipmentDTO> GetEquipment()
        {
            VehicleHireEntities entities = new VehicleHireEntities();
            ConcurrentBag<EquipmentDTO> equipments = new ConcurrentBag<EquipmentDTO>();

            foreach (Equipment e in entities.Equipments)
            {
                EquipmentDTO equipment = new EquipmentDTO(e.EquipmentId, e.Type, e.Amount);
                equipments.Add(equipment);
            };

            return equipments;
        }

        // POST: api/equipment/available
        [Route("available")]
        [HttpPost]
        public async Task<bool> CheckEquipmentAvailablity()
        {
            HttpContent content = Request.Content;
            var data = await content.ReadAsFormDataAsync();
            var equipment = data.Get("equipment");
            var startDate = data.Get("startDate");
            var endDate = data.Get("endDate");

            long equipmentId = long.Parse(HttpUtility.UrlDecode(equipment));
            startDate = HttpUtility.UrlDecode(startDate);
            endDate = HttpUtility.UrlDecode(endDate);

            VehicleHireEntities entities = new VehicleHireEntities();
            bool available = true;

            foreach(VehicleBooking v in entities.VehicleBookings)
            {
                if ((v.StartDateTime <= DateTime.Parse(startDate)) && (DateTime.Parse(endDate) <= v.EndDateTime))
                {
                    foreach (EquipmentBooking b in v.EquipmentBookings)
                    {
                        if (b.EquipmentId == equipmentId)
                            available = false;
                    };
                }
            };

            return available;
        }

        // POST: api/equipment/book
        [Route("book")]
        [HttpPost]
        public async Task<bool> CreateBooking()
        {
            HttpContent content = Request.Content;
            var data = await content.ReadAsFormDataAsync();
            var equipment = data.Get("equipment");
            var vehicle = data.Get("vehicle");

            long equipmentId = long.Parse(HttpUtility.UrlDecode(equipment));
            long vehicleBookingId = long.Parse(HttpUtility.UrlDecode(vehicle));

            VehicleHireEntities entities = new VehicleHireEntities();

            EquipmentBooking equipmentBooking = new EquipmentBooking();
            equipmentBooking.EquipmentId = equipmentId;
            equipmentBooking.VehicleBookingId = vehicleBookingId;
            entities.EquipmentBookings.Add(equipmentBooking);
            entities.SaveChanges();

            return true;
        }
    }
}