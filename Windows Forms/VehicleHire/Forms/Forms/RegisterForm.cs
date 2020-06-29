using System;
using System.Security.Cryptography;
using System.Text;
using System.Windows.Forms;

namespace Forms
{
    public partial class RegisterForm : Form
    {
        public RegisterForm()
        {
            InitializeComponent();
        }

        private bool IsEmailValid(string email)
        {
            try
            {
                var address = new System.Net.Mail.MailAddress(email);
                return address.Address == email;
            }
            catch
            {
                return false;
            }
        }

        private void backButton_Click(object sender, EventArgs e)
        {
            var form = (WelcomeForm)Tag;
            form.Show();
            Close();
        }     

        private async void loginButton_Click(object sender, EventArgs e)
        {
            string email = emailInput.Text;
            string password = passwordInput.Text;
            DateTime dateTime = dateTimeInput.Value;

            if (email.Length < 3 || email.Length > 254)
                MessageBox.Show("Email must be between 3 and 254 characters.", "Invalid Email",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            else if (password.Length < 4 || password.Length > 50)
                MessageBox.Show("Password must be between 4 and 50 characters.", "Invalid Password",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            else if (!IsEmailValid(email))
                MessageBox.Show("Not a valid email address.", "Invalid Email",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            else if (dateTime > DateTime.Now)
                MessageBox.Show("An invalid age was entered.", "Invalid Age",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            else
            {
                using (var hash = SHA512.Create())
                {
                    var hashedbytes = hash.ComputeHash(Encoding.UTF8.GetBytes(password));
                    password = BitConverter.ToString(hashedbytes).Replace("-", "");

                    if (await WebServiceHandler.RegisterCustomer(email, password, dateTime))
                    {
                        MessageBox.Show("Successfully registered new account.", "Registration Succesful",
                        MessageBoxButtons.OK, MessageBoxIcon.Information);

                        var form = new VehiclesForm();
                        form.Tag = this.Tag;
                        form.Show();
                        Close();
                    }
                    else
                        MessageBox.Show("Invalid email, password or date of birth.", "Failed Registration Attempt",
                        MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
        }
    }
}