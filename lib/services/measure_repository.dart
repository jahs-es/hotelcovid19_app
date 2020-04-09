import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hotelcovid19_app/measure/models/measure.dart';
import 'package:hotelcovid19_app/services/api_path.dart';
import 'package:hotelcovid19_app/services/login_repository.dart';
import 'package:http/http.dart';

class MeasureRepository {
  final backendAuthentication = BackendAuthentication();

  Future<String> _getToken() async {
    return await this.backendAuthentication.getToken();
  }

  Future<Measure> save(Measure measure) async {
    Response response;
    String token = await _getToken();
    Map<String, dynamic> data = measure.toJson();

    String jsonData = json.encode(data);

    print("Lo grabado $jsonData");

    if (measure.id == null) {
      response = await Client().post(
        APIPath.createOrUpdateMeasureUrl,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: jsonData,
      );
    } else {
      response = await Client().put(
        APIPath.createOrUpdateMeasureUrl,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: jsonData,
      );
    }

    if (response.statusCode ==201) {
      return measure;
    } else if (response.statusCode == 200) {
      return measure;
    } else {
      return null;
    }
  }

  Future<List<Measure>> getMeasures() async {
    String token = await _getToken();

    Response response = await Client().get(APIPath.getMeasuresUrl, headers: {
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;

      List<Measure> measuresList = [];

      data.forEach((measure) {
        measuresList.add(Measure.fromJson(measure));
      });
      return measuresList;
    } else {
      throw Exception('Error fetching measures');
    }
  }

  Future<void> delete(int id) async {
    String token = await _getToken();

    Response response = await Client().delete(
        APIPath.deleteMeasureUrl.replaceAll('{id}', id.toString()),
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        });

    if (response.statusCode == 204) {
      print('Deleted');
    } else {
      throw Exception('Error deleting measure');
    }
  }
}
