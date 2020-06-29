using System;
using System.Collections.Concurrent;

namespace ClassLibrary
{
    public class VehicleBookingDTO
    {
        public long VehicleBookingId { get; }
        public string Email { get; }
        public VehicleDTO Vehicle { get; }
        public ConcurrentBag<EquipmentDTO> Equipment { get; }
        public DateTime StartDateTime { get; }
        public DateTime EndDateTime { get; }
        public decimal TotalPrice { get; }
        public bool Collected { get; }

        public VehicleBookingDTO(long vehicleBookingId, string email, VehicleDTO vehicle, ConcurrentBag<EquipmentDTO> equipment, DateTime startDateTime, DateTime endDateTime, decimal totalPrice, bool collected)
        {
            VehicleBookingId = vehicleBookingId;
            Email = email;
            Vehicle = vehicle;
            Equipment = equipment;
            StartDateTime = startDateTime;
            EndDateTime = endDateTime;
            TotalPrice = totalPrice;
            Collected = collected;
        }

        public override string ToString()
        {
            string equipment = "";

            foreach (EquipmentDTO e in Equipment)
                equipment = equipment + " " + e.Type;

            if (equipment == "")
            {
                return $"Email: {Email}, Vehicle: {Vehicle.Type}, Duration: {StartDateTime} - {EndDateTime}, Total Price: {TotalPrice.ToString("c")}";
            }
            else
            {
                return $"Email: {Email}, Vehicle: {Vehicle.Type}, Extras:{equipment}, Duration: {StartDateTime} - {EndDateTime}, Total Price: {TotalPrice.ToString("c")}";
            }
        }
    }
}