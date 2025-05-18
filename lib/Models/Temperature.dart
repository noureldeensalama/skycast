import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Temperature
{
    /*[Attributes]*/
    late int amount;
    late int feels_like;
    late String units;
    late int high;
    late int low;

    /*[Constructors]*/
    Temperature();

    //JSON serialization
    Temperature.fromJson(Map<String, dynamic> json):
        amount = json['amount'],
        feels_like = json['feels_like'],
        high = json['high'],
        low = json['low'],
        units = json['units'];

    Map<String, dynamic> toJson() =>
    {
        'amount': amount,
        'feels_like': feels_like,
        'high': high,
        'low': low,
        'units': units
    };

    /*[Methods]*/
}