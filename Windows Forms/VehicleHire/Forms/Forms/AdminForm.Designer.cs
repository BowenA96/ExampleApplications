namespace Forms
{
    partial class AdminForm
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
            this.logoutButton = new System.Windows.Forms.Button();
            this.previousBookingsLabel = new System.Windows.Forms.Label();
            this.previousBookingsList = new System.Windows.Forms.ListBox();
            this.blacklistButton = new System.Windows.Forms.Button();
            this.currentBookingsList = new System.Windows.Forms.ListBox();
            this.collectButton = new System.Windows.Forms.Button();
            this.licenseLabel = new System.Windows.Forms.Label();
            this.forenamesLabel = new System.Windows.Forms.Label();
            this.driversLicenseInput = new System.Windows.Forms.TextBox();
            this.forenamesInput = new System.Windows.Forms.TextBox();
            this.surnameLabel = new System.Windows.Forms.Label();
            this.surnameInput = new System.Windows.Forms.TextBox();
            this.addressLabel = new System.Windows.Forms.Label();
            this.addressInput = new System.Windows.Forms.TextBox();
            this.labelCollectableBookings = new System.Windows.Forms.Label();
            this.SuspendLayout();
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
            // previousBookingsLabel
            // 
            this.previousBookingsLabel.AutoSize = true;
            this.previousBookingsLabel.Font = new System.Drawing.Font("Verdana", 36F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.previousBookingsLabel.Location = new System.Drawing.Point(279, 9);
            this.previousBookingsLabel.Name = "previousBookingsLabel";
            this.previousBookingsLabel.Size = new System.Drawing.Size(579, 73);
            this.previousBookingsLabel.TabIndex = 5;
            this.previousBookingsLabel.Text = "Previous Bookings";
            // 
            // previousBookingsList
            // 
            this.previousBookingsList.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.previousBookingsList.FormattingEnabled = true;
            this.previousBookingsList.ItemHeight = 16;
            this.previousBookingsList.Location = new System.Drawing.Point(12, 85);
            this.previousBookingsList.Name = "previousBookingsList";
            this.previousBookingsList.Size = new System.Drawing.Size(1115, 196);
            this.previousBookingsList.TabIndex = 8;
            // 
            // blacklistButton
            // 
            this.blacklistButton.Font = new System.Drawing.Font("Verdana", 19.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.blacklistButton.Location = new System.Drawing.Point(12, 287);
            this.blacklistButton.Name = "blacklistButton";
            this.blacklistButton.Size = new System.Drawing.Size(1115, 49);
            this.blacklistButton.TabIndex = 9;
            this.blacklistButton.Text = "Blacklist Customer";
            this.blacklistButton.UseVisualStyleBackColor = true;
            this.blacklistButton.Click += new System.EventHandler(this.blacklistButton_Click);
            // 
            // currentBookingsList
            // 
            this.currentBookingsList.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.currentBookingsList.FormattingEnabled = true;
            this.currentBookingsList.ItemHeight = 16;
            this.currentBookingsList.Location = new System.Drawing.Point(12, 446);
            this.currentBookingsList.Name = "currentBookingsList";
            this.currentBookingsList.Size = new System.Drawing.Size(1115, 196);
            this.currentBookingsList.TabIndex = 10;
            // 
            // collectButton
            // 
            this.collectButton.Font = new System.Drawing.Font("Verdana", 19.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.collectButton.Location = new System.Drawing.Point(12, 710);
            this.collectButton.Name = "collectButton";
            this.collectButton.Size = new System.Drawing.Size(1115, 49);
            this.collectButton.TabIndex = 11;
            this.collectButton.Text = "Collect Vehicle";
            this.collectButton.UseVisualStyleBackColor = true;
            this.collectButton.Click += new System.EventHandler(this.collectButton_Click);
            // 
            // licenseLabel
            // 
            this.licenseLabel.AutoSize = true;
            this.licenseLabel.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.licenseLabel.Location = new System.Drawing.Point(692, 651);
            this.licenseLabel.Name = "licenseLabel";
            this.licenseLabel.Size = new System.Drawing.Size(120, 17);
            this.licenseLabel.TabIndex = 15;
            this.licenseLabel.Text = "Drivers License:";
            // 
            // forenamesLabel
            // 
            this.forenamesLabel.AutoSize = true;
            this.forenamesLabel.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.forenamesLabel.Location = new System.Drawing.Point(56, 651);
            this.forenamesLabel.Name = "forenamesLabel";
            this.forenamesLabel.Size = new System.Drawing.Size(103, 17);
            this.forenamesLabel.TabIndex = 14;
            this.forenamesLabel.Text = "Forename(s):";
            // 
            // driversLicenseInput
            // 
            this.driversLicenseInput.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.driversLicenseInput.Location = new System.Drawing.Point(818, 648);
            this.driversLicenseInput.Name = "driversLicenseInput";
            this.driversLicenseInput.Size = new System.Drawing.Size(216, 23);
            this.driversLicenseInput.TabIndex = 13;
            this.driversLicenseInput.Text = "DUCKO504067DD7UM";
            // 
            // forenamesInput
            // 
            this.forenamesInput.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.forenamesInput.Location = new System.Drawing.Point(165, 648);
            this.forenamesInput.Name = "forenamesInput";
            this.forenamesInput.Size = new System.Drawing.Size(216, 23);
            this.forenamesInput.TabIndex = 12;
            this.forenamesInput.Text = "donald";
            // 
            // surnameLabel
            // 
            this.surnameLabel.AutoSize = true;
            this.surnameLabel.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.surnameLabel.Location = new System.Drawing.Point(387, 651);
            this.surnameLabel.Name = "surnameLabel";
            this.surnameLabel.Size = new System.Drawing.Size(77, 17);
            this.surnameLabel.TabIndex = 17;
            this.surnameLabel.Text = "Surname:";
            // 
            // surnameInput
            // 
            this.surnameInput.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.surnameInput.Location = new System.Drawing.Point(470, 648);
            this.surnameInput.Name = "surnameInput";
            this.surnameInput.Size = new System.Drawing.Size(216, 23);
            this.surnameInput.TabIndex = 16;
            this.surnameInput.Text = "duck";
            // 
            // addressLabel
            // 
            this.addressLabel.AutoSize = true;
            this.addressLabel.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.addressLabel.Location = new System.Drawing.Point(87, 684);
            this.addressLabel.Name = "addressLabel";
            this.addressLabel.Size = new System.Drawing.Size(72, 17);
            this.addressLabel.TabIndex = 19;
            this.addressLabel.Text = "Address:";
            // 
            // addressInput
            // 
            this.addressInput.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.addressInput.Location = new System.Drawing.Point(165, 681);
            this.addressInput.Name = "addressInput";
            this.addressInput.Size = new System.Drawing.Size(869, 23);
            this.addressInput.TabIndex = 18;
            this.addressInput.Text = "Duckulla Villa, Disneyland, Warmington0on-Sea, WM2 9DA";
            // 
            // labelCollectableBookings
            // 
            this.labelCollectableBookings.AutoSize = true;
            this.labelCollectableBookings.Font = new System.Drawing.Font("Verdana", 36F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelCollectableBookings.Location = new System.Drawing.Point(234, 370);
            this.labelCollectableBookings.Name = "labelCollectableBookings";
            this.labelCollectableBookings.Size = new System.Drawing.Size(650, 73);
            this.labelCollectableBookings.TabIndex = 20;
            this.labelCollectableBookings.Text = "Collectable Bookings";
            // 
            // AdminForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(120F, 120F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.ClientSize = new System.Drawing.Size(1139, 768);
            this.Controls.Add(this.labelCollectableBookings);
            this.Controls.Add(this.addressLabel);
            this.Controls.Add(this.addressInput);
            this.Controls.Add(this.surnameLabel);
            this.Controls.Add(this.surnameInput);
            this.Controls.Add(this.licenseLabel);
            this.Controls.Add(this.forenamesLabel);
            this.Controls.Add(this.driversLicenseInput);
            this.Controls.Add(this.forenamesInput);
            this.Controls.Add(this.collectButton);
            this.Controls.Add(this.currentBookingsList);
            this.Controls.Add(this.blacklistButton);
            this.Controls.Add(this.previousBookingsList);
            this.Controls.Add(this.logoutButton);
            this.Controls.Add(this.previousBookingsLabel);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "AdminForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Vehicle Hire";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button logoutButton;
        private System.Windows.Forms.Label previousBookingsLabel;
        private System.Windows.Forms.ListBox previousBookingsList;
        private System.Windows.Forms.Button blacklistButton;
        private System.Windows.Forms.ListBox currentBookingsList;
        private System.Windows.Forms.Button collectButton;
        private System.Windows.Forms.Label licenseLabel;
        private System.Windows.Forms.Label forenamesLabel;
        private System.Windows.Forms.TextBox driversLicenseInput;
        private System.Windows.Forms.TextBox forenamesInput;
        private System.Windows.Forms.Label surnameLabel;
        private System.Windows.Forms.TextBox surnameInput;
        private System.Windows.Forms.Label addressLabel;
        private System.Windows.Forms.TextBox addressInput;
        private System.Windows.Forms.Label labelCollectableBookings;
    }
}