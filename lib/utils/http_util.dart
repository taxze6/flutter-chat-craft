import 'package:dio/dio.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../common/config.dart';
import '../models/api_resp.dart';
import '../widget/toast_utils.dart';

/**
 * @Author: Taxze
 * @GitHub: https://github.com/taxze6
 * @Email: 1929509811@qq.com
 * @Date: 2023/2/20
 */
var dio = Dio();

class HttpUtil {
  HttpUtil._();

  static void init() {
    dio
      ..interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ))
      ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        return handler.next(options); //continue
        // 如果你想完成请求并返回一些自定义数据，你可以resolve一个Response对象 `handler.resolve(response)`。
        // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
        //
        // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象,如`handler.reject(error)`，
        // 这样请求将被中止并触发异常，上层catchError会被调用。
      }, onResponse: (response, handler) {
        // Do something with response data
        return handler.next(response); // continue
        // 如果你想终止请求并触发一个错误,你可以 reject 一个`DioError`对象,如`handler.reject(error)`，
        // 这样请求将被中止并触发异常，上层catchError会被调用。
      }, onError: (DioError e, handler) {
        // Do something with response error
        return handler.next(e); //continue
        // 如果你想完成请求并返回一些自定义数据，可以resolve 一个`Response`,如`handler.resolve(response)`。
        // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
      }));
    // 配置dio实例
    dio.options.baseUrl = Config.apiUrl;
    dio.options.connectTimeout = const Duration(seconds: 30); //30s
    dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  static Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var result = await dio.post<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      var resp = ApiResp.fromJson(result.data!);
      if (resp.code == 0) {
        return resp.data;
      } else {
        ToastUtils.toastText(resp.message);
        return resp.data;
      }
    } catch (error) {
      ToastUtils.toastText(StrRes.networkException);
      return Future.error(error);
    }
  }

  static Future get(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var result = await dio.get(path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);
      var resp = ApiResp.fromJson(result.data!);
      if (resp.code == 0) {
        return resp.data;
      } else {
        ToastUtils.toastText(resp.message);
        return resp.data;
      }
    } catch (error) {
      ToastUtils.toastText(StrRes.networkException);
      return Future.error(error);
    }
  }

  static Future download(
    String url, {
    required String cachePath,
    CancelToken? cancelToken,
    Function(int count, int total)? onProgress,
  }) {
    return dio.download(
      url,
      cachePath,
      options: Options(receiveTimeout: const Duration(seconds: 1000)),
      cancelToken: cancelToken,
      onReceiveProgress: onProgress,
    );
  }
}
