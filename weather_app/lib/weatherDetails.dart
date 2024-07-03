import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weatherProvider.dart';

class WeatherDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Weather Details' , style: TextStyle(fontSize: 28 , color: Colors.white),),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Consumer<WeatherProvider>(
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
                  style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              );
            }
            if (provider.weatherData == null) {
              return Center(
                child: Text(
                  'No data available',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              provider.weatherData!['name'],
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Center(
                            child: Image.network(
                              'http://openweathermap.org/img/w/${provider.weatherData!['weather'][0]['icon']}.png',
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Temperature: ${provider.weatherData!['main']['temp']} °C',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Weather: ${provider.weatherData!['weather'][0]['description']}',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Humidity: ${provider.weatherData!['main']['humidity']}%',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Wind Speed: ${provider.weatherData!['wind']['speed']} m/s',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        provider.fetchWeather(provider.city!);
                      },
                      child: Text(
                        'Refresh',
                        style: TextStyle(fontSize: 18, color: Colors.deepPurpleAccent),
                      ),
                      style: ElevatedButton.styleFrom(
                     
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
