import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Location
{
    /*[Attributes]*/
    late int id;
    late String city;
    late String country;

    /*[Constructors]*/
    Location();

    //JSON serialization
    Location.fromJson(Map<String, dynamic> json):
        id = json['id'],
        city = json['city'],
        country = json['country'];

    Map<String, dynamic> toJson() =>
    {
        'id': id,
        'city': city,
        'country': country
    };

    /*[Methods]*/
    int get getID{
        return id;
    }

}