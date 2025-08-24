import 'dart:convert';
import 'package:flutter/services.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFDevEnvironmentValues {
  static const String currentEnvironment = 'Dev';
  static const String environmentValuesPath =
      'assets/environment_values/environment.json';

  static final FFDevEnvironmentValues _instance =
      FFDevEnvironmentValues._internal();

  factory FFDevEnvironmentValues() {
    return _instance;
  }

  FFDevEnvironmentValues._internal();

  Future<void> initialize() async {
    try {
      final String response =
          await rootBundle.loadString(environmentValuesPath);
      final data = await json.decode(response);
      _urlsupa = data['urlsupa'];
      _apikey = data['apikey'];
    } catch (e) {
      print('Error loading environment values: $e');
    }
  }

  String _urlsupa = '';
  String get urlsupa => _urlsupa;

  String _apikey = '';
  String get apikey => _apikey;
}
