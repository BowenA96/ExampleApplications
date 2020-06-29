using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;

namespace Forms
{
    public class WebServiceConnection
    {
        private static readonly string connection = "https://localhost:44386/api/";
        private static readonly HttpClient client = new HttpClient();

        public static async Task<string> WebServiceGetRequest(string url)
        {
            return await client.GetStringAsync(connection + url);
        }

        public static async Task<string> WebServicePutRequest(string url, Dictionary<string, string> data)
        {
            var content = new FormUrlEncodedContent(data);
            var response = await client.PutAsync(connection + url, content);

            return await response.Content.ReadAsStringAsync();
        }

        public static async Task<string> WebServicePostRequest(string url, Dictionary<string, string> data)
        {
            var content = new FormUrlEncodedContent(data);
            var response = await client.PostAsync(connection + url, content);

            return await response.Content.ReadAsStringAsync();
        }
    }
}