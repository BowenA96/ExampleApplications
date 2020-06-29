using ClassLibrary;
using System;
using System.Collections.Generic;
using System.Windows.Forms;

namespace Forms
{
    public partial class VehiclesForm : Form
    {
        private static List<VehicleDTO> vehicles;

        public VehiclesForm()
        {
            InitializeComponent();
            UpdateForm();
        }

        private async void UpdateForm()
        {
            vehiclesList.Items.Clear();
            vehicles = await WebServiceHandler.GetVehiclesForCustomer();

            if (vehicles != null)
            {
                foreach (VehicleDTO vehicleDTO in vehicles)
                   vehiclesList.Items.Add(vehicleDTO);
            }
        }

        private void logoutButton_Click(object sender, EventArgs e)
        {
            WebServiceHandler.LogoutCustomer();
            var form = (WelcomeForm)Tag;
            form.Show();
            Close();
        }

        private void bookingButton_Click(object sender, EventArgs e)
        {
            var form = new BookingsForm();
            form.Tag = this.Tag;
            form.Show();
            Close();
        }

        private void viewVehicleButton_Click(object sender, EventArgs e)
        {
            VehicleDTO vehicleDTO = (VehicleDTO)vehiclesList.SelectedItem;

            if (vehicleDTO == null)
                return;

            WebServiceHandler.vehicle = vehicleDTO;
            var form = new VehicleForm();
            form.Tag = this.Tag;
            form.Show();
            Close();
        }
    }
}