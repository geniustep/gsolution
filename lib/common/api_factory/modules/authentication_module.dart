import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gsolution/common/api_factory/api.dart';
import 'package:gsolution/common/config/config.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:gsolution/common/utils/utils.dart';
import 'package:gsolution/common/widgets/log.dart';
import 'package:gsolution/src/authentication/controllers/signin_controller.dart';
import 'package:gsolution/src/authentication/models/user_model.dart';
import 'package:gsolution/src/routes/app_routes.dart';

getVersionInfoAPI() {
  Api.getVersionInfo(
    onResponse: (response) {
      Api.getDatabases(
        serverVersionNumber: response.serverVersionInfo![0],
        onResponse: (response) {
          Log(response);
          // Config.dataBase = response[0];
        },
        onError: (error, data) {
          handleApiError(error);
        },
      );
    },
    onError: (error, data) {
      handleApiError(error);
    },
  );
}

authenticationAPI(String email, String pass) {
  Api.authenticate(
    username: email,
    password: pass,
    database: Config.dataBase,
    onResponse: (UserModel response) async {
      currentUser.value = response;
      PrefUtils.setIsLoggedIn(true);
      await PrefUtils.setUser(jsonEncode(response));
      await PrefUtils.getUser().then((_) {
        Get.offAllNamed(AppRoutes.splashScreen);
      });
    },
    onError: (error, data) {
      handleApiError(error);
    },
  );
}

logoutApi() {
  Api.destroy(
    onResponse: (response) {
      print("onResponse called with response: $response");
      PrefUtils.clearPrefs();
      Get.toNamed(AppRoutes.login);
    },
    onError: (error, data) {
      handleApiError(error);
      PrefUtils.clearPrefs().then((_) => Get.toNamed(AppRoutes.login));
    },
  );
}
