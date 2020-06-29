import 'package:http/http.dart';

// Class for sending web service requests
class WebServiceRequest {
  // Constructor
  WebServiceRequest();

  // Function for get requests
  Future<Response> getRequest(String url) async {
    // Retrieve the response from the get request for the specified url
    Response response = await get(
        'https://hotelroombookingwebservicealexbowenfyp.azurewebsites.net/' +
            url);

    print('Get response: ' + response.body);

    // Return the response
    return response;
  }

  // Function for delete requests
  Future<Response> deleteRequest(
      String url, Map<String, String> content) async {
    // Retrieve the response from the delete request for the specified url and headers
    Response response = await delete(
        'https://hotelroombookingwebservicealexbowenfyp.azurewebsites.net/' +
            url,
        headers: content);

    print('Delete response: ' + response.body);

    // Return the response
    return response;
  }

  // Function for post requests
  Future<Response> postRequest(String url, Map<String, String> content) async {
    // Retrieve the response from the post request for the specified url and headers
    Response response = await post(
        'https://hotelroombookingwebservicealexbowenfyp.azurewebsites.net/' +
            url,
        headers: content);

    print('Post response: ' + response.body);

    // Return the response
    return response;
  }

  // Function for put requests
  Future<Response> putRequest(String url, Map<String, String> content) async {
    // Retrieve the response from the put request for the specified url and headers
    Response response = await put(
        'https://hotelroombookingwebservicealexbowenfyp.azurewebsites.net/' +
            url,
        headers: content);

    print('Put response: ' + response.body);

    // Return the response
    return response;
  }
}
