import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'd70eb98b7639ed96259d9dae4cd49b43';

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
