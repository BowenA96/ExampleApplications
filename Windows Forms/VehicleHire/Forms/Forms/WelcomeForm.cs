using System;
using System.Windows.Forms;

namespace Forms
{
    public partial class WelcomeForm : Form
    {
        public WelcomeForm()
        {
            InitializeComponent();
        }

        private void loginButton_Click(object sender, EventArgs e)
        {
            LoginForm form = new LoginForm();
            form.Tag = this;
            form.Show(this);
            Hide();
        }

        private void registerButton_Click(object sender, EventArgs e)
        {
            RegisterForm form = new RegisterForm();
            form.Tag = this;
            form.Show(this);
            Hide();
        }

        private void adminButton_Click(object sender, EventArgs e)
        {
            AdminLoginForm form = new AdminLoginForm();
            form.Tag = this;
            form.Show(this);
            Hide();
        }
    }
}