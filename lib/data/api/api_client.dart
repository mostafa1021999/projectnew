import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:six_pos/common/models/error_response.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:http/http.dart' as http;


class ApiClient extends GetxService {
  final String appBaseUrl;
  final SharedPreferences sharedPreferences;
  static const String noInternetMessage = 'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 30;

  String? token;
  Map<String, String>? _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    token = sharedPreferences.getString(AppConstants.token);
    debugPrint('Token: $token');
    updateHeader(token);
  }

  void updateHeader(String? token) {
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
  }

  Future<Response> getData(String uri, {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    try {
      if(foundation.kDebugMode) {
        if (kDebugMode) {
          print('====> API Call: $uri\nToken: $token');
        }
      }
      http.Response response = await http.get(
        Uri.parse(appBaseUrl+uri),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      Response apiResponse = handleResponse(response);
      if(foundation.kDebugMode) {
        if (kDebugMode) {
          print('====> API Response: [${response.statusCode}] $uri\n${response.body}');
        }
      }
      return apiResponse;
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(String uri, dynamic body, {Map<String, String>? headers}) async {
    try {
      if(foundation.kDebugMode) {
        if (kDebugMode) {
          print('====> API Call: $uri\nToken: $token');
        }
        if (kDebugMode) {
          print('====> API Body: $body');
        }
      }
      http.Response response = await http.post(
        Uri.parse(appBaseUrl+uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      Response apiResponse = handleResponse(response);
      if(foundation.kDebugMode) {
        if (kDebugMode) {
          print('====> API Response: [${response.statusCode}] $uri\n${response.body}');
        }
      }
      return apiResponse;
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postMultipartData(String uri, Map<String, String> body, List<MultipartBody> multipartBody, {Map<String, String>? headers}) async {
    try {
      if(foundation.kDebugMode) {
        if (kDebugMode) {
          print('====> API Call: $uri\nToken: $token');
        }
        if (kDebugMode) {
          print('====> API Body: $body');
        }
      }
      http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(appBaseUrl+uri));
      request.headers.addAll(headers ?? _mainHeaders!);
      for(MultipartBody multipart in multipartBody) {
        if(foundation.kIsWeb) {
          Uint8List list = await multipart.file.readAsBytes();
          http.MultipartFile part = http.MultipartFile(
            multipart.key, multipart.file.readAsBytes().asStream(), list.length,
            filename: basename(multipart.file.path), contentType: MediaType('image', 'jpg'),
          );
          request.files.add(part);
        }else {
          File file = File(multipart.file.path);
          request.files.add(http.MultipartFile(
            multipart.key, file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last,
          ));
        }
      }
      request.fields.addAll(body);
      http.Response response = await http.Response.fromStream(await request.send());
      Response apiResponse = handleResponse(response);
      if(foundation.kDebugMode) {
        if (kDebugMode) {
          print('====> API Response: [${response.statusCode}] $uri\n${response.body}');
        }
      }
      return apiResponse;
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> putData(String uri, dynamic body, {Map<String, String>? headers}) async {
    try {
      if(foundation.kDebugMode) {
        if (kDebugMode) {
          print('====> API Call: $uri\nToken: $token');
        }
        if (kDebugMode) {
          print('====> API Body: $body');
        }
      }
      http.Response response = await http.put(
        Uri.parse(appBaseUrl+uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      Response apiResponse = handleResponse(response);
      if(foundation.kDebugMode) {
        if (kDebugMode) {
          print('====> API Response: [${response.statusCode}] $uri\n${response.body}');
        }
      }
      return apiResponse;
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> deleteData(String uri, {Map<String, String>? headers}) async {
    try {
      if(foundation.kDebugMode) {
        if (kDebugMode) {
          print('====> API Call: $uri\nToken: $token');
        }
      }
      http.Response response = await http.delete(
        Uri.parse(appBaseUrl+uri),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      Response apiResponse = handleResponse(response);
      if(foundation.kDebugMode) {
        if (kDebugMode) {
          print('====> API Response: [${response.statusCode}] $uri\n${response.body}');
        }
      }
      return apiResponse;
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Response handleResponse(http.Response apiResponse) {
    dynamic body;
    try {
      body = jsonDecode(apiResponse.body);
    }catch(e) {
      if (kDebugMode) {
        print(e);
      }
    }
    Response response = Response(
      body: body ?? apiResponse.body,
      bodyString: apiResponse.body.toString(),
      headers: apiResponse.headers,
      statusCode: apiResponse.statusCode,
      statusText: apiResponse.reasonPhrase,
    );
    if(response.statusCode != 200 && response.body != null && response.body is !String) {
      if(response.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse errorResponse = ErrorResponse.fromJson(response.body);
        response = Response(statusCode: response.statusCode, body: response.body, statusText: errorResponse.errors![0].message);
      }else if(response.body.toString().startsWith('{message')) {
        response = Response(statusCode: response.statusCode, body: response.body, statusText: response.body['message']);
      }else if(response.body.toString().startsWith('{success')) {
        response = Response(statusCode: response.statusCode, body: response.body, statusText: response.body['message']);
      }
    }else if(response.statusCode != 200 && response.body == null) {
      response = const Response(statusCode: 0, statusText: noInternetMessage);
    }
    return response;
  }
}

class MultipartBody {
  String key;
  XFile file;

  MultipartBody(this.key, this.file);
}