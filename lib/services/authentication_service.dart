import 'package:zpi_chat/services/network_service_response.dart';
import 'package:zpi_chat/services/restclient.dart';

abstract class AudiobookRemoteDataSource {
  /// Calls the [baseUrl]/v1/audiobooks?category=:category&apiKey=:apiKey endpoint
  ///
  /// Throws a [AudiobookFetchException] for all error codes.
  // Future<AudiobookListResponseModel> getAudiobooks(String? categoryId);
  // Future<Audiobook> getAudiobook(int audiobookId);
}

class AuthenticationService{
  RestClient client = RestClient();
  // final ConstantConfig constantConfig = ConstantConfig();


  Future<Object> register(String? email, String? firstName, String? lastName, String? password,  String? confirmPassword) async {
    MappedNetworkServiceResponse response;
    if (email == null || confirmPassword == null || password == null || firstName == null || lastName ==null ) {
      print("not working TODO"); // TODO give user feedback
      return "incorrect stuff";
    } else {
      response = await client.post(
          '/user-service/register/applicant',
          {
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
            "password": password,
            "confirmPassword": confirmPassword
          }
      );
    }
    if (response.networkServiceResponse.success) {
      return response;
    } else {
      print(response.mappedResult);
      throw Exception(response);
    }
  }
  Future<Object> registerRecruiter(String? email, String? firstName, String? lastName, String? password,  String? confirmPassword, String? company) async {
    MappedNetworkServiceResponse response;
    if (company == null || email == null || firstName == null) {
      //todo finish check and message handle
      print("not working register");
      return "incorrect stuff";
    } else {
      response = await client.post(
          '/user-service/register/recruiter',
          {
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
            "password": password,
            "confirmPassword": confirmPassword,
            "company": "VISA"
          }
      );
    }
    if (response.networkServiceResponse.success) {
      return response;
    } else {
      print(response.mappedResult);
      throw Exception(response);
    }
  }

  Future<bool> login(String? email, String? password) async {
    MappedNetworkServiceResponse response;
    if (email == null || password == null) {
      return false;
    } else {
      response = await client.post(
         '/user-service/login',
        {
          'email': email,
          'password': password
        },
      );
    }
    if (response.networkServiceResponse.success) {
      for (int i =0; i<response.mappedResult.length; i++){
        print(response.mappedResult[i]['email']);
        if (email == response.mappedResult[i]['email']){
          return true;
        }
      }
      return false;
    } else {
      print(response.networkServiceResponse);
      throw Exception(response);
    }
  }

}