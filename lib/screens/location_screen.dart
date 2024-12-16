import 'package:flutter/material.dart';
import 'package:test_clima_flutter/screens/city_screen.dart';
import 'package:test_clima_flutter/services/weather.dart';
import 'package:test_clima_flutter/utilities/constants.dart';
import 'package:test_clima_flutter/services/location.dart';
import 'dart:convert';
import 'package:test_clima_flutter/services/networking.dart';

class LocationScreen extends StatefulWidget {
  String newcity = '';
  LocationScreen(this.data, {super.key});
  String data = '';
  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  double temp = 0;
  String city = '', info = '', weathericon = '', weathermessage = '';
  int id = 0;

  double currentLat = 0.0;
  double currentLon = 0.0;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    info = widget.data;
    updateUI();
    getCurrentLocation();
  }

  void updateUI() {
    try {
      temp = jsonDecode(info)['main']['temp'];
      city = jsonDecode(info)['name'];
      id = jsonDecode(info)['weather'][0]['id'];

      WeatherModel weatherModel = WeatherModel();
      weathericon = weatherModel.getWeatherIcon(id);
      weathermessage = weatherModel.getMessage(temp.toInt());
      isError = false;
    } catch (e) {
      print("Error updating UI: $e");
      isError = true;
      city = "Error";
      weathericon = "❌";
      weathermessage = "No city with that name";
    }
  }

  void getCurrentLocation() async {
    Location location = Location();
    await location.getLocation();
    currentLat = location.lat;
    currentLon = location.lon;

    Networking network = Networking();
    String weatherData = await network.getData(cityName: '');

    setState(() {
      info = weatherData;
      updateUI();
    });
  }

  void getWeatherForCity(String cityName) async {
    Networking network = Networking();
    String weatherData = await network.getData(cityName: cityName);

    if (weatherData == "error") {
      setState(() {
        isError = true;
        city = "Error";
        weathericon = "❌";
        weathermessage = "No city with that name";
      });
    } else {
      setState(() {
        info = weatherData;
        updateUI();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Weather display section
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        isError
                            ? Text(
                          'Error',
                          style: kTempTextStyle,
                        )
                            : Text(
                          temp.toStringAsFixed(0) + '°',
                          style: kTempTextStyle,
                        ),
                        Text(
                          weathericon,
                          style: kConditionTextStyle,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      isError ? weathermessage : "$weathermessage time in $city",
                      textAlign: TextAlign.center,
                      style: kMessageTextStyle,
                    ),
                  ),
                ],
              ),

              // Buttons section
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Current location button
                    ElevatedButton(
                      onPressed: () {
                        getCurrentLocation();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button color
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                      ),
                      child: Icon(
                        Icons.near_me,
                        size: 60.0,
                        color: Colors.white,
                      ),
                    ),
                    // Search city button
                    ElevatedButton(
                      onPressed: () async {
                        String newcity = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return CityScreen();
                        }));
                        if (newcity.isEmpty) {
                          setState(() {
                            isError = true;
                            city = "Error";
                            weathericon = "❌";
                            weathermessage = "City name cannot be empty!";
                          });
                        } else {
                          getWeatherForCity(newcity);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Button color
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                      ),
                      child: Icon(
                        Icons.location_city,
                        size: 60.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

