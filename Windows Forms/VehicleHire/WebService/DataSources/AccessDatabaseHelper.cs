using System;
using System.Data.OleDb;
using System.Reflection;

namespace WebService
{
    public static class AccessDatabaseHelper
    {
        private static string connectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + System.IO.Path.GetDirectoryName(Assembly.GetExecutingAssembly().GetName().CodeBase).Replace("file:\\", "") + @"\DataSources\ABI_DRIVER_FRAUD1.accdb";
        private static OleDbConnection oleDbConnection;

        public static bool CheckDatabase(string firstName, string lastName, string address)
        {
            string sql = $"SELECT * FROM fraudulent_claim_data WHERE FAMILY_NAME = '{lastName.ToUpper()}' AND FORENAMES = '{firstName.ToUpper()}' AND ADDRESS_OF_CLAIM = '{address}';";
            
            try
            {
                oleDbConnection = new OleDbConnection(connectionString);
                OleDbCommand command = new OleDbCommand(sql, oleDbConnection);
                oleDbConnection.Open();

                OleDbDataReader reader = command.ExecuteReader();

                int i = 0;
                while(reader.Read())
                {
                    i++;
                }

                oleDbConnection.Close();

                if (i == 0)
                    return true;
                else
                    return false;
            }
            catch (Exception e)
            {
                oleDbConnection.Close();

                return false;
            }
        }
    }
}