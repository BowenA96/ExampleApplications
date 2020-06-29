using ClassLibrary;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Forms
{
    public partial class VehicleForm : Form
    {
        private static VehicleDTO vehicle;
        private static List<EquipmentDTO> equipment;

        public VehicleForm()
        {
            InitializeComponent();
            UpdateForm();
        }

        private async void UpdateForm()
        {
            selectedVehicleText.Text = "";
            vehicle = WebServiceHandler.vehicle;

            if (vehicle != null)
            {
                selectedVehicleText.Text = vehicle.ToString();
            }

            equipment = await WebServiceHandler.GetEquipment();

            if (equipment != null)
            {
                foreach (EquipmentDTO equipmentDTO in equipment)
                    equipmentList.Items.Add(equipmentDTO);
            }
        }

        private DateTime UpdateDateTime(DateTime dateTime, string time)
        {
            if (time.Equals("Morning (8AM)"))
            {
                return new DateTime(dateTime.Year, dateTime.Month, dateTime.Day, 8, 0, 0);
            }
            else if (time.Equals("Afternoon (1PM)"))
            {
                return new DateTime(dateTime.Year, dateTime.Month, dateTime.Day, 13, 0, 0);
            }
            else
            {
                return new DateTime(dateTime.Year, dateTime.Month, dateTime.Day, 18, 0, 0);
            }
        }

        private async Task<bool> CheckBookingCanBeMade(DateTime startDate, DateTime endDate, List<string> equipment, string vehicleId)
        {
            if (startDate < DateTime.Now)
                MessageBox.Show("Start date and time must be after the current date and time.", "Invalid Date And Time",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            else if (startDate >= endDate)
                MessageBox.Show("End date and time cannot be before the start date and time", "Invalid Date And Time",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            else if ((endDate - startDate).TotalDays > 14)
                MessageBox.Show("Vehicles are not available to book for longer than 2 weeks", "Invalid Date And Time",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            else
            {
                if (await WebServiceHandler.CheckEquipmentAvailable(equipment, startDate, endDate))
                {
                    if (await WebServiceHandler.CheckVehicleAvailable(vehicle.VehicleId.ToString(), startDate, endDate))
                    {
                        return true;
                    }
                    else
                    {
                        MessageBox.Show("The selected vehicle is not available for the selected time frame.", "Vehicle Unavailable",
                            MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
                else
                {
                    MessageBox.Show("The selected extras are not available for the selected time frame.", "Extras Unavailable",
                        MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
            return false;
        }

        private void bookingButton_Click(object sender, EventArgs e)
        {
            var form = new BookingsForm();
            form.Tag = this.Tag;
            form.Show();
            Close();
        }

        private void logoutButton_Click(object sender, EventArgs e)
        {
            WebServiceHandler.LogoutCustomer();
            var form = (WelcomeForm)Tag;
            form.Show();
            Close();
        }

        private void backButton_Click(object sender, EventArgs e)
        {
            var form = new VehiclesForm();
            form.Tag = this.Tag;
            form.Show();
            Close();
        }

        private async void availableButton_Click(object sender, EventArgs e)
        {
            List<string> equipment = new List<string>();

            foreach (EquipmentDTO equipmentDTO in equipmentList.SelectedItems)
                equipment.Add(equipmentDTO.EquipmentId.ToString());

            string startTime = (string)startTimeInput.SelectedItem;
            string endTime = (string)endTimeInput.SelectedItem;

            if (startTime == null || endTime == null)
            {
                MessageBox.Show("Times for start and for end must be selected.", "Invalid Times",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            DateTime startDate = UpdateDateTime(startDateInput.Value, startTime);
            DateTime endDate = UpdateDateTime(endDateInput.Value, endTime);

            if (await CheckBookingCanBeMade(startDate, endDate, equipment, vehicle.VehicleId.ToString()))
                MessageBox.Show("The selected extras and vehicle are available for the selected time frame.", "Booking Available",
                    MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private async void bookButton_Click(object sender, EventArgs e)
        {
            List<string> equipment = new List<string>();

            foreach (EquipmentDTO equipmentDTO in equipmentList.SelectedItems)
                equipment.Add(equipmentDTO.EquipmentId.ToString());

            string startTime = (string)startTimeInput.SelectedItem;
            string endTime = (string)endTimeInput.SelectedItem;

            if (startTime == null || endTime == null)
            {
                MessageBox.Show("Times for start and for end must be selected.", "Invalid Times",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            DateTime startDate = UpdateDateTime(startDateInput.Value, startTime);
            DateTime endDate = UpdateDateTime(endDateInput.Value, endTime);

            if (await CheckBookingCanBeMade(startDate, endDate, equipment, vehicle.VehicleId.ToString()))
            {
                if (await WebServiceHandler.CreateBooking(startDate, endDate, equipment, vehicle.VehicleId.ToString(), vehicle.PricePerDay.ToString()))
                {
                    MessageBox.Show("Booking has been made successfully.", "Booking Successful",
                        MessageBoxButtons.OK, MessageBoxIcon.Information);

                    var form = new BookingsForm();
                    form.Tag = this.Tag;
                    form.Show();
                    Close();
                }
            }
                
        }
    }
}