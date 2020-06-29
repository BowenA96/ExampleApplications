using System.IO;
using System.Reflection;
using System.Threading.Tasks;

namespace WebService
{
    public static class ExcelSpreadsheetHelper
    {
        static string path = System.IO.Path.GetDirectoryName(Assembly.GetExecutingAssembly().GetName().CodeBase).Replace("file:\\", "") + @"\DataSources\dvla.csv";

        public static bool CheckSpreadsheet(string license)
        {
            string[] lines = File.ReadAllLines(path);
            bool notFound = true;

            Parallel.ForEach(lines, l =>
            {
                string[] entry = l.Split(',');

                if (entry[0].ToString().Equals(license))
                    notFound = false;
            });

            return notFound;
        }
    }
}