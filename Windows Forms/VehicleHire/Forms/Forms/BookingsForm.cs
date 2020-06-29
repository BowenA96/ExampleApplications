using ClassLibrary;
using System;
using System.Collections.Generic;
using System.Windows.Forms;

namespace Forms
{
    public partial class BookingsForm : Form
    {
        private static List<VehicleBookingDTO> bookings;
        private static List<EquipmentDTO> equipment;

        public BookingsForm()
        {
            InitializeComponent();
            UpdateForm();
        }

        private async void UpdateForm()
        {
            equipmentList.Items.Clear();
            bookingsList.Items.Clear();

            equipment = await WebServiceHandler.GetEquipment();
            bookings = await WebServiceHandler.GetBookingsForCustomer();

            if (equipment != null)
            {
                foreach (EquipmentDTO equipmentDTO in equipment)
                    equipmentList.Items.Add(equipmentDTO);
            }

            if (bookings != null)
            {
                foreach (VehicleBookingDTO booking in bookings)
                    bookingsList.Items.Add(booking);
            }
        }

        private void vehiclesButton_Click(object sender, System.EventArgs e)
        {
            var form = new VehiclesForm();
            form.Tag = this.Tag;
            form.Show();
            Close();
        }

        private void logoutButton_Click(object sender, System.EventArgs e)
        {
            WebServiceHandler.LogoutCustomer();
            var form = (WelcomeForm)Tag;
            form.Show();
            Close();
        }

        private async void cancelButton_Click(object sender, System.EventArgs e)
        {
            VehicleBookingDTO booking = (VehicleBookingDTO)bookingsList.SelectedItem;

            if (booking != null)
            {
                if (booking.StartDateTime <= DateTime.Now)
                {
                    MessageBox.Show("Cannot cancel a booking which has already started.", "Invalid Booking",
                        MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
                else
                {
                    await WebServiceHandler.CancelBooking(booking.VehicleBookingId);

                    MessageBox.Show("Booking succssfully cancelled.", "Cancelled Booking",
                        MessageBoxButtons.OK, MessageBoxIcon.Information);

                    UpdateForm();
                }
            }
        }

        private async void extendButton_Click(object sender, System.EventArgs e)
        {
            VehicleBookingDTO booking = (VehicleBookingDTO)bookingsList.SelectedItem;

            if (booking != null)
            {
                if (booking.EndDateTime <= DateTime.Now)
                {
                    MessageBox.Show("Cannot extend a booking which has already ended.", "Invalid Booking",
                        MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
                else if (booking.EndDateTime.Hour >= 16)
                {
                    MessageBox.Show("Cannot extend a booking which is already set to return after 4PM.", "Invalid Booking",
                        MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
                else
                {
                    if (await WebServiceHandler.ExtendBooking(booking.VehicleBookingId))
                    {
                        MessageBox.Show("Booking succssfully extended.", "Extended Booking",
                        MessageBoxButtons.OK, MessageBoxIcon.Information);

                        UpdateForm();
                    }
                    else
                    {
                        MessageBox.Show("This booking can not be extended.", "Unable To Extend Booking",
                        MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
            }
        }

        private async void lateButton_Click(object sender, System.EventArgs e)
        {
            VehicleBookingDTO booking = (VehicleBookingDTO)bookingsList.SelectedItem;

            if (booking != null)
            {
                bool eligible = false;

                foreach (VehicleBookingDTO vehicleBookingDTO in bookings)
                {
                    if (vehicleBookingDTO.EndDateTime < DateTime.Now)
                        eligible = true;
                }

                if (!eligible)
                {
                    MessageBox.Show("This booking can not be set for a late return. This feature is only available for repeat customers.", "Unable To Late Return Booking",
                        MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
                else if (booking.EndDateTime <= DateTime.Now)
                {
                    MessageBox.Show("Cannot late return a booking which has already ended.", "Invalid Booking",
                        MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
                else if (booking.EndDateTime.Hour > 18)
                {
                    MessageBox.Show("Booking is already set for late return", "Invalid Booking",
                        MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
                else
                {
                    if (await WebServiceHandler.LateReturnBooking(booking.VehicleBookingId))
                    {
                        MessageBox.Show("Booking successfully extended.", "Extended Booking",
                        MessageBoxButtons.OK, MessageBoxIcon.Information);

                        UpdateForm();
                    }
                    else
                    {
                        MessageBox.Show("This booking can not be set for a late return. This feature is only available for repeat customers.", "Unable To Late Return Booking",
                        MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
            }
        }

        private async void addExtraButton_Click(object sender, System.EventArgs e)
        {
            VehicleBookingDTO booking = (VehicleBookingDTO)bookingsList.SelectedItem;
            List<string> equipment = new List<string>();

            foreach (EquipmentDTO equipmentDTO in equipmentList.SelectedItems)
                equipment.Add(equipmentDTO.EquipmentId.ToString());

            if (equipment == null || equipment.Count == 0)
                return;

            if (booking != null)
            {
                if (booking.EndDateTime <= DateTime.Now)
                {
                    MessageBox.Show("Cannot add extra to a booking which has already ended.", "Invalid Booking",
                        MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
                else
                {
                    if (await WebServiceHandler.AddExtras(booking.VehicleBookingId, equipment))
                    {
                        MessageBox.Show("Extras succssfully added to booking.", "Added Extras",
                        MessageBoxButtons.OK, MessageBoxIcon.Information);

                        UpdateForm();
                    }
                    else
                    {
                        MessageBox.Show("The selected extras were not all available for this booking. Any extras that were available have been added to the booking.", "Unable To Add Extras",
                        MessageBoxButtons.OK, MessageBoxIcon.Error);

                        UpdateForm();
                    }
                }
            }
        }
    }
}