
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../error/failures.dart';
import 'end_points.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

@riverpod
class DioClient extends _$DioClient {

  @override
  FutureOr build() {
    return _createDio();
  }

  String? _accessToken;
  bool _isUnitTest = false;
  late Dio _dio;

  DioClient({bool isUnitTest = false}) {
    _isUnitTest = isUnitTest;
    try {
      // _accessToken = HiveBoxes.appStorageBox.get(DbKeys.accessTokenKey);
    } catch (_) {}
    _dio = _createDio();


    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      if (options.extra.containsKey("includeAuthorization") &&
          options.extra["includeAuthorization"] == true) {
        if (_accessToken != null) {
          options.headers['Authorization'] = 'Bearer $_accessToken';
        }
      }
    }, onError: (DioException error, handler) async {
      if (error.response?.statusCode == 401) {
        //todo If a 401 response is received, refresh the access token
        // String? newAccessToken = await refreshToken();
        //
        // if (newAccessToken != null) {
        //   // Update the request header with the new access token
        //   error.requestOptions.headers['Authorization'] =
        //       'Bearer $newAccessToken';
        //
        //   // Repeat the request with the updated header
        //   return handler.resolve(await dio.fetch(error.requestOptions));
        // }
      }
    }));

    _dio.interceptors.add(
      LogInterceptor(
        logPrint: (o) => debugPrint(o.toString()),
      ),
    );

  }

  // Future<String?> refreshToken() async {
  //   var currRefreshTokenResult =
  //       await sl<GetRefreshTokenUseCase>().call(NoParams());
  //   String? currRefreshToken;
  //
  //   currRefreshTokenResult.fold(
  //     (failure) {
  //       currRefreshToken = null;
  //     },
  //     (rToken) => currRefreshToken = rToken,
  //   );
  //
  //   if (currRefreshToken == null) return null;
  //
  //   var postRefreshTokenResult = await sl<PostRefreshTokenUseCase>()
  //       .call(RefreshTokenParams(refreshToken: currRefreshToken!));
  //
  //   String? newAccessToken;
  //   RefreshTokenResponseModel? refreshTokenResponseModel;
  //
  //   postRefreshTokenResult.fold(
  //     (failure) {
  //       HiveBoxes.appStorageBox.delete(DbKeys.accessTokenKey);
  //       HiveBoxes.appStorageBox.delete(DbKeys.refreshTokenKey);
  //       HiveBoxes.appStorageBox.delete(DbKeys.binanceSecretApiKey);
  //       HiveBoxes.appStorageBox.delete(DbKeys.binanceApiKey);
  //     },
  //     (responseModel) {
  //       refreshTokenResponseModel =
  //           responseModel; // Assign to outer scope variable
  //       newAccessToken = responseModel.accessToken;
  //     },
  //   );
  //
  //   if (refreshTokenResponseModel != null) {
  //     await sl<SaveAccessTokenUseCase>()
  //         .call(refreshTokenResponseModel!.accessToken);
  //     await sl<SaveRefreshTokenUseCase>()
  //         .call(refreshTokenResponseModel!.refreshToken);
  //   }
  //
  //   return newAccessToken;
  // }

  Dio get dio {
    if (_isUnitTest) {
      return _dio;
    } else {
      try {
        // _accessToken = HiveBoxes.appStorageBox.get(DbKeys.accessTokenKey);
      } catch (_) {}
      final _dio = _createDio();
      if (!_isUnitTest) {
        // _dio.interceptors
        //     .add(DioLogInterceptor(accessToken: _accessToken, dio: _dio));
      }
      return _dio;
    }
  }

  Dio _createDio() => Dio(BaseOptions(
      baseUrl: EndPoints.baseUrl,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        // if (_authToken != null) ...{
        //   "Authorization": _authToken,
        // }
      },
      receiveTimeout: const Duration(seconds: 25),
      connectTimeout: const Duration(seconds: 25),
      validateStatus: (int? status) {
        return (status! > 0 && status <= 400 )|| status == 403 || status == 409;
      }));

  Future<Response> getRequest(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool includeAuthorization = true,
  }) async {
    try {
      return await dio.get(url,
          queryParameters: queryParameters,
          data: data,
          options:
              Options(extra: {'includeAuthorization': includeAuthorization}));
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<Response> postRequest(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool includeAuthorization = true,
  }) async {
    try {
      return await dio.post(EndPoints.baseUrl+url,
          data: data,
          queryParameters: queryParameters,
          options:
              Options(extra: {'includeAuthorization': includeAuthorization}));
    } on DioException catch (e) {
      throw ServerFailure(e.message);
    }
  }
  Future<Response> deleteRequest(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool includeAuthorization = true,
  }) async {
    try {
      return await dio.delete(url,
          data: data,
          queryParameters: queryParameters,
          options:
              Options(extra: {'includeAuthorization': includeAuthorization}));
    } on DioException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
