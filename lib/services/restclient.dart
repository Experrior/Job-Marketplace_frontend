import 'dart:async';
import 'dart:convert';

import 'package:zpi_chat/config/url_config.dart';
import 'package:zpi_chat/services/network_service_response.dart';

import 'package:http/http.dart' as http;

class RestClient {
  final BaseUrlConfig baseUrlConfig = BaseUrlConfig();

  late http.Client client;
  late String baseHost;

  RestClient() {
    baseHost = baseUrlConfig.baseHost;
    client = http.Client();
  }

  Map<String, String> default_headers = {
    "Content-Type": 'application/json',
    "Accept": '*',
    "Access-Control-Allow-Origin": "*",
    "Connection": 'keep-alive'
  };

  Future<MappedNetworkServiceResponse<T>> get<T>(String resourcePath,
      {Map<String, dynamic>? queryParameters,
        Map<String, String>? headers}) async {
    Uri resourceFullUrl =
    getFullUrl(resourcePath, queryParameters: queryParameters);
    var response = await client
        .get(resourceFullUrl, headers: {...?headers, ...default_headers});
    return processResponse<T>(response);
  }

  Future<MappedNetworkServiceResponse<T>> post<T>(
      String resourcePath, dynamic data,
      {Map<String, dynamic>? queryParameters,
        Map<String, String>? headers}) async {
    Uri resourceFullUrl =
    getFullUrl(resourcePath, queryParameters: queryParameters);
    var content = json.encoder.convert(data);
    print(resourceFullUrl);
    var response = await client.post(resourceFullUrl,
        body: content, headers: {...?headers, ...default_headers});
    return processResponse<T>(response);
  }

  MappedNetworkServiceResponse<T> processResponse<T>(http.Response response) {
    if ((response.statusCode < 200) ||
        (response.statusCode >= 300) ||
        (response.body == null)) {
      var errorResponse = response.body;
      return MappedNetworkServiceResponse<T>(
          networkServiceResponse: NetworkServiceResponse<T>(
              success: false,
              message: "(${response.statusCode}) ${errorResponse.toString()}"));
    } else {
      var jsonResult = response.body;
      dynamic resultClass = jsonDecode(jsonResult);

      return MappedNetworkServiceResponse<T>(
          mappedResult: resultClass,
          networkServiceResponse: NetworkServiceResponse<T>(success: true));
    }
  }

  Uri getFullUrl(String resourcePath, {Map<String, dynamic>? queryParameters}) {
    return Uri.http(baseHost, resourcePath, queryParameters);
  }
}