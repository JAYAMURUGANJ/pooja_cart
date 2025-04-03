import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../errors/exceptions.dart';
import '../utils/api_response.dart';

class DioClient {
  late Dio dio;

  DioClient() {
    // Encode credentials in Base64
    final baseOptions = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: ApiConstants.connectionTimeout),
      receiveTimeout: const Duration(seconds: ApiConstants.receiveTimeout),
      responseType: ResponseType.json,

      headers: {
        'Authorization':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc0MjU1NDU0OCwiZXhwIjoxNzQyNTU4MTQ4fQ.TdUh-QIZFFqC2244DBGSKXCSo76hHT_YiHkeAHnwnzc',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    dio = Dio(baseOptions);

    // Add interceptors
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if needed
          // final token = await getToken();
          // options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Convert response to our ApiResponse format
          final apiResponse = ApiResponse.fromJson(response.data);

          // If status is error, throw custom exception
          if (!apiResponse.isSuccess) {
            return handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                error: apiResponse.message,
              ),
            );
          }

          // If success, modify response.data to contain only the result
          response.data = apiResponse.data;
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response<T>> get<T>({
    String path = "",
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> post<T>({
    String path = "",
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerException(
          message: 'Connection timeout. Please try again.',
        );
      case DioExceptionType.badResponse:
        return ServerException(message: _getErrorMessage(error.response));
      case DioExceptionType.cancel:
        return ServerException(message: 'Request cancelled');
      default:
        return ServerException(
          message: 'Something went wrong. Please try again.',
        );
    }
  }

  String _getErrorMessage(Response? response) {
    int? statusCode = response?.statusCode;
    try {
      if (response!.data['message'] != null && response.data['message'] != "") {
        return response.data['message'];
      }
      switch (statusCode) {
        case 400:
          return 'Bad request';
        case 401:
          return 'Unauthorized';
        case 403:
          return 'Forbidden';
        case 404:
          return 'Not found';
        case 500:
          return 'Internal server error';
        default:
          return 'Something went wrong';
      }
    } catch (e) {
      return 'Something went wrong : ${e.toString()}';
    }
  }
}
