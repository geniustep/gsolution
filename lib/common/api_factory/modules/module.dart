import 'dart:async';
import 'package:gsolution/common/api_factory/modules/settings_odoo.dart';
import 'package:gsolution/common/config/import.dart';

class Module {
  Module._();

  // generer les recordes
  static Future<void> getRecordsController<T>({
    required String model, // Modelo genérico (ej. "product.product")
    List<String>? fields, // Campos opcionales
    List domain = const [], // Dominio opcional
    int limit = 50, // Límite de registros por defecto
    int offset = 0, // Offset por defecto
    T Function(Map<String, dynamic>)?
        fromJson, // Función para convertir JSON a modelo
    OnResponse? onResponse, // Callback para manejar la respuesta
  }) async {
    try {
      List<String> dynamicFields = await getValidFields(model);

      List<String> validFields = [
        ...?fields,
        ...dynamicFields,
      ];
      final fetchedRecords = await searchRead<T>(
        model: model,
        domain: domain,
        fields: validFields,
        fromJson: fromJson,
        limit: limit,
      );

      if (onResponse != null) {
        onResponse(fetchedRecords);
      }
    } catch (e) {
      print("Error obteniendo registros: $e");
    }
  }

  static Future<List<T>> searchRead<T>({
    required String model,
    required List domain,
    required List<String> fields,
    T Function(Map<String, dynamic>)? fromJson,
    int limit = 50,
  }) async {
    int offset = 0;
    bool hasMore = true;
    List<T> allRecords = [];

    while (hasMore) {
      final Completer<Map<int, List<T>>> completer = Completer();

      Api.callKW(
        method: 'search_read',
        model: model,
        args: [domain, fields],
        kwargs: {
          "limit": limit,
          "offset": offset,
        },
        onResponse: (response) {
          if (response is List) {
            List<T> fetchedRecords = [];
            for (var element in response) {
              if (element is Map<String, dynamic>) {
                if (fromJson != null) {
                  fetchedRecords.add(fromJson(element));
                }
              }
            }
            completer.complete({fetchedRecords.length: fetchedRecords});
          }
        },
        onError: (error, data) {
          print("Error: $error");
          print("Data: $data");
          completer.completeError(error);
        },
      );

      final response = await completer.future;

      if (response.isNotEmpty) {
        int size = response.keys.first;
        List<T> fetchedRecords = response[size]!;

        allRecords.addAll(fetchedRecords);
        offset += limit;

        hasMore = fetchedRecords.length == limit;
      } else {
        hasMore = false;
      }
    }

    return allRecords;
  }

  static Future<List<String>> getValidFields(String model) async {
    final Completer<List<String>> completer = Completer();
    Api.callKW(
      method: 'fields_get',
      model: model,
      args: [],
      kwargs: {
        "attributes": ["string", "type", "required"],
      },
      onResponse: (response) {
        if (response is Map<String, dynamic>) {
          List<String> requiredFields = response.entries
              .where((entry) => entry.value['required'] == true)
              .map((entry) => entry.key)
              .toList();
          completer.complete(requiredFields);
        }
      },
      onError: (error, data) {
        print("Error obteniendo campos: $error");
        completer.completeError(error);
      },
    );

    return completer.future;
  }

  
  static onchangeSettingsOdoo({required OnResponse onResponse}) async {
    try {
      var args = [
        [],
        {},
        [],
        {"default_invoice_policy": {}}
      ];

      ResConfigSettingModel fromJson(Map<String, dynamic> json) {
        final value = json['value'];
        if (value != null) {
          return ResConfigSettingModel(
              default_invoice_policy: value['default_invoice_policy']);
        }
        throw Exception("Value is null or invalid response format");
      }

      await Api.onChange(
        model: 'res.config.settings',
        args: args,
        onResponse: (response) {
          if (response != null) {
            try {
              final configSetting = fromJson(response);
              onResponse(configSetting);
            } catch (e) {
              print("Error parsing response: $e");
              handleApiError(e.toString());
            }
          }
        },
        onError: (error, data) {
          handleApiError(error);
        },
      );
    } catch (e) {
      print("Error extracting 'value': $e"); // في حالة حدوث استثناء
      handleApiError(e.toString());
    }
  }

  static deliverySettings({required OnResponse onResponse}) async {
    await Api.callKW(
      model: 'res.config.settings',
      method: "web_save",
      args: [
        [],
        {"default_invoice_policy": "delivery"},
        {}
      ],
      onResponse: (response) {
        if (response is List &&
            response.isNotEmpty &&
            response[0] is Map<String, dynamic>) {
          final map = response[0] as Map<String, dynamic>;
          try {
            int id = map['id'] as int;

            // استدعاء API باستخدام ID المستخرج
            Api.exucute(
              model: "res.config.settings",
              ids: [id],
              onResponse: (res) {
                onResponse(res); // تمرير الاستجابة بنجاح
              },
              onError: (error, data) {
                handleApiError(error); // التعامل مع الخطأ
              },
            );
          } catch (e) {
            print("Error extracting 'id': $e"); // في حالة حدوث استثناء
            handleApiError(e.toString());
          }
        } else {
          print("Invalid response format or missing 'id' key.");
          handleApiError("Invalid response format or missing 'id' key.");
        }
      },
      onError: (error, data) {
        handleApiError(error);
      },
    );
  }

  static createModule(
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

  static writeModule(
      {required String model,
      required List<int> ids,
      required Map values,
      required OnResponse onResponse}) async {
    Api.write(
      model: model,
      ids: ids,
      values: values,
      onResponse: (response) {
        onResponse(response);
      },
      onError: (error, data) {
        handleApiError(error);
      },
    );
  }

  static deleteModule(
      {required String model,
      required List<int> ids,
      required Map values,
      required OnResponse onResponse}) async {
    Api.unlink(
      model: model,
      ids: ids,
      onResponse: onResponse,
      onError: (error, data) {
        handleApiError(error);
      },
    );
  }
}
