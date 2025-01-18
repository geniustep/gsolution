import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gsolution/common/api_factory/api_end_points.dart';
import 'package:gsolution/common/api_factory/dio_factory.dart';
import 'package:gsolution/common/api_factory/models/version_info_response.dart';
import 'package:gsolution/common/config/config.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:gsolution/common/utils/utils.dart';
import 'package:gsolution/common/widgets/log.dart';
import 'package:gsolution/src/authentication/models/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:open_file/open_file.dart';

enum ApiEnvironment { UAT, Dev, Prod }

extension APIEnvi on ApiEnvironment {
  String get endpoint {
    switch (this) {
      case ApiEnvironment.UAT:
        return Config.odooUATURL;
      case ApiEnvironment.Dev:
        return Config.odooDevURL;
      case ApiEnvironment.Prod:
        return Config.odooProdURL;
    }
  }
}

enum HttpMethod { delete, get, patch, post, put }

extension HttpMethods on HttpMethod {
  String get value {
    switch (this) {
      case HttpMethod.delete:
        return 'DELETE';
      case HttpMethod.get:
        return 'GET';
      case HttpMethod.patch:
        return 'PATCH';
      case HttpMethod.post:
        return 'POST';
      case HttpMethod.put:
        return 'PUT';
    }
  }
}

class Api {
  Api._();

  static final catchError = _catchError;

  static void _catchError(e, StackTrace stackTrace, OnError onError) async {
    if (!kReleaseMode) {
      print('Error: $e');
      print('StackTrace: $stackTrace');
      handleApiError(e);
    }

    if (e is DioException) {
      // Handling different DioException types
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.unknown:
          onError(
              'The server is unreachable. Please check your connection.', {});
          break;

        case DioExceptionType.badResponse:
          final response = e.response;
          if (response != null) {
            var data = response.data;

            // Check if the response is an HTML error page
            if (data is String && data.contains('<!doctype html>')) {
              await handleSessionExpired();
              onError(
                  'Session expired or URL not found. Please login again.', {});
              return;
            }

            // Check if the response is JSON
            if (data != null && data is Map<String, dynamic>) {
              if (data.containsKey("error") && data["error"]["code"] == 100) {
                await handleSessionExpired();
                return;
              }

              onError('Failed to process response: ${e.message}', data);
              return;
            }
          }
          onError('Failed to process response: ${e.message}', {});
          break;

        default:
          onError('Request was cancelled: ${e.message}', {});
          break;
      }
    } else {
      onError(e?.toString() ?? 'An unknown error occurred.', {});
    }
  }

  //General Post Request
  static Future<void> request({
    required HttpMethod method,
    required String path,
    required Map params,
    required OnResponse onResponse,
    required OnError onError,
    bool isPDF = false,
  }) async {
    Future.delayed(Duration(microseconds: 1), () {
      if (path != ApiEndPoints.getVersionInfo &&
          path != ApiEndPoints.getDb &&
          path != ApiEndPoints.getDb9 &&
          path != ApiEndPoints.getDb10) showLoading();
    });

    Response response;
    switch (method) {
      case HttpMethod.post:
        response = await DioFactory.dio!
            .post(
              path,
              data: params,
            )
            .catchError((e, stackTrace) => _catchError(e, stackTrace, onError));
        break;
      case HttpMethod.delete:
        response = await DioFactory.dio!
            .delete(
              path,
              data: params,
            )
            .catchError((e, stackTrace) => _catchError(e, stackTrace, onError));
        break;
      case HttpMethod.get:
        response = await DioFactory.dio!
            .get(
              path,
              options: isPDF
                  ? Options(
                      responseType: ResponseType.bytes,
                    )
                  : Options(),
            )
            .catchError((e, stackTrace) => _catchError(e, stackTrace, onError));
        break;
      case HttpMethod.patch:
        response = await DioFactory.dio!
            .patch(
              path,
              data: params,
            )
            .catchError((e, stackTrace) => _catchError(e, stackTrace, onError));
        break;
      case HttpMethod.put:
        response = await DioFactory.dio!
            .put(
              path,
              data: params,
            )
            .catchError((e, stackTrace) => _catchError(e, stackTrace, onError));
        break;
    }

    hideLoading();

    if (response.headers.value('content-type')?.contains('application/pdf') ==
        true) {
      onResponse(response.data);
    } else if (response.headers.value('content-type')?.contains('text/html') ==
        true) {
      final data = response.data;
      onResponse(data);
    } else if (response.data["success"] == 0) {
      onError(response.data["error"][0], {});
    } else {
      onResponse(response.data["result"]);
    }

    if (path == ApiEndPoints.authenticate) {
      _updateCookies(response.headers);
    }
  }

  static void _updateCookies(Headers headers) async {
    Log("Updating cookies...");
    final cookies = headers['set-cookie'];
    if (cookies != null && cookies.isNotEmpty) {
      final combinedCookies = cookies.join('; ');
      DioFactory.initialiseHeaders(combinedCookies);
      await PrefUtils.setToken(combinedCookies);
      Log("Cookies updated successfully: $combinedCookies");
    } else {
      Log("No cookies found in the response headers.");
    }
  }

  static getSessionInfo({
    required OnResponse onResponse,
    required OnError onError,
  }) {
    request(
      method: HttpMethod.post,
      path: ApiEndPoints.getSessionInfo,
      params: createPayload({}),
      onResponse: (response) {
        onResponse(response);
      },
      onError: (error, data) {
        onError(error, {});
      },
    );
  }

  static destroy({
    required OnResponse onResponse,
    required OnError onError,
  }) {
    request(
      method: HttpMethod.post,
      path: ApiEndPoints.destroy,
      params: createPayload({}),
      onResponse: (response) {
        onResponse(response);
      },
      onError: (error, data) {
        onError(error, {});
      },
    );
  }

  // Authenticate user
  static authenticate({
    required String username,
    required String password,
    required String database,
    required OnResponse<UserModel> onResponse,
    required OnError onError,
  }) {
    var params = {
      "db": database,
      "login": username,
      "password": password,
      "context": {}
    };

    request(
      method: HttpMethod.post,
      path: ApiEndPoints.authenticate,
      params: createPayload(params),
      onResponse: (response) {
        onResponse(UserModel.fromJson(response));
      },
      onError: (error, data) {
        onError(error, {});
      },
    );
  }

  static read({
    required String model,
    required List<int> ids,
    required List<String> fields,
    dynamic kwargs,
    required OnResponse onResponse,
    required OnError onError,
  }) async {
    callKW(
        model: model,
        method: "read",
        args: [ids, fields],
        kwargs: kwargs ?? null,
        onResponse: onResponse,
        onError: onError);
  }

  static searchRead({
    required String model,
    required List domain,
    required List<String> fields,
    int offset = 0,
    int limit = 0,
    String order = "",
    required OnResponse onResponse,
    required OnError onError,
  }) async {
    var params = {
      "context": getContext({}),
      "domain": domain,
      "fields": fields,
      "limit": limit,
      "model": model,
      "offset": offset,
      "sort": order
    };
    request(
      method: HttpMethod.post,
      path: ApiEndPoints.searchRead,
      params: createPayload(params),
      onResponse: (response) {
        onResponse(response);
      },
      onError: (error, data) {
        onError(error, {});
      },
    );
  }

  // Call any model method with arguments
  static callKW({
    required String model,
    required String method,
    required List args,
    dynamic kwargs,
    dynamic context,
    required OnResponse onResponse,
    required OnError onError,
  }) async {
    var params;
    if (context != null) {
      kwargs = {};
      kwargs["context"] = getContext(context);
      params = {
        "model": model,
        "method": method,
        "args": args,
        "kwargs": kwargs ?? {},
      };
    } else {
      params = {
        "model": model,
        "method": method,
        "args": args,
        "kwargs": kwargs ?? {},
        "context": getContext(context),
      };
    }
    request(
      method: HttpMethod.post,
      path: ApiEndPoints.getCallKWEndPoint(model, method),
      params: createPayload(params),
      onResponse: (response) {
        onResponse(response);
      },
      onError: (error, data) {
        onError(error, {});
      },
    );
  }

  // Create new record for model
  static create({
    required String model,
    required Map values,
    dynamic kwargs,
    required OnResponse onResponse,
    required OnError onError,
  }) {
    callKW(
        model: model,
        method: "create",
        args: [values],
        kwargs: kwargs ?? null,
        onResponse: onResponse,
        onError: onError);
  }

  // Write record with ids and values
  static write({
    required String model,
    required List<int> ids,
    required Map values,
    required OnResponse onResponse,
    required OnError onError,
  }) {
    callKW(
        model: model,
        method: "write",
        args: [ids, values],
        onResponse: onResponse,
        onError: onError);
  }

  // Remove record from system
  static unlink({
    required String model,
    required List<int> ids,
    dynamic kwargs,
    required OnResponse onResponse,
    required OnError onError,
  }) async {
    callKW(
        model: model,
        method: "unlink",
        args: [ids],
        kwargs: kwargs ?? null,
        onResponse: onResponse,
        onError: onError);
  }

  // exucute
  static exucute({
    required String model,
    required List<int> ids,
    dynamic kwargs,
    required OnResponse onResponse,
    required OnError onError,
  }) async {
    callKW(
        model: model,
        method: "execute",
        args: [ids],
        kwargs: kwargs ?? {},
        onResponse: onResponse,
        onError: onError);
  }

  // webSave
  static webSave({
    required String model,
    List<dynamic>? args,
    Map<String, dynamic>? value,
    Map<String, dynamic>? context,
    Map<String, dynamic>? specification,
    required OnResponse onResponse,
    required OnError onError,
  }) {
    callKW(
      model: model,
      method: "web_save",
      args: [args ?? [], value ?? {}],
      kwargs: {
        "context": context ?? {},
        "specification": specification ?? {},
      },
      onResponse: onResponse,
      onError: onError,
    );
  }

  // webRead
  static webRead({
    required String model,
    required List<dynamic> ids,
    Map<String, dynamic>? context,
    Map<String, dynamic>? specification,
    required OnResponse onResponse,
    required OnError onError,
  }) {
    callKW(
      model: model,
      method: "web_read",
      args: [ids],
      kwargs: {
        "context": context ?? {},
        "specification": specification ?? {},
      },
      onResponse: onResponse,
      onError: onError,
    );
  }

  // onchange
  static onChange({
    required String model,
    required dynamic args,
    dynamic kwargs,
    required OnResponse onResponse,
    required OnError onError,
  }) async {
    callKW(
      model: model,
      method: "onchange",
      args: args,
      kwargs: kwargs ?? {},
      onResponse: onResponse,
      onError: onError,
    );
  }

  // Call json controller
  static callController({
    required String path,
    required Map params,
    required OnResponse onResponse,
    required OnError onError,
  }) async {
    request(
      method: HttpMethod.post,
      path: path,
      params: createPayload(params),
      onResponse: (response) {
        onResponse(response);
      },
      onError: (error, data) {
        onError(error, {});
      },
    );
  }

  // get version of odoo
  static getVersionInfo({
    required OnResponse<VersionInfoResponse> onResponse,
    required OnError onError,
  }) {
    request(
      method: HttpMethod.post,
      path: ApiEndPoints.getVersionInfo,
      params: createPayload({}),
      onResponse: (response) {
        onResponse(VersionInfoResponse.fromJson(response));
      },
      onError: (error, data) {
        onError(error, {});
      },
    );
  }

  static getDatabases({
    required int serverVersionNumber,
    required OnResponse onResponse,
    required OnError onError,
  }) async {
    var params = {};
    var endPoint = "";
    if (serverVersionNumber == 9) {
      params["method"] = "list";
      params["service"] = "db";
      params["args"] = [];
      endPoint = ApiEndPoints.getDb9;
    } else if (serverVersionNumber >= 10) {
      endPoint = ApiEndPoints.getDb10;
      params["context"] = {};
    } else {
      endPoint = ApiEndPoints.getDb;
      params["context"] = {};
    }
    request(
      method: HttpMethod.post,
      path: endPoint,
      params: createPayload(params),
      onResponse: (response) {
        onResponse(response);
      },
      onError: (error, data) {
        onError(error, {});
      },
    );
  }

  static hasRight({
    required String model,
    required List right,
    dynamic kwargs,
    required OnResponse onResponse,
    required OnError onError,
  }) {
    callKW(
        model: model,
        method: "has_group",
        args: right,
        kwargs: kwargs ?? null,
        onResponse: onResponse,
        onError: onError);
  }

  static Map createPayload(Map params) {
    return {
      "id": Uuid().v1(),
      "jsonrpc": "2.0",
      "method": "call",
      "params": params,
    };
  }

  static Map getContext(dynamic adition) {
    Map map = {
      "lang": "en_US",
      "tz": "Europe/Brussels",
      "uid": const Uuid().v1(),
    };
    if (adition != null && adition.isNotEmpty) {
      adition.forEach((key, value) {
        map[key] = value;
      });
    }
    return map;
  }

  static Future<void> printReportPdf({
    required String reportName,
    required int recordId,
    required OnResponse onResponse,
    required OnError onError,
  }) async {
    final String path = '${Config.odooProdURL}report/pdf/$reportName/$recordId';
    try {
      await request(
        isPDF: true,
        method: HttpMethod.get,
        path: path,
        params: createPayload({"context": getContext({})}),
        onResponse: (data) {
          onResponse(data);
        },
        onError: (error, details) {
          print('Error fetching report: $error');
          onError(error, details);
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<void> downloadReportPdf({
    required String url,
    required OnResponse onResponse,
    required OnError onError,
  }) async {
    final String path = '${Config.odooProdURL}$url';
    try {
      await request(
        method: HttpMethod.get,
        path: path,
        params: createPayload({"context": getContext({})}),
        onResponse: (data) {
          onResponse(data);
        },
        onError: (error, details) {
          print('Error fetching report: $error');
          onError(error, details);
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<void> printReporthtml({
    required String reportName,
    required int recordId,
    required OnResponse onResponse,
    required OnError onError,
  }) async {
    final String path =
        '${Config.odooProdURL}report/html/$reportName/$recordId';
    await request(
      method: HttpMethod.get,
      path: path,
      params: createPayload({"context": getContext({})}),
      onResponse: (data) {
        onResponse(data);
      },
      onError: (error, details) {
        print('Error fetching report: $error');
        onError(error, details);
      },
    );
  }

  static addModule(
      {required String model,
      required dynamic maps,
      required OnResponse onResponse}) async {
    Api.create(
      model: model,
      values: maps!,
      onResponse: (response) {
        onResponse(response);
      },
      onError: (error, data) {
        handleApiError(error);
      },
    );
  }
}
