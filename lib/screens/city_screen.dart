import 'package:flutter/material.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  String newcity = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/city_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black, BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center everything vertically
            children: <Widget>[
              // Back Button at the top-left
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 30.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // City Input Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  onChanged: (value) {
                    newcity = value;
                  },
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    icon: Icon(
                      Icons.location_city,
                      color: Colors.black,
                    ),
                    hintText: 'Enter city name...',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                  ),
                ),
              ),

              const SizedBox(height: 20.0), // Spacer between input and button

              // Get Weather Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (newcity.isNotEmpty) {
                      Navigator.pop(context, newcity);
                    } else {
                      print("City name is empty");
                      Navigator.pop(context, newcity);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    backgroundColor: Colors.blueAccent, // Background color for button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 5.0, // Shadow for depth
                  ),
                  child: const Text(
                    'Get Weather',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
