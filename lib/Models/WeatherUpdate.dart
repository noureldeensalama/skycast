import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Condition.dart';
import './Location.dart';
import './Temperature.dart';
import './Precipitation.dart';
import './Wind.dart';
import './Humidity.dart';

class WeatherUpdate
{
    late int id;
    late String time;
    late Condition condition;
    late Location location;
    late Temperature temperature;
    late Precipitation precipitation;
    late Wind wind;
    late Humidity humidity;
    late List<WeatherUpdate> hourly;
    

    /*[Constructors]*/
    WeatherUpdate();

    //JSON serialization
    WeatherUpdate.fromJson(Map<String, dynamic> json):
        id = json['id'],
        time = json['time'],
        condition = Condition.fromJson(json['condition']),
        location = Location.fromJson(json['location']),
        temperature = Temperature.fromJson(json['temperature']),
        precipitation = Precipitation.fromJson(json['precipitation']),
        wind = Wind.fromJson(json['wind']),
        humidity = Humidity.fromJson(json['humidity']),
        hourly = WeatherUpdate.listFromJson(json['hourly']);

    Map<String, dynamic> toJson() =>
    {
        'id': id,
        'time': time,
        'condition': condition,
        'location': location,
        'temperature': temperature,
        'precipitation': precipitation,
        'wind': wind,
        'humidity': humidity,
        'hourly': hourly
    };

    static List<WeatherUpdate> listFromJson(List<dynamic> json){
        List<WeatherUpdate> weatherUpdates = [];

        json.forEach((element){
            weatherUpdates.add(WeatherUpdate.fromJson(element));
        });

        return weatherUpdates;
    }

    /*[Methods]*/
    int get getID{
        return id;
    }

}