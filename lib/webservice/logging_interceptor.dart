import 'package:http_interceptor/http_interceptor.dart';
//For more info about intercept see: https://pub.dev/packages/http_interceptor
class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    print('-------------- request ---------------------');
    print('URL: ${data.baseUrl}');
    print('Headers: ${data.headers}');
    print('body: ${data.body}');
    print('---------------------------------------------');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    print('----------- response ----------------------');
    print('status code: ${data.statusCode}');
    print('Headers: ${data.headers}');
    print('body: ${data.body}');
    print('---------------------------------------------');
    return data;
  }

}