import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'gamelibrary.dart';
import 'diary.dart';
import 'login.dart' show LoginScreen;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // Weather data
  String cityName = "CAPAS";
  String weatherCondition = "Sunny";
  double temperature = 22;
  String dayOfWeek = "Monday";
  String greeting = "Good Morning";
  String time = "09:10 PM";
  String date = "Sep 29, 2025";

  // API key for OpenWeatherMap
  final String apiKey = "YOUR_API_KEY"; // Replace with your actual API key
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getLocationAndWeather();
    // Start updating time every second
    _startTimeUpdate();
  }

  // Update time dynamically every second
  void _startTimeUpdate() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _updateDateTime();
        });
        _startTimeUpdate();
      }
    });
  }

  // Update date and time
  void _updateDateTime() {
    final now = DateTime.now();
    setState(() {
      time = DateFormat('hh:mm a').format(now);
      date = DateFormat('MMM d, yyyy').format(now);
      dayOfWeek = DateFormat('EEEE').format(now);

      // Update greeting based on current time
      int hour = now.hour;
      if (hour >= 5 && hour < 12) {
        greeting = "Good Morning";
      } else if (hour >= 12 && hour < 17) {
        greeting = "Good Afternoon";
      } else {
        greeting = "Good Evening";
      }
    });
  }

  // Get user location and fetch weather data
  Future<void> getLocationAndWeather() async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, use default location
          await getWeatherData(14.9395, 120.5927);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are permanently denied, use default location
        await getWeatherData(14.9395, 120.5927);
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      // Get weather data for the current location
      await getWeatherData(position.latitude, position.longitude);
    } catch (e) {
      print("Error getting location: $e");
      // Use default location if there's an error
      await getWeatherData(14.9395, 120.5927);
    }
  }

  // Fetch weather data from API
  Future<void> getWeatherData(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          cityName = data['name'];
          weatherCondition = data['weather'][0]['main'];
          temperature = data['main']['temp'].toDouble();
          // Initialize date and time with current values
          _updateDateTime();
          isLoading = false;
        });
      } else {
        print("Error fetching weather data: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4AB1D8), Color(0xFF31A2CF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Column(
                        children: [
                          // Weather card
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(0xFF7ECBEA),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  // Temperature first
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.thermostat,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "${temperature.toStringAsFixed(0)}°C",
                                        style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1A7CA3),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  // Greeting second (now dynamic)
                                  Text(
                                    greeting,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A7CA3),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  // City name third
                                  Text(
                                    cityName,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A7CA3),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  // Weather condition and icon
                                  Text(
                                    weatherCondition,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xFF1A7CA3),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  _getWeatherIcon(weatherCondition),
                                ],
                              ),
                            ),
                          ),

                          Spacer(),

                          // Time and date card (now dynamic)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF7ECBEA),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    time, // Now updates every second
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    date, // Now updates with current date
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),

              // Bottom navigation bar
              Container(
                height: 60,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/images/loginicon.png',
                        width: 30,
                        height: 30,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/images/diaryicon.png',
                        width: 30,
                        height: 30,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DiaryScreen(),
                          ),
                        );
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Image.asset(
                          'assets/images/weatericon.png',
                          width: 30,
                          height: 30,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/images/logo.png',
                        width: 30,
                        height: 30,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GameLibraryPage(),
                          ),
                        );
                      },
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

  // Helper method to get weather icon based on condition (unchanged)
  Widget _getWeatherIcon(String condition) {
    IconData iconData;
    Color iconColor;

    switch (condition.toLowerCase()) {
      case 'clear':
        iconData = Icons.wb_sunny;
        iconColor = Colors.amber;
        break;
      case 'clouds':
        iconData = Icons.cloud;
        iconColor = Colors.grey;
        break;
      case 'rain':
        iconData = Icons.grain;
        iconColor = Colors.blue;
        break;
      case 'thunderstorm':
        iconData = Icons.flash_on;
        iconColor = Colors.amber;
        break;
      case 'snow':
        iconData = Icons.ac_unit;
        iconColor = Colors.white;
        break;
      case 'mist':
      case 'fog':
      case 'haze':
        iconData = Icons.cloud_queue;
        iconColor = Colors.grey[300]!;
        break;
      default:
        iconData = Icons.wb_sunny;
        iconColor = Colors.amber;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.cloud, size: 80, color: Colors.white),
        Icon(iconData, size: 60, color: iconColor),
      ],
    );
  }
}
