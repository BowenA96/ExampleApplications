//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace DatabaseClassLibrary
{
    using System;
    using System.Collections.Generic;
    
    public partial class EquipmentBooking
    {
        public long EquipmentBookingId { get; set; }
        public long VehicleBookingId { get; set; }
        public long EquipmentId { get; set; }
    
        public virtual Equipment Equipment { get; set; }
        public virtual VehicleBooking VehicleBooking { get; set; }
    }
}