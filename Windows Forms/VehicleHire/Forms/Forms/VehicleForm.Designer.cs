namespace Forms
{
    partial class VehicleForm
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
            this.bookingButton = new System.Windows.Forms.Button();
            this.logoutButton = new System.Windows.Forms.Button();
            this.vehicleLabel = new System.Windows.Forms.Label();
            this.backButton = new System.Windows.Forms.Button();
            this.bookButton = new System.Windows.Forms.Button();
            this.equipmentList = new System.Windows.Forms.ListBox();
            this.availableButton = new System.Windows.Forms.Button();
            this.selectedVehicleLabel = new System.Windows.Forms.Label();
            this.selectedVehicleText = new System.Windows.Forms.Label();
            this.startDateInput = new System.Windows.Forms.DateTimePicker();
            this.endDateInput = new System.Windows.Forms.DateTimePicker();
            this.startTimeInput = new System.Windows.Forms.CheckedListBox();
            this.endTimeInput = new System.Windows.Forms.CheckedListBox();
            this.startDateLabel = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.equipmentListLabel = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // bookingButton
            // 
            this.bookingButton.Font = new System.Drawing.Font("Verdana", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.bookingButton.Location = new System.Drawing.Point(869, 9);
            this.bookingButton.Name = "bookingButton";
            this.bookingButton.Size = new System.Drawing.Size(147, 33);
            this.bookingButton.TabIndex = 15;
            this.bookingButton.Text = "My Bookings";
            this.bookingButton.UseVisualStyleBackColor = true;
            this.bookingButton.Click += new System.EventHandler(this.bookingButton_Click);
            // 
            // logoutButton
            // 
            this.logoutButton.Font = new System.Drawing.Font("Verdana", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.logoutButton.Location = new System.Drawing.Point(1022, 9);
            this.logoutButton.Name = "logoutButton";
            this.logoutButton.Size = new System.Drawing.Size(105, 33);
            this.logoutButton.TabIndex = 14;
            this.logoutButton.Text = "Logout";
            this.logoutButton.UseVisualStyleBackColor = true;
            this.logoutButton.Click += new System.EventHandler(this.logoutButton_Click);
            // 
            // vehicleLabel
            // 
            this.vehicleLabel.AutoSize = true;
            this.vehicleLabel.Font = new System.Drawing.Font("Verdana", 36F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.vehicleLabel.Location = new System.Drawing.Point(377, 9);
            this.vehicleLabel.Name = "vehicleLabel";
            this.vehicleLabel.Size = new System.Drawing.Size(413, 73);
            this.vehicleLabel.TabIndex = 13;
            this.vehicleLabel.Text = "Book Vehicle";
            // 
            // backButton
            // 
            this.backButton.Font = new System.Drawing.Font("Verdana", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.backButton.Location = new System.Drawing.Point(1022, 49);
            this.backButton.Name = "backButton";
            this.backButton.Size = new System.Drawing.Size(105, 33);
            this.backButton.TabIndex = 16;
            this.backButton.Text = "Go Back";
            this.backButton.UseVisualStyleBackColor = true;
            this.backButton.Click += new System.EventHandler(this.backButton_Click);
            // 
            // bookButton
            // 
            this.bookButton.Font = new System.Drawing.Font("Verdana", 19.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.bookButton.Location = new System.Drawing.Point(442, 399);
            this.bookButton.Name = "bookButton";
            this.bookButton.Size = new System.Drawing.Size(271, 49);
            this.bookButton.TabIndex = 18;
            this.bookButton.Text = "Book Vehicle";
            this.bookButton.UseVisualStyleBackColor = true;
            this.bookButton.Click += new System.EventHandler(this.bookButton_Click);
            // 
            // equipmentList
            // 
            this.equipmentList.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.equipmentList.FormattingEnabled = true;
            this.equipmentList.ItemHeight = 16;
            this.equipmentList.Location = new System.Drawing.Point(224, 186);
            this.equipmentList.Name = "equipmentList";
            this.equipmentList.SelectionMode = System.Windows.Forms.SelectionMode.MultiSimple;
            this.equipmentList.Size = new System.Drawing.Size(240, 68);
            this.equipmentList.TabIndex = 17;
            // 
            // availableButton
            // 
            this.availableButton.Font = new System.Drawing.Font("Verdana", 19.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.availableButton.Location = new System.Drawing.Point(413, 344);
            this.availableButton.Name = "availableButton";
            this.availableButton.Size = new System.Drawing.Size(333, 49);
            this.availableButton.TabIndex = 19;
            this.availableButton.Text = "Check Availability";
            this.availableButton.UseVisualStyleBackColor = true;
            this.availableButton.Click += new System.EventHandler(this.availableButton_Click);
            // 
            // selectedVehicleLabel
            // 
            this.selectedVehicleLabel.AutoSize = true;
            this.selectedVehicleLabel.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.selectedVehicleLabel.Location = new System.Drawing.Point(139, 111);
            this.selectedVehicleLabel.Name = "selectedVehicleLabel";
            this.selectedVehicleLabel.Size = new System.Drawing.Size(130, 17);
            this.selectedVehicleLabel.TabIndex = 20;
            this.selectedVehicleLabel.Text = "Selected Vehicle: ";
            // 
            // selectedVehicleText
            // 
            this.selectedVehicleText.AutoSize = true;
            this.selectedVehicleText.Font = new System.Drawing.Font("Verdana", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.selectedVehicleText.Location = new System.Drawing.Point(135, 128);
            this.selectedVehicleText.Name = "selectedVehicleText";
            this.selectedVehicleText.Size = new System.Drawing.Size(141, 18);
            this.selectedVehicleText.TabIndex = 21;
            this.selectedVehicleText.Text = "Placeholder text";
            // 
            // startDateInput
            // 
            this.startDateInput.Location = new System.Drawing.Point(486, 186);
            this.startDateInput.Name = "startDateInput";
            this.startDateInput.Size = new System.Drawing.Size(200, 22);
            this.startDateInput.TabIndex = 22;
            // 
            // endDateInput
            // 
            this.endDateInput.Location = new System.Drawing.Point(714, 186);
            this.endDateInput.Name = "endDateInput";
            this.endDateInput.Size = new System.Drawing.Size(200, 22);
            this.endDateInput.TabIndex = 23;
            // 
            // startTimeInput
            // 
            this.startTimeInput.FormattingEnabled = true;
            this.startTimeInput.Items.AddRange(new object[] {
            "Morning (8AM)",
            "Afternoon (1PM)"});
            this.startTimeInput.Location = new System.Drawing.Point(486, 214);
            this.startTimeInput.Name = "startTimeInput";
            this.startTimeInput.Size = new System.Drawing.Size(200, 55);
            this.startTimeInput.TabIndex = 24;
            // 
            // endTimeInput
            // 
            this.endTimeInput.FormattingEnabled = true;
            this.endTimeInput.Items.AddRange(new object[] {
            "Morning (8AM)",
            "Afternoon (1PM)",
            "Evening (6PM)"});
            this.endTimeInput.Location = new System.Drawing.Point(714, 214);
            this.endTimeInput.Name = "endTimeInput";
            this.endTimeInput.Size = new System.Drawing.Size(200, 72);
            this.endTimeInput.TabIndex = 25;
            // 
            // startDateLabel
            // 
            this.startDateLabel.AutoSize = true;
            this.startDateLabel.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.startDateLabel.Location = new System.Drawing.Point(483, 166);
            this.startDateLabel.Name = "startDateLabel";
            this.startDateLabel.Size = new System.Drawing.Size(50, 17);
            this.startDateLabel.TabIndex = 26;
            this.startDateLabel.Text = "Start:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.Location = new System.Drawing.Point(711, 166);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(41, 17);
            this.label3.TabIndex = 27;
            this.label3.Text = "End:";
            // 
            // equipmentListLabel
            // 
            this.equipmentListLabel.AutoSize = true;
            this.equipmentListLabel.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.equipmentListLabel.Location = new System.Drawing.Point(221, 166);
            this.equipmentListLabel.Name = "equipmentListLabel";
            this.equipmentListLabel.Size = new System.Drawing.Size(60, 17);
            this.equipmentListLabel.TabIndex = 29;
            this.equipmentListLabel.Text = "Extras:";
            // 
            // VehicleForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(120F, 120F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.ClientSize = new System.Drawing.Size(1139, 460);
            this.Controls.Add(this.equipmentListLabel);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.startDateLabel);
            this.Controls.Add(this.endTimeInput);
            this.Controls.Add(this.startTimeInput);
            this.Controls.Add(this.endDateInput);
            this.Controls.Add(this.startDateInput);
            this.Controls.Add(this.selectedVehicleText);
            this.Controls.Add(this.selectedVehicleLabel);
            this.Controls.Add(this.availableButton);
            this.Controls.Add(this.bookButton);
            this.Controls.Add(this.equipmentList);
            this.Controls.Add(this.backButton);
            this.Controls.Add(this.bookingButton);
            this.Controls.Add(this.logoutButton);
            this.Controls.Add(this.vehicleLabel);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "VehicleForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Vehicle Hire";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button bookingButton;
        private System.Windows.Forms.Button logoutButton;
        private System.Windows.Forms.Label vehicleLabel;
        private System.Windows.Forms.Button backButton;
        private System.Windows.Forms.Button bookButton;
        private System.Windows.Forms.ListBox equipmentList;
        private System.Windows.Forms.Button availableButton;
        private System.Windows.Forms.Label selectedVehicleLabel;
        private System.Windows.Forms.Label selectedVehicleText;
        private System.Windows.Forms.DateTimePicker startDateInput;
        private System.Windows.Forms.DateTimePicker endDateInput;
        private System.Windows.Forms.CheckedListBox startTimeInput;
        private System.Windows.Forms.CheckedListBox endTimeInput;
        private System.Windows.Forms.Label startDateLabel;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label equipmentListLabel;
    }
}