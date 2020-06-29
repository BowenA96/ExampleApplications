namespace Forms
{
    partial class BookingsForm
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
            this.vehiclesButton = new System.Windows.Forms.Button();
            this.logoutButton = new System.Windows.Forms.Button();
            this.bookingsLabel = new System.Windows.Forms.Label();
            this.cancelButton = new System.Windows.Forms.Button();
            this.bookingsList = new System.Windows.Forms.ListBox();
            this.equipmentListLabel = new System.Windows.Forms.Label();
            this.addExtraButton = new System.Windows.Forms.Button();
            this.equipmentList = new System.Windows.Forms.ListBox();
            this.extendButton = new System.Windows.Forms.Button();
            this.lateButton = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // vehiclesButton
            // 
            this.vehiclesButton.Font = new System.Drawing.Font("Verdana", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.vehiclesButton.Location = new System.Drawing.Point(842, 12);
            this.vehiclesButton.Name = "vehiclesButton";
            this.vehiclesButton.Size = new System.Drawing.Size(174, 33);
            this.vehiclesButton.TabIndex = 15;
            this.vehiclesButton.Text = "View Vehicles";
            this.vehiclesButton.UseVisualStyleBackColor = true;
            this.vehiclesButton.Click += new System.EventHandler(this.vehiclesButton_Click);
            // 
            // logoutButton
            // 
            this.logoutButton.Font = new System.Drawing.Font("Verdana", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.logoutButton.Location = new System.Drawing.Point(1022, 12);
            this.logoutButton.Name = "logoutButton";
            this.logoutButton.Size = new System.Drawing.Size(105, 33);
            this.logoutButton.TabIndex = 14;
            this.logoutButton.Text = "Logout";
            this.logoutButton.UseVisualStyleBackColor = true;
            this.logoutButton.Click += new System.EventHandler(this.logoutButton_Click);
            // 
            // bookingsLabel
            // 
            this.bookingsLabel.AutoSize = true;
            this.bookingsLabel.Font = new System.Drawing.Font("Verdana", 36F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.bookingsLabel.Location = new System.Drawing.Point(429, 9);
            this.bookingsLabel.Name = "bookingsLabel";
            this.bookingsLabel.Size = new System.Drawing.Size(303, 73);
            this.bookingsLabel.TabIndex = 13;
            this.bookingsLabel.Text = "Bookings";
            // 
            // cancelButton
            // 
            this.cancelButton.Font = new System.Drawing.Font("Verdana", 19.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.cancelButton.Location = new System.Drawing.Point(722, 408);
            this.cancelButton.Name = "cancelButton";
            this.cancelButton.Size = new System.Drawing.Size(306, 49);
            this.cancelButton.TabIndex = 17;
            this.cancelButton.Text = "Cancel Booking";
            this.cancelButton.UseVisualStyleBackColor = true;
            this.cancelButton.Click += new System.EventHandler(this.cancelButton_Click);
            // 
            // bookingsList
            // 
            this.bookingsList.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.bookingsList.FormattingEnabled = true;
            this.bookingsList.ItemHeight = 16;
            this.bookingsList.Location = new System.Drawing.Point(12, 89);
            this.bookingsList.Name = "bookingsList";
            this.bookingsList.Size = new System.Drawing.Size(1115, 308);
            this.bookingsList.TabIndex = 16;
            // 
            // equipmentListLabel
            // 
            this.equipmentListLabel.AutoSize = true;
            this.equipmentListLabel.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.equipmentListLabel.Location = new System.Drawing.Point(50, 408);
            this.equipmentListLabel.Name = "equipmentListLabel";
            this.equipmentListLabel.Size = new System.Drawing.Size(60, 17);
            this.equipmentListLabel.TabIndex = 32;
            this.equipmentListLabel.Text = "Extras:";
            // 
            // addExtraButton
            // 
            this.addExtraButton.Font = new System.Drawing.Font("Verdana", 19.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.addExtraButton.Location = new System.Drawing.Point(299, 408);
            this.addExtraButton.Name = "addExtraButton";
            this.addExtraButton.Size = new System.Drawing.Size(417, 49);
            this.addExtraButton.TabIndex = 31;
            this.addExtraButton.Text = "Add Selected Extra(s)";
            this.addExtraButton.UseVisualStyleBackColor = true;
            this.addExtraButton.Click += new System.EventHandler(this.addExtraButton_Click);
            // 
            // equipmentList
            // 
            this.equipmentList.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.equipmentList.FormattingEnabled = true;
            this.equipmentList.ItemHeight = 16;
            this.equipmentList.Location = new System.Drawing.Point(53, 428);
            this.equipmentList.Name = "equipmentList";
            this.equipmentList.SelectionMode = System.Windows.Forms.SelectionMode.MultiSimple;
            this.equipmentList.Size = new System.Drawing.Size(240, 68);
            this.equipmentList.TabIndex = 30;
            // 
            // extendButton
            // 
            this.extendButton.Font = new System.Drawing.Font("Verdana", 19.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.extendButton.Location = new System.Drawing.Point(674, 463);
            this.extendButton.Name = "extendButton";
            this.extendButton.Size = new System.Drawing.Size(417, 49);
            this.extendButton.TabIndex = 33;
            this.extendButton.Text = "Extend To 4PM Return";
            this.extendButton.UseVisualStyleBackColor = true;
            this.extendButton.Click += new System.EventHandler(this.extendButton_Click);
            // 
            // lateButton
            // 
            this.lateButton.Font = new System.Drawing.Font("Verdana", 19.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lateButton.Location = new System.Drawing.Point(299, 463);
            this.lateButton.Name = "lateButton";
            this.lateButton.Size = new System.Drawing.Size(369, 49);
            this.lateButton.TabIndex = 34;
            this.lateButton.Text = "Set For Late Return";
            this.lateButton.UseVisualStyleBackColor = true;
            this.lateButton.Click += new System.EventHandler(this.lateButton_Click);
            // 
            // BookingsForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(120F, 120F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.ClientSize = new System.Drawing.Size(1139, 525);
            this.Controls.Add(this.lateButton);
            this.Controls.Add(this.extendButton);
            this.Controls.Add(this.equipmentListLabel);
            this.Controls.Add(this.addExtraButton);
            this.Controls.Add(this.equipmentList);
            this.Controls.Add(this.cancelButton);
            this.Controls.Add(this.bookingsList);
            this.Controls.Add(this.vehiclesButton);
            this.Controls.Add(this.logoutButton);
            this.Controls.Add(this.bookingsLabel);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "BookingsForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Vehicle Hire";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button vehiclesButton;
        private System.Windows.Forms.Button logoutButton;
        private System.Windows.Forms.Label bookingsLabel;
        private System.Windows.Forms.Button cancelButton;
        private System.Windows.Forms.ListBox bookingsList;
        private System.Windows.Forms.Label equipmentListLabel;
        private System.Windows.Forms.Button addExtraButton;
        private System.Windows.Forms.ListBox equipmentList;
        private System.Windows.Forms.Button extendButton;
        private System.Windows.Forms.Button lateButton;
    }
}