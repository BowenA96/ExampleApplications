using System;
using System.Security.Cryptography;
using System.Text;
using System.Windows.Forms;

namespace Forms
{
    public partial class AdminLoginForm : Form
    {
        public AdminLoginForm()
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
            string username = usernameInput.Text;
            string password = passwordInput.Text;

            if (username.Length < 4 || username.Length > 50)
                MessageBox.Show("Username must be between 4 and 50 characters.", "Invalid Username",
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

                    if (await WebServiceHandler.GetAdmin(username, password))
                    {
                        MessageBox.Show("Successfully logged in to admin account.", "Login Succesful",
                        MessageBoxButtons.OK, MessageBoxIcon.Information);

                        var form = new AdminForm();
                        form.Tag = this.Tag;
                        form.Show();
                        Close();
                    }
                    else
                        MessageBox.Show("Invalid username or password.", "Failed Login Attempt",
                        MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
        }
    }
}