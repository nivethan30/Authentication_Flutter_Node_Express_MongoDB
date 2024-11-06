import 'package:dio/dio.dart';
import '../utils/constants.dart';
export 'package:dio/dio.dart';

class Network {
  final Dio _dio = Dio();

  Network() {
    _dio.options.validateStatus = (status) {
      return status! < 500;
    };
  }
  Future<Response> get(
      {required String endPoint, Map<String, dynamic>? headerData}) async {
    try {
      Map<String, dynamic> headers = headerData ?? _headers;
      String url = '${Constants.baseUrl}$endPoint';
      Response response =
          await _dio.get(url, options: Options(headers: headers));
      return response;
    } on DioException catch (e) {
      _onDioException(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
      {required String endPoint,
      Map<String, dynamic>? headerData,
      required Map<String, dynamic> data}) async {
    try {
      Map<String, dynamic> headers = headerData ?? _headers;
      String url = '${Constants.baseUrl}$endPoint';
      Response response =
          await _dio.post(url, data: data, options: Options(headers: headers));
      return response;
    } on DioException catch (e) {
      _onDioException(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  final Map<String, dynamic> _headers = {};

  void _onDioException(DioException e) {
    if (e.type == DioExceptionType.connectionError) {
      throw 'No internet connection or network unreachable: ${e.message}';
    } else if (e.type == DioExceptionType.connectionTimeout) {
      throw 'Connection timed out: ${e.message}';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      throw 'Server response timeout: ${e.message}';
    } else {
      throw 'DioError: ${e.message}';
    }
  }
}
