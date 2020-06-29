using System;
using System.Security.Cryptography;
using System.Text;
using System.Windows.Forms;

namespace Forms
{
    public partial class LoginForm : Form
    {
        public LoginForm()
        {
            InitializeComponent();
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

            if (email.Length < 3 || email.Length > 254)
                MessageBox.Show("Email must be between 3 and 254 characters.", "Invalid Email",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            else if (password.Length < 4 || password.Length > 50)
                MessageBox.Show("Password must be between 4 and 50 characters.", "Invalid Password",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            else
            {
                using (var hash = SHA512.Create())
                {
                    var hashedbytes = hash.ComputeHash(Encoding.UTF8.GetBytes(password));
                    password = BitConverter.ToString(hashedbytes).Replace("-", "");

                    if (await WebServiceHandler.GetCustomer(email, password))
                    {
                        if (!await WebServiceHandler.GetCustomerBlacklisted(email))
                        {
                            MessageBox.Show("Successfully logged in to account.", "Login Succesful",
                            MessageBoxButtons.OK, MessageBoxIcon.Information);

                            var form = new VehiclesForm();
                            form.Tag = this.Tag;
                            form.Show();
                            Close();
                        }
                        else
                        {
                            MessageBox.Show("Customer has been blacklisted and can no longer make bookings.", "Failed Login Attempt",
                            MessageBoxButtons.OK, MessageBoxIcon.Error);
                        }
                    }
                    else
                        MessageBox.Show("Invalid email or password.", "Failed Login Attempt",
                        MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
        }
    }
}
