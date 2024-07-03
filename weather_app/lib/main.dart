import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weatherProvider.dart';
import 'homePage.dart';
import 'weatherDetails.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
  
    return ChangeNotifierProvider(
      
      create: (_) => WeatherProvider()..loadLastCity(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/details': (context) => WeatherDetailsScreen(),
        },
      ),
    );
  }
}
