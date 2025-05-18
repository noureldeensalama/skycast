import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Precipitation
{
    /*[Attributes]*/
    late int amount;
    late String units;

    /*[Constructors]*/
    Precipitation();

    //JSON serialization
    Precipitation.fromJson(Map<String, dynamic> json):
        amount = json['amount'],
        units = json['units'];

    Map<String, dynamic> toJson() =>
    {
        'amount': amount,
        'units': units
    };

    /*[Methods]*/

}