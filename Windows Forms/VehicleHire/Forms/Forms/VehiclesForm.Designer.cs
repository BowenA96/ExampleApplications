namespace Forms
{
    partial class VehiclesForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.vehiclesLabel = new System.Windows.Forms.Label();
            this.logoutButton = new System.Windows.Forms.Button();
            this.viewVehicleButton = new System.Windows.Forms.Button();
            this.vehiclesList = new System.Windows.Forms.ListBox();
            this.bookingButton = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // vehiclesLabel
            // 
            this.vehiclesLabel.AutoSize = true;
            this.vehiclesLabel.Font = new System.Drawing.Font("Verdana", 36F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.vehiclesLabel.Location = new System.Drawing.Point(443, 9);
            this.vehiclesLabel.Name = "vehiclesLabel";
            this.vehiclesLabel.Size = new System.Drawing.Size(274, 73);
            this.vehiclesLabel.TabIndex = 4;
            this.vehiclesLabel.Text = "Vehicles";
            // 
            // logoutButton
            // 
            this.logoutButton.Font = new System.Drawing.Font("Verdana", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.logoutButton.Location = new System.Drawing.Point(1022, 12);
            this.logoutButton.Name = "logoutButton";
            this.logoutButton.Size = new System.Drawing.Size(105, 33);
            this.logoutButton.TabIndex = 6;
            this.logoutButton.Text = "Logout";
            this.logoutButton.UseVisualStyleBackColor = true;
            this.logoutButton.Click += new System.EventHandler(this.logoutButton_Click);
            // 
            // viewVehicleButton
            // 
            this.viewVehicleButton.Font = new System.Drawing.Font("Verdana", 19.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.viewVehicleButton.Location = new System.Drawing.Point(204, 402);
            this.viewVehicleButton.Name = "viewVehicleButton";
            this.viewVehicleButton.Size = new System.Drawing.Size(748, 49);
            this.viewVehicleButton.TabIndex = 11;
            this.viewVehicleButton.Text = "Select Vehicle";
            this.viewVehicleButton.UseVisualStyleBackColor = true;
            this.viewVehicleButton.Click += new System.EventHandler(this.viewVehicleButton_Click);
            // 
            // vehiclesList
            // 
            this.vehiclesList.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.vehiclesList.FormattingEnabled = true;
            this.vehiclesList.ItemHeight = 16;
            this.vehiclesList.Location = new System.Drawing.Point(204, 88);
            this.vehiclesList.Name = "vehiclesList";
            this.vehiclesList.Size = new System.Drawing.Size(748, 308);
            this.vehiclesList.TabIndex = 10;
            // 
            // bookingButton
            // 
            this.bookingButton.Font = new System.Drawing.Font("Verdana", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.bookingButton.Location = new System.Drawing.Point(869, 12);
            this.bookingButton.Name = "bookingButton";
            this.bookingButton.Size = new System.Drawing.Size(147, 33);
            this.bookingButton.TabIndex = 12;
            this.bookingButton.Text = "My Bookings";
            this.bookingButton.UseVisualStyleBackColor = true;
            this.bookingButton.Click += new System.EventHandler(this.bookingButton_Click);
            // 
            // VehiclesForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(120F, 120F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.ClientSize = new System.Drawing.Size(1139, 464);
            this.Controls.Add(this.bookingButton);
            this.Controls.Add(this.viewVehicleButton);
            this.Controls.Add(this.vehiclesList);
            this.Controls.Add(this.logoutButton);
            this.Controls.Add(this.vehiclesLabel);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "VehiclesForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Vehicle Hire";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.Label vehiclesLabel;
        private System.Windows.Forms.Button logoutButton;
        private System.Windows.Forms.Button viewVehicleButton;
        private System.Windows.Forms.ListBox vehiclesList;
        private System.Windows.Forms.Button bookingButton;
    }
}