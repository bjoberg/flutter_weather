import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/widgets/gradient_container.dart';

import 'package:flutter_weather/widgets/widgets.dart';
import 'package:flutter_weather/blocs/blocs.dart';

class Weather extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Weather'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () async {
            final city = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CitySelection(),
              ),
            );
            if (city != null) {
              BlocProvider.of<WeatherBloc>(context)
                  .add(FetchWeather(city: city));
            }
          },
        )
      ]),
      body: Center(
        child: BlocConsumer<WeatherBloc, WeatherState>(
          listener: (context, state) {
            if (state is WeatherLoaded) {
              BlocProvider.of<ThemeBloc>(context).add(
                WeatherChanged(condition: state.weather.condition),
              );
            }
          },
          builder: (context, state) {
            if (state is WeatherEmpty) {
              return Center(child: Text('Please Select a Location'));
            }

            if (state is WeatherLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is WeatherLoaded) {
              final weather = state.weather;

              return BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, themeState) {
                  return GradientContainer(
                      color: themeState.color,
                      child: ListView(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top: 100.0),
                              child: Center(
                                  child: Location(location: weather.location))),
                          Center(
                            child: LastUpdated(dateTime: weather.lastUpdated),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 50.0),
                            child: Center(
                              child: CombinedWeatherTemperature(
                                weather: weather,
                              ),
                            ),
                          ),
                        ],
                      ));
                },
              );
            }
            if (state is WeatherError) {
              return Text(
                'Something went wrong!',
                style: TextStyle(color: Colors.red),
              );
            }
          },
        ),
      ),
    );
  }
}
