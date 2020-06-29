namespace Forms
{
    partial class RegisterForm
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
            this.registerLabel = new System.Windows.Forms.Label();
            this.backButton = new System.Windows.Forms.Button();
            this.passwordLabel = new System.Windows.Forms.Label();
            this.emailLabel = new System.Windows.Forms.Label();
            this.passwordInput = new System.Windows.Forms.TextBox();
            this.emailInput = new System.Windows.Forms.TextBox();
            this.loginButton = new System.Windows.Forms.Button();
            this.dateTimeInput = new System.Windows.Forms.DateTimePicker();
            this.dateTimeLabel = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // registerLabel
            // 
            this.registerLabel.AutoSize = true;
            this.registerLabel.Font = new System.Drawing.Font("Verdana", 36F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.registerLabel.Location = new System.Drawing.Point(428, 9);
            this.registerLabel.Name = "registerLabel";
            this.registerLabel.Size = new System.Drawing.Size(279, 73);
            this.registerLabel.TabIndex = 1;
            this.registerLabel.Text = "Register";
            // 
            // backButton
            // 
            this.backButton.Font = new System.Drawing.Font("Verdana", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.backButton.Location = new System.Drawing.Point(1022, 12);
            this.backButton.Name = "backButton";
            this.backButton.Size = new System.Drawing.Size(105, 33);
            this.backButton.TabIndex = 4;
            this.backButton.Text = "Go Back";
            this.backButton.UseVisualStyleBackColor = true;
            this.backButton.Click += new System.EventHandler(this.backButton_Click);
            // 
            // passwordLabel
            // 
            this.passwordLabel.AutoSize = true;
            this.passwordLabel.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.passwordLabel.Location = new System.Drawing.Point(418, 213);
            this.passwordLabel.Name = "passwordLabel";
            this.passwordLabel.Size = new System.Drawing.Size(81, 17);
            this.passwordLabel.TabIndex = 19;
            this.passwordLabel.Text = "Password:";
            // 
            // emailLabel
            // 
            this.emailLabel.AutoSize = true;
            this.emailLabel.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.emailLabel.Location = new System.Drawing.Point(449, 151);
            this.emailLabel.Name = "emailLabel";
            this.emailLabel.Size = new System.Drawing.Size(50, 17);
            this.emailLabel.TabIndex = 18;
            this.emailLabel.Text = "Email:";
            // 
            // passwordInput
            // 
            this.passwordInput.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.passwordInput.Location = new System.Drawing.Point(505, 210);
            this.passwordInput.Name = "passwordInput";
            this.passwordInput.Size = new System.Drawing.Size(216, 23);
            this.passwordInput.TabIndex = 17;
            this.passwordInput.UseSystemPasswordChar = true;
            // 
            // emailInput
            // 
            this.emailInput.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.emailInput.Location = new System.Drawing.Point(505, 148);
            this.emailInput.Name = "emailInput";
            this.emailInput.Size = new System.Drawing.Size(216, 23);
            this.emailInput.TabIndex = 16;
            // 
            // loginButton
            // 
            this.loginButton.Font = new System.Drawing.Font("Verdana", 19.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.loginButton.Location = new System.Drawing.Point(505, 332);
            this.loginButton.Name = "loginButton";
            this.loginButton.Size = new System.Drawing.Size(129, 49);
            this.loginButton.TabIndex = 15;
            this.loginButton.Text = "Login";
            this.loginButton.UseVisualStyleBackColor = true;
            this.loginButton.Click += new System.EventHandler(this.loginButton_Click);
            // 
            // dateTimeInput
            // 
            this.dateTimeInput.Location = new System.Drawing.Point(505, 271);
            this.dateTimeInput.Name = "dateTimeInput";
            this.dateTimeInput.Size = new System.Drawing.Size(216, 22);
            this.dateTimeInput.TabIndex = 20;
            // 
            // dateTimeLabel
            // 
            this.dateTimeLabel.AutoSize = true;
            this.dateTimeLabel.Font = new System.Drawing.Font("Verdana", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.dateTimeLabel.Location = new System.Drawing.Point(392, 274);
            this.dateTimeLabel.Name = "dateTimeLabel";
            this.dateTimeLabel.Size = new System.Drawing.Size(107, 17);
            this.dateTimeLabel.TabIndex = 21;
            this.dateTimeLabel.Text = "Date Of Birth:";
            // 
            // RegisterForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(120F, 120F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.ClientSize = new System.Drawing.Size(1139, 464);
            this.Controls.Add(this.dateTimeLabel);
            this.Controls.Add(this.dateTimeInput);
            this.Controls.Add(this.passwordLabel);
            this.Controls.Add(this.emailLabel);
            this.Controls.Add(this.passwordInput);
            this.Controls.Add(this.emailInput);
            this.Controls.Add(this.loginButton);
            this.Controls.Add(this.backButton);
            this.Controls.Add(this.registerLabel);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "RegisterForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Vehicle Hire";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label registerLabel;
        private System.Windows.Forms.Button backButton;
        private System.Windows.Forms.Label passwordLabel;
        private System.Windows.Forms.Label emailLabel;
        private System.Windows.Forms.TextBox passwordInput;
        private System.Windows.Forms.TextBox emailInput;
        private System.Windows.Forms.Button loginButton;
        private System.Windows.Forms.DateTimePicker dateTimeInput;
        private System.Windows.Forms.Label dateTimeLabel;
    }
}