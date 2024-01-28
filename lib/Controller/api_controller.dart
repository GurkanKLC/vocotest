
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../Models/api_return_value.dart';

typedef FromJsonCallback<T> = T Function(dynamic json);

abstract class ApiProcessFunctions {
  Future<ApiReturnValue> apiPost({required String selectedApi, required Map<String, dynamic> params}) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if(result == true) {
      var options = BaseOptions(
        baseUrl: 'https://reqres.in/api/',
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      );
      Dio dio = Dio(options);
      return await dio
          .post(
        selectedApi,
        data: params,

        options: Options(method: 'POST'),
      )
          .onError((error, stackTrace) {
        throw ApiReturnValue(data:null, dataStatus: false, statusCode: 500);
      }).then((value) {

        if (value.statusCode == 200) {
          return ApiReturnValue(data: value.data, dataStatus: true);
        } else {
          return ApiReturnValue(data: value.data, dataStatus: false, statusCode: value.statusCode,statusMessage:value.toString() );
        }
      }).catchError((onError) {
        return ApiReturnValue(data: null, dataStatus: false, statusCode: 500);
      });
    } else {
      return ApiReturnValue(data: null, dataStatus: false, statusCode: 600,statusMessage: "İnternet Bağlantınızı Kontrol Ediniz");
    }

  }

  Future<T> getApi<T>({
    Map<String, dynamic>? params,
    required String endpoint,
    required FromJsonCallback<T> fromJson,
  }) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if(result == true) {
      final options = BaseOptions(
        baseUrl: 'https://reqres.in/api/',
      );
      final dio = Dio(options);
      final Response response = await dio.get(endpoint, queryParameters: params ?? params, options: Options(method: 'GET'));

      if (response.statusCode == 200) {
        return fromJson(response.data);
      } else {
        throw Exception('Veriler Alınamadı!');
      }
    } else {
      throw ApiReturnValue(data: null, dataStatus: false, statusCode: 600,statusMessage: "İnternet Bağlantınızı Kontrol Ediniz");
    }

  }
}
