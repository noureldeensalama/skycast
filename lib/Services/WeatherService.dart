import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Models/Constants.dart';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:mock_web_server/mock_web_server.dart';

import '../Models/Utility.dart';

class WeatherService{
    /*[Attributes]*/
    Utility utility = new Utility();
    late MockWebServer _server;
    

    /*[Contsructors]*/
    WeatherService(){
        _server = new MockWebServer();
        _server.start();
    }

    Future<dynamic> getWeatherUpdates() async
    {
        this.utility.Custom_Print("START: getWeatherUpdates");
        //Variables/
        //BuildContext context;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        dynamic results;

        //Mock API Service
        //Load the JSON file from the "Assets" folder
        String jsonString = await rootBundle.loadString(packagePath+"lib/Assets/API/weather_updates.json");
        Map<String, String> ServerHeaders = new Map();
        ServerHeaders["X-Server"] = "MockDart";
        _server.enqueue(body: jsonString, httpCode: 200, headers: ServerHeaders, delay: new Duration(milliseconds: 200));

        utility.Custom_Print(utility.App_API_URL + 'weather/updates');

        HttpClient client = new HttpClient();
        client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

        String url = utility.App_API_URL + 'weather/updates';

        //HttpClientRequest request = await client.getUrl(Uri.parse(url));
        HttpClientRequest request = await client.get(_server.host, _server.port, url);

        request.headers.set('content-type', 'application/json');

        //request.add(utf8.encode(json.encode(formData)));

        HttpClientResponse response = await request.close();

        final dynamic responseData = await response.transform(utf8.decoder).join();
        final dynamic headers = response.headers;
        
        switch(response.statusCode) { 
            case 200: { 
                dynamic items = json.decode(responseData);
                results = items;
            } 
            break;

            case 201: {
                dynamic items = json.decode(responseData);
                results = items;
            } 
            break;

            case 202: { 
                dynamic items = json.decode(responseData);
                results = items;
            } 
            break;
          
            case 400: {
                dynamic error = json.decode(responseData);
            
                return Future.error(error);
            }

            case 401: {
                dynamic error = json.decode(responseData);

                return Future.error(error );
            }

            case 402: {
                dynamic error = json.decode(responseData);

                return Future.error(error );
            }

            case 403: {
                dynamic error = json.decode(responseData);

                return Future.error(error );
            }

            case 404: {
                dynamic error = json.decode(responseData);

                return Future.error(error);
            }

            case 419: {
                dynamic error = json.decode(responseData);

                return Future.error(error);
            }
                
            default: { 
                dynamic error = json.decode(responseData);

                return Future.error(error);
            }
        }

        utility.Custom_Print("STOP: getWeatherUpdates");
        return results;
    }
}