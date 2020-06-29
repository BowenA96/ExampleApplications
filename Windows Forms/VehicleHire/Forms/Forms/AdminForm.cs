using ClassLibrary;
using System.Collections.Generic;
using System.Windows.Forms;

namespace Forms
{
    public partial class AdminForm : Form
    {
        List<VehicleBookingDTO> pastBookings;
        List<VehicleBookingDTO> currentBookings;

        public AdminForm()
        {
            InitializeComponent();
            UpdateForm();
        }

        private async void UpdateForm()
        {
            previousBookingsList.Items.Clear();
            pastBookings = await WebServiceHandler.GetPastBookings();

            if (pastBookings != null)
            {
                foreach (VehicleBookingDTO vehicleBookingDTO in pastBookings)
                    previousBookingsList.Items.Add(vehicleBookingDTO);
            }

            currentBookingsList.Items.Clear();
            currentBookings = await WebServiceHandler.GetCurrentBookings();

            if (currentBookings != null)
            {
                foreach (VehicleBookingDTO vehicleBookingDTO in currentBookings)
                    currentBookingsList.Items.Add(vehicleBookingDTO);
            }
        }

        private void logoutButton_Click(object sender, System.EventArgs e)
        {
            var form = (WelcomeForm)Tag;
            form.Show();
            Close();
        }

        private async void blacklistButton_Click(object sender, System.EventArgs e)
        {
            VehicleBookingDTO vehicleBookingDTO = (VehicleBookingDTO) previousBookingsList.SelectedItem;

            if (vehicleBookingDTO == null)
                return;

            if (await WebServiceHandler.BlacklistCustomer(vehicleBookingDTO.Email))
            {
                MessageBox.Show("Succesfully blacklisted selected customer.", "Blacklisted Customer",
                    MessageBoxButtons.OK, MessageBoxIcon.Information);

                UpdateForm();
            }
            else
                MessageBox.Show("An error occured when attempting to blacklist the selected customer.", "Failed To Blacklist Customer",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
        }

        private async void collectButton_Click(object sender, System.EventArgs e)
        {
            VehicleBookingDTO vehicleBookingDTO = (VehicleBookingDTO)currentBookingsList.SelectedItem;

            if (vehicleBookingDTO == null)
                return;

            string firstName = forenamesInput.Text;
            string lastName = surnameInput.Text;
            string address = addressInput.Text;
            string license = driversLicenseInput.Text;

            if (firstName.Length < 2 || firstName.Length > 100)
                MessageBox.Show("Forenames must be between 2 and 100 characters.", "Invalid Forenames",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            else if (lastName.Length < 2 || lastName.Length > 100)
                MessageBox.Show("Surname must be between 2 and 100 characters.", "Invalid Surname",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            else if (address.Length < 2)
                MessageBox.Show("Address must be entered.", "Invalid Address",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            else if (license.Length != 16)
                MessageBox.Show("Drivers license must be 16 characters.", "Invalid Drivers License",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            else
            {
                if (await WebServiceHandler.CheckBookingCollectable(vehicleBookingDTO.VehicleBookingId, firstName, lastName, address, license))
                {
                    if(await WebServiceHandler.CollectBooking(vehicleBookingDTO.VehicleBookingId))
                    {
                        MessageBox.Show("Booking has been registered as collected.", "Booking Collected",
                        MessageBoxButtons.OK, MessageBoxIcon.Information);

                        UpdateForm();
                    }
                    else
                    {
                        MessageBox.Show("Error when setting booking to collected.", "Booking Collection Error",
                        MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
                else
                {
                    MessageBox.Show("The customer should not be allowed to collect the vehicle for booking.", "Booking Collection Not Allowed",
                        MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
            }
        }
    }
}