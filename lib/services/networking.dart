import 'package:http/http.dart' as http;
import 'package:test_clima_flutter/services/location.dart';
import 'dart:convert';

class Networking {
  double temp = 0;
  String data = '', city = '';
  String appID = "b8018b8395853af229a7fac4461c70b7";
  int id = 0;

  Future<String> getData({String? cityName}) async {
    Uri url;

    if (cityName != null && cityName.isNotEmpty) {
      url = Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$appID&units=metric");
    } else {
      Location location = Location();
      await location.getLocation();
      double lat = location.lat;
      double lon = location.lon;

      url = Uri.parse("https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$appID&units=metric");
    }

    http.Response response = await http.get(url);
    data = response.body;

    if (response.statusCode == 200) {
      return data;
    } else {
      return "Error: Unable to fetch data";
    }
  }
}