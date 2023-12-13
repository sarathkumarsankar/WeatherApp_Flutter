import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'additonal_info_item.dart';
import 'hourly_forescast_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0;

  final location = "London";
  final appID = "4bf3c54ba9c5ab700df43949e04a93c3";

  @override
  void initState() {
    // getWeatherReport();
    super.initState();
  }

  Future<Map<String, dynamic>> getWeatherReport() async {
    try {
      var res = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$location&APPID=$appID"));
      final dataString = jsonDecode(res.body);
      if (dataString['cod'] != '200') {
        throw 'Unexpected error ocurred';
      }
      //  var data = dataString['list'][0]['main']['temp'];
      return dataString;
    } catch (e) {
      throw e.toString();
    }
  }

double fahrenheitToCelsius(double fahrenheit) {
  return (fahrenheit - 32) * 5 / 9;
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          location,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: getWeatherReport(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final mainData = snapshot.data!['list'];
          final cuurentTemperature = mainData[0]['main']['temp'];
          final celsius = fahrenheitToCelsius(cuurentTemperature);
          final skyCondition = mainData[0]['weather'][0]['main'];
          final humidity = mainData[0]['main']['humidity'];
          final windSpeed = mainData[0]['wind']['speed'];
          final pressure = mainData[0]['main']['pressure'];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  // PlaceHolder 1
                  [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              "$cuurentTemperature°F",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.cloud,
                              size: 50,
                            ),
                            const Spacer(),
                            Text(
                              skyCondition,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // PlaceHolder 2
                const SizedBox(height: 10),
                const Text(
                  "Weather Forecast",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    itemBuilder: ((context, index) {
                      final time =
                          DateTime.parse(mainData[index + 1]['dt_txt']);
                      final currentSkyCondition =
                          mainData[index + 1]['weather'][0]['main'];

                      return HourlyForeCastItem(
                        climate: mainData[index + 1]['main']['temp'].toString(),
                        time: DateFormat.jm().format(time),
                        skyIcon: currentSkyCondition == "Rain" ||
                                currentSkyCondition == "Clouds"
                            ? Icons.cloud
                            : Icons.sunny,
                      );
                    }),
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                  ),
                ),
                // PlaceHolder 3
                const SizedBox(height: 10),
                const Text(
                  "Additional information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AdditionalInformationItem(
                          info: "Humidity",
                          skyIcon: Icons.water_drop,
                          value: humidity.toString(),
                        ),
                        AdditionalInformationItem(
                          info: "Wind Speed",
                          skyIcon: Icons.air,
                          value: windSpeed.toString(),
                        ),
                        AdditionalInformationItem(
                          info: "Pressure",
                          skyIcon: Icons.beach_access,
                          value: pressure.toString(),
                        ),
                      ],
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
