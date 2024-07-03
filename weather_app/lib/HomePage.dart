import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'weatherProvider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  late SharedPreferences _prefs;
  String _lastSearchedCity = '';

  @override
  void initState() {
    super.initState();
    _loadLastCity();
  }

  Future<void> _loadLastCity() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastSearchedCity = _prefs.getString('lastCity') ?? '';
      _controller.text = _lastSearchedCity;
    });
  }

  Future<void> _saveLastCity(String city) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('lastCity', city);
    setState(() {
      _lastSearchedCity = city;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'Welcome to the \n Weather App \ud83c\udf1e',
                  style: TextStyle(
                    fontSize: 38,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              SizedBox(height: 60),
              Text(
                'Enter City',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'City',
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: 'e.g. London',
                  hintStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  prefixIcon: Icon(Icons.location_city, color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    Provider.of<WeatherProvider>(context, listen: false)
                        .fetchWeather(_controller.text);
                    _saveLastCity(
                        _controller.text); // Save city to shared preferences
                    Navigator.pushNamed(context, '/details');
                  }
                },
                child: Text(
                  'Get Weather',
                  style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Consumer<WeatherProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  }
                  if (provider.errorMessage != null) {
                    return Center(
                      child: Text(
                        provider.errorMessage!,
                        style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return Container();
                },
              ),
              SizedBox(height: 20),
              _lastSearchedCity.isNotEmpty
                  ? Center(
                      child: Text(
                        'Last Searched City: $_lastSearchedCity',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
