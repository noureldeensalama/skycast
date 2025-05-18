import 'package:weather_app/Models/WeatherUpdate.dart';
import 'package:weather_app/Models/WidgetState.dart';
import 'package:weather_app/Widgets/HourlyCardLargeWidget.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../Widgets/MainAppBar.dart';
import 'dart:convert';
import 'dart:math';
import '../Models/Constants.dart';
import '../Models/ThemeAttribute.dart';
import '../Models/Utility.dart';
import '../Models/WidgetState.dart';


class ForecastPage extends StatefulWidget {
  final WIDGET_STATE stateId;
  final List<WeatherUpdate> widgetDataObject;
  const ForecastPage({required Key key, this.stateId = WIDGET_STATE.INITIAL_STATE, required this.widgetDataObject}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForecastPageState(stateId: this.stateId, widgetDataObject: this.widgetDataObject);
}


class _ForecastPageState extends State<ForecastPage> with WidgetsBindingObserver, TickerProviderStateMixin {

  WIDGET_STATE stateId;
  late List<WeatherUpdate> widgetDataObject;
  WIDGET_STATE _mainDisplayState = WIDGET_STATE.HAS_DATA;
  Widget _view = Container();
  ThemeAttribute _themeAttribute = ThemeAttribute();
  final Utility _utility = Utility();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isPageLoading = false;


  _ForecastPageState({this.stateId = WIDGET_STATE.INITIAL_STATE, required this.widgetDataObject});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Variables
    final Size deviceSize = MediaQuery.of(context).size;

    //Set view
    switch (stateId) {
      case WIDGET_STATE.IS_LOADING:
        _view = SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            appBar: MainAppBar(),
            body: Container(),
          ),
        );
        break;
      case WIDGET_STATE.HAS_ERROR:
      // Handle error state
        break;
      case WIDGET_STATE.HAS_DATA:
        _view = SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: _themeAttribute.primaryColor,
            appBar: MainAppBar(
              backgroundColor: Colors.transparent,
              appBarMode: AppBarMode.back,
            ),
            body: SingleChildScrollView(
              child: _mainDisplay(),
            ),
          ),
        );
        break;
      default:
        _view = SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: MainAppBar(),
            body: _mainDisplay(),
          ),
        );
    }

    return _view;
  }

  Widget _mainDisplay() {
    //Variables
    final Size deviceSize = MediaQuery.of(context).size;

    switch (_mainDisplayState) {
      case WIDGET_STATE.IS_LOADING:
        return Container();
      case WIDGET_STATE.NO_DATA:
        return Container();
      case WIDGET_STATE.HAS_DATA:
        return Container(
          width: deviceSize.width,
          padding: const EdgeInsets.only(left: 0, right: 0, bottom: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(0, 0, 23, 75),
                Color.fromARGB(255, 12, 69, 160),
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 0),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: _weatherIcon(widgetDataObject[0], deviceSize.width * 0.4),
                    ),
                    const SizedBox(width: 30),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today",
                            style: _themeAttribute.textStyle_1.apply(fontSizeDelta: 3),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Text(
                                  widgetDataObject[0].temperature.amount.toString(),
                                  style: _themeAttribute.textStyle_1.apply(
                                    fontWeightDelta: 900,
                                    fontSizeDelta: 64,
                                    fontFamily: 'Iwata Maru Gothic W55',
                                  ),
                                ),
                                Text(
                                  widgetDataObject[0].temperature.units,
                                  style: _themeAttribute.textStyle_1.apply(
                                    fontSizeDelta: 48,
                                    fontFamily: 'Iwata Maru Gothic W55',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            widgetDataObject[0].condition.name,
                            style: _themeAttribute.textStyle_1.apply(fontSizeDelta: 10),
                          ),
                          Text(
                            "Real Feel ${widgetDataObject[0].temperature.feels_like}${widgetDataObject[0].temperature.units}",
                            style: _themeAttribute.textStyle_2.apply(fontSizeDelta: 0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 40, right: 40),
                width: deviceSize.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildWeatherDetail("lib/Assets/Images/rain_drop_500x500.png", widgetDataObject[0].precipitation.amount.toDouble(), widgetDataObject[0].precipitation.units),
                    _buildWeatherDetail("lib/Assets/Images/wind_500x500.png", widgetDataObject[0].wind.amount.toDouble(), widgetDataObject[0].wind.units),
                    _buildWeatherDetail("lib/Assets/Images/speed_500x500.png", widgetDataObject[0].humidity.amount.toDouble(), widgetDataObject[0].humidity.units),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                child: Column(
                  key: GlobalKey(),
                  children: [
                    ...widgetDataObject.getRange(1, 6).toList().asMap().entries.map((weatherUpdate) {
                      return HourlyCardLargeWidget(
                        key: Key("hourly_${weatherUpdate.value.id}"),
                        stateId: WIDGET_STATE.HAS_DATA,
                        widgetDataObject: weatherUpdate.value,
                        active: weatherUpdate.key == 0,
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      default:
        return Container();
    }
  }

  Widget _pageLoader() {
    if (_isPageLoading) {
      return Container(
        height: 3,
        margin: const EdgeInsets.only(bottom: 5),
        child: const LinearProgressIndicator(
          backgroundColor: Colors.black,
        ),
      );
    } else {
      return Container(
        height: 3,
        margin: const EdgeInsets.only(bottom: 5),
      );
    }
  }

  Widget _weatherIcon(WeatherUpdate weatherUpdate, double size) {
    switch (weatherUpdate.condition.id) {
      case 1:
        return Image.asset(
          packagePath + "lib/Assets/Images/sun_500x500.png",
          width: size,
          height: size,
        );
      case 2:
        return Image.asset(
          packagePath + "lib/Assets/Images/partly_cloudy_500x500.png",
          width: size,
          height: size,
        );
      case 3:
        return Image.asset(
          packagePath + "lib/Assets/Images/cloud_x3_500x500.png",
          width: size,
          height: size,
        );
      case 4:
        return Image.asset(
          packagePath + "lib/Assets/Images/cloud_x2_rainly_500x500.png",
          width: size,
          height: size,
        );
      case 5:
        return Image.asset(
          packagePath + "lib/Assets/Images/stormy_500x500.png",
          width: size,
          height: size,
        );
      default:
        return Image.asset(
          packagePath + "lib/Assets/Images/cloud_x3_500x500.png",
          width: size,
          height: size,
        );
    }
  }

  Widget _buildWeatherDetail(String imagePath, double value, String unit) {
    return Row(
      children: [
        Image.asset(
          packagePath + imagePath,
          width: 25,
          height: 25,
        ),
        const SizedBox(width: 5),
        Text(
          "${value.toStringAsFixed(0)}$unit",
          style: _themeAttribute.textStyle_2,
        ),
      ],
    );
  }
}