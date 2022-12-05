import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/api/Constants.dart';
import 'package:get/get.dart' hide Response;
import 'package:movie_app/api/globals.dart';

class DioClient {
  static Dio? _dio;

  static Dio get client {
    return Get.find<Dio>();
  }

  static init() {
    _dio ??= Dio(BaseOptions(
      baseUrl: Constants.baseUrl,
      validateStatus: (status) {
        return status! <= 500;
      },
      headers: {'Accept': 'application/json'},
    ));
    Get.put(_dio!, permanent: true);
  }
}

Future<void> showError(error) async {
  String title = "Error";
  String message = error?.toString() ?? "Something went wrong";
  showMessage(title, message);
}

Future<void> showMessage(String title, String message) async {
  ScaffoldMessenger.of(Globals.scaffoldMessengerKey.currentContext!)
      .showSnackBar(SnackBar(content: Text(message)));
}
