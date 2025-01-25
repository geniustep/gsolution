import 'package:gsolution/common/config/import.dart';

class WebhookApi {
  WebhookApi();

  static checkWebhookOdoo(
      {required String model,
      required OnResponse onResponse,
      required OnError onError}) async {
    await Api.webhookCheckOdoo(
        model: model,
        onResponse: (response) {
          onResponse(response);
        },
        onError: (errorMessage, data) {
          handleApiError(errorMessage);
        });
  }

  static fetchWebhookOdoo(
      {required String model,
      required OnResponse onResponse,
      required OnError onError}) async {
    await Api.webhookFetchOdoo(
        model: model,
        onResponse: (response) {
          onResponse(response);
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static clearWebhookOdoo(
      {required String model,
      required OnResponse onResponse,
      required OnError onError}) async {
    await Api.clearWebhookData(
        model: model,
        onResponse: (response) {
          onResponse(response);
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }
}
