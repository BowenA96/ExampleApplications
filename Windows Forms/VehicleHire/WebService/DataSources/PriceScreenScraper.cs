using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text.RegularExpressions;

namespace WebService
{
    public static class PriceScreenScraper
    {
        public static string url = "https://www.ebay.co.uk/b/Medium-Car-Hire-Car-Rental/147399/bn_7026081330?rt=nc&listingOnly=1&_sop=2&_udlo=40";

        public static decimal GetBasePrice()
        {
            string result = GetWebResponse();

            if (result == "")
                return 40;
            else
            {
                return decimal.Parse(result);
            }
        }

        private static string GetWebResponse()
        {
            HttpWebRequest httpWebRequest = (HttpWebRequest)WebRequest.Create(url.Trim());
            httpWebRequest.ContentType = "text/html";
            httpWebRequest.Method = "GET";
            httpWebRequest.Proxy = WebRequest.DefaultWebProxy;
            httpWebRequest.Proxy.Credentials = CredentialCache.DefaultCredentials;

            string result = "";

            try
            {
                HttpWebResponse httpWebResponse = (HttpWebResponse)httpWebRequest.GetResponse();
                if (httpWebResponse.StatusCode == HttpStatusCode.OK)
                {
                    StreamReader streamReader = new StreamReader(httpWebResponse.GetResponseStream());
                    result = streamReader.ReadToEnd();
                    streamReader.Close();

                    Regex regex = new Regex("<span class=\"s-item__price\">(.*?)</span>");
                    var matches = regex.Matches(result);

                    List<string> values = new List<string>();

                    foreach(Match m in matches)
                    {
                        values.Add(Regex.Replace(m.Groups[0].Value, "<.*?>", ""));
                    }

                    return Regex.Replace(values[2], "£", "");
                }

                return result;
            }
            catch (Exception e)
            {
                return result;
            }
        }
    }
}