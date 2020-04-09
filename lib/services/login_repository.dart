import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotelcovid19_app/models/login.dart';
import 'package:hotelcovid19_app/services/api_path.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

abstract class AuthBase {
  Future<String> authenticate();

  Future<Login> account();

  Future<void> deleteToken();

  Future<void> persistToken(String token);

  Future<bool> hasToken();

  Future<String> getToken();
}

class BackendAuthentication implements AuthBase {
  // Create storage
  final storage = new FlutterSecureStorage();

  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    Map<String, String> data = {'username': username, 'password': password};

    final response = await http.post(APIPath.authenticateUrl,
        headers: {"Content-Type": "application/json"}, body: json.encode(data));

    if (response.statusCode == 200) {
      return loginFromJson(response.body).token;
    } else {
      return null;
    }
  }

  Future<Login> account() async {
    String token = await this.getToken();

    if (token != null) {
      final response = await http.post(APIPath.accountUrl, headers: {
        "Content-Type": "application/json",
        HttpHeaders.authorizationHeader: "Basic $token"
      });

      if (response.statusCode == 200) {
        return loginFromJson(response.body);
      } else {
        return null;
      }
    }
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await storage.delete(key: 'token');
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await storage.write(key: 'token', value: token);
    return;
  }

  Future<bool> hasToken() async {
    /// read from keystore/keychain
    String value = await storage.read(key: 'token');

    return (value != null);
  }

  Future<String> getToken() async {
    /// read from keystore/keychain
    String value = await storage.read(key: 'token');
    return value;
  }
}

class MockAuthentication implements AuthBase {
  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    return 'token';
  }

  Future<Login> account() async {
    await Future.delayed(Duration(seconds: 1));
    return Login();
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return false;
  }

  Future<String> getToken() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return "token";
  }
}
