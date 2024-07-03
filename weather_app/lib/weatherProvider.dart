import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'weatherService.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  String? _city;
  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;

  String? get city => _city;
  Map<String, dynamic>? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWeather(String city) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _weatherData = await _weatherService.fetchWeather(city);
      _city = city;
      _saveCity(city);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('last_city', city);
  }

  Future<void> loadLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    _city = prefs.getString('last_city');
    if (_city != null) {
      await fetchWeather(_city!);
    }
  }
}
