import 'package:weather_app/Models/WeatherUpdate.dart';
import 'package:weather_app/Models/WidgetState.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../Widgets/HourlyCardSmallWidget.dart';
import '../Widgets/MainAppBar.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import './ForecastPage.dart';
import '../Models/Constants.dart';
import '../Models/ThemeAttribute.dart';
import '../Models/Utility.dart';
import '../Models/WidgetState.dart';
import '../Services/WeatherService.dart';


class HomePage extends StatefulWidget {
  /*[Attributes]*/

  HomePage()
  {

  }

  /*
  * @Description:
  *
  * @param:
  *
  * @return: void
  */
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}
class _HomePage extends State<HomePage> with WidgetsBindingObserver, TickerProviderStateMixin{

  WIDGET_STATE _state_id = WIDGET_STATE.HAS_DATA;
  WIDGET_STATE _mainDisplayState = WIDGET_STATE.INITIAL_STATE;
  Widget _view = Container();
  ThemeAttribute _themeAttribute = ThemeAttribute();
  final Utility _utility = Utility();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isPageLoading = false;
  final WeatherService _weatherService = WeatherService();
  List<WeatherUpdate> _weatherUpdates = [];
  int _precipitation = 0;
  int _temperature = 0;
  double _wind = 0.0;
  int _humidity = 0;

  _HomePage() {}

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _getWeatherUpdates();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    //Variables
    final Size deviceSize = MediaQuery.of(context).size;

    //Set view
    switch(_state_id)
        {
      case WIDGET_STATE.IS_LOADING:
        {
          _view = SafeArea(
              child: Scaffold(
                key: _scaffoldKey,
                appBar: MainAppBar(),
                body: Container(
                  //color: Colors.red,
                ),
              )
          );
          break;
        }

      case WIDGET_STATE.HAS_ERROR:
        {
          break;
        }

      case WIDGET_STATE.HAS_DATA:
        {
          _view = SafeArea(
              child: Scaffold(
                key: _scaffoldKey,
                backgroundColor: _themeAttribute.primaryColor,
                appBar: MainAppBar(
                  backgroundColor: Colors.transparent,
                ),
                body: SingleChildScrollView(
                  child: _mainDisplay(),
                ),
              )
          );
          break;
        }


      default:
        {
          _view = SafeArea(
              child: Scaffold(
                key: _scaffoldKey,
                backgroundColor: Colors.white,
                appBar: MainAppBar(),
                body: _mainDisplay(),
              )
          );
          break;
        }
    }


    return _view;
  }


  /*[Methods]*/


  /*
    * @Description:
    *
    * @param:
    *
    * @return: void
    */
  Widget _mainDisplay() {
    //Variables
    final Size deviceSize = MediaQuery.of(context).size;



    switch(_mainDisplayState)
    {
      case WIDGET_STATE.IS_LOADING:
        {
          return Container(
          );
          break;
        }

      case WIDGET_STATE.NO_DATA:
        {
          return Container();
          break;
        }

      case WIDGET_STATE.HAS_DATA:
        {
          return Container(
            width: deviceSize.width,
            padding: const EdgeInsets.only(left: 0, right: 0, bottom: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color(0xFFFF9800), // #FF9800 (Orange)
                    Color(0xFF616161), // Darker Grey
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(0.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Text(_weatherUpdates[0].location.city+",",
                        style: _themeAttribute.textStyle_1 .apply(
                          fontWeightDelta: 900,
                          fontSizeDelta: 10
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        Text(_weatherUpdates[0].location.country,
                          style: _themeAttribute.textStyle_2.apply(
                              fontWeightDelta: 2
                          ),),
                      ],
                    )
                ),
                const SizedBox(
                  height: 2,
                ),
                Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        Text(
                            '4/2/2025',
                          style: _themeAttribute.textStyle_2,
                        ),
                      ],
                    )
                ),
                const SizedBox(
                  height: 0,
                ),
                Center(
                  child: Container(
                    child: _weatherIcon(_weatherUpdates[0], deviceSize.width * 0.4),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 60,
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: _temperature.toDouble()),
                      curve: Curves.decelerate,
                      duration: const Duration(seconds: 2),
                      builder: (BuildContext context, double amount, Widget? child) {
                        return Text(amount.toStringAsFixed(0),
                          style: _themeAttribute.textStyle_1.apply(
                              fontWeightDelta: 900,
                              fontSizeDelta: 80,
                              fontFamily: 'Iwata Maru Gothic W55'
                          ),
                        );
                      },
                      child: const Icon(Icons.aspect_ratio),
                    ),
                    Text(_weatherUpdates[0].temperature.units,
                      style: _themeAttribute.textStyle_1.apply(
                        fontSizeDelta: 60,
                        fontFamily: 'Iwata Maru Gothic W55',
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_weatherUpdates[0].condition.name,
                      style: _themeAttribute.textStyle_1.apply(
                          fontSizeDelta: 10
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Real Feel "+_weatherUpdates[0].temperature.feels_like.toString()+_weatherUpdates[0].temperature.units,
                      style: _themeAttribute.textStyle_2.apply(
                          fontSizeDelta: 0
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  width: deviceSize.width * 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Image.asset(
                              packagePath+"lib/Assets/Images/rain_drop_500x500.png",
                              width: 25,
                              height: 25,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0, end: _precipitation.toDouble()),
                              curve: Curves.decelerate,
                              duration: const Duration(seconds: 2),
                              builder: (BuildContext context, double amount, Widget? child) {
                                return Text(amount.toStringAsFixed(0)+_weatherUpdates[0].precipitation.units.toString(),
                                    style: _themeAttribute.textStyle_2
                                );
                              },
                              child: const Icon(Icons.aspect_ratio),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Image.asset(
                              packagePath+"lib/Assets/Images/wind_500x500.png",
                              width: 25,
                              height: 25,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0, end: _wind),
                              curve: Curves.decelerate,
                              duration: const Duration(seconds: 2),
                              builder: (BuildContext context, double amount, Widget? child) {
                                return Text(amount.toStringAsFixed(1)+_weatherUpdates[0].wind.units.toString(),
                                    style: _themeAttribute.textStyle_2
                                );
                              },
                              child: const Icon(Icons.aspect_ratio),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Image.asset(
                              packagePath+"lib/Assets/Images/speed_500x500.png",
                              width: 25,
                              height: 25,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0, end: _humidity.toDouble()),
                              curve: Curves.decelerate,
                              duration: const Duration(seconds: 2),
                              builder: (BuildContext context, double amount, Widget? child) {
                                return Text(amount.toStringAsFixed(0)+_weatherUpdates[0].humidity.units.toString(),
                                    style: _themeAttribute.textStyle_2
                                );
                              },
                              child: const Icon(Icons.aspect_ratio),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text("Today",
                    style: _themeAttribute.textStyle_1 .apply(
                      fontWeightDelta: 900,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  child: CarouselSlider(
                    options: CarouselOptions(
                        height: 100,
                        viewportFraction: 0.45,
                        initialPage: 1,
                        reverse: false,
                        enlargeCenterPage: false,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, carouselPageChangedReason){}
                    ),
                    items: _weatherUpdates[0].hourly.asMap().entries.map((weatherUpdate) {
                      return Builder(
                        key: GlobalKey(),
                        builder: (BuildContext context) {
                          return GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(left: 0, right: 0),
                                child: HourlyCardSmallWidget(key: GlobalKey(), stateId: WIDGET_STATE.HAS_DATA, widgetDataObject: weatherUpdate.value, active: weatherUpdate.key == 0,),
                              ),
                              onTap: (){
                                /*Navigator.push(
                                              context,
                                              MaterialPageRoute<bool>(
                                                  builder: (BuildContext context) => ForecastPage()
                                              )
                                          );*/
                              }
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: Text("More Details >",
                          style: _themeAttribute.textStyle_2.apply(
                            fontSizeDelta: 0,

                          ),
                        ),
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute<bool>(
                                  builder: (BuildContext context) => ForecastPage(key: GlobalKey(), stateId: WIDGET_STATE.HAS_DATA, widgetDataObject: _weatherUpdates)
                              )
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      width: deviceSize.width * 0.8,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 80,
                                child: Text("Today",
                                  style: _themeAttribute.textStyle_2 .apply(
                                    fontSizeDelta: 0,
                                  ),
                                ),
                              ),
                              _weatherIcon(_weatherUpdates[0], 25.0),
                              Text(_weatherUpdates[0].temperature.low.toString()+_weatherUpdates[0].temperature.units+"/"+_weatherUpdates[0].temperature.high.toString()+_weatherUpdates[0].temperature.units,
                                style: _themeAttribute.textStyle_2 .apply(
                                  fontSizeDelta: 0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 80,
                                child: Text("Tomorrow",
                                  style: _themeAttribute.textStyle_2 .apply(
                                    fontSizeDelta: 0,
                                  ),
                                ),
                              ),
                              _weatherIcon(_weatherUpdates[1], 25.0),
                              Text(_weatherUpdates[1].temperature.low.toString()+_weatherUpdates[1].temperature.units+"/"+_weatherUpdates[1].temperature.high.toString()+_weatherUpdates[1].temperature.units,
                                style: _themeAttribute.textStyle_2 .apply(
                                  fontSizeDelta: 0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 80,
                                child: Text(new DateFormat('EEEE').format(DateTime.parse(_weatherUpdates[2].time)),
                                  style: _themeAttribute.textStyle_2 .apply(
                                    fontSizeDelta: 0,
                                  ),
                                ),
                              ),
                              _weatherIcon(_weatherUpdates[2], 25.0),
                              Text(_weatherUpdates[2].temperature.low.toString()+_weatherUpdates[2].temperature.units+"/"+_weatherUpdates[2].temperature.high.toString()+_weatherUpdates[2].temperature.units,
                                style: _themeAttribute.textStyle_2 .apply(
                                  fontSizeDelta: 0,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: deviceSize.width * 0.8,
                        height: 35,
                        decoration: BoxDecoration(
                          color: _themeAttribute.secondaryColor,
                          /*border: Border.all(
                                  width: 0.0,
                                  style: BorderStyle.solid
                                ), *///Border.all
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ), //BorderRadius.all
                        ),
                        child: Center(
                          child: Text("7 day Forecast",
                            style: _themeAttribute.textStyle_1 .apply(
                                fontSizeDelta: 2,
                                fontWeightDelta: 1
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute<bool>(
                            builder: (BuildContext context) => ForecastPage(key: GlobalKey(), stateId: WIDGET_STATE.HAS_DATA, widgetDataObject: _weatherUpdates)
                        )
                    );
                  },
                )
              ],
            ),
          );
          break;
        }

      default:
        {
          return Container();
          break;
        }

    }
  }

  /*
    * @Description:
    *
    * @param:
    *
    * @return: void
    */
  Widget _pageLoader()
  {
    final Size devicSize = MediaQuery.of(context).size;

    if(_isPageLoading)
    {
      return Container(
        height: 3,
        margin: const EdgeInsets.only(bottom: 5),
        child: const LinearProgressIndicator(
          backgroundColor: Colors.black,
        ),
      );
    }
    else
    {
      return Container(
          height: 3,
          margin: const EdgeInsets.only(bottom: 5)
      );
    }
  }


  /*
    * @Description:
    *
    * @param:
    *
    * @return: void
    */
  Future <List<dynamic>?> _getWeatherUpdates() async {
    //Variables


    setState(() {
      _mainDisplayState = WIDGET_STATE.IS_LOADING;
    });


    List<dynamic>? result = await _weatherService.getWeatherUpdates()
        .then((value) {
      // Run extra code here
      _utility.Custom_Print("Function Complete Successfully");
      _utility.Custom_Print(value.toString());

      return value;
    },
        onError: (error) {
          _utility.Custom_Print("Future returned Error");
          _utility.Custom_Print(error.toString());
          //Toast.show(error['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

          setState(() {
            _isPageLoading = false;
          });

          switch(error.runtimeType) {

            case SocketException: {

              SnackBar snackBar = SnackBar(
                content: Text("Could not login at this time"),
                action: SnackBarAction(
                  label: 'OK',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );

              //_scaffoldKey.currentState.showSnackBar(snackBar);

          Fluttertoast.showToast(
            msg: "Error retrieving weather updates",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
            break;
            }


            default: {

              SnackBar snackBar =  SnackBar(
                content: Text(error['error']),
                action: SnackBarAction(
                  label: 'OK',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );

              //_scaffoldKey.currentState.showSnackBar(snackBar);

            Fluttertoast.showToast(
              msg: "Error retrieving weather updates",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              );
            }
          }
        })
        .catchError((error){
      _utility.Custom_Print("Please try again later");
      _utility.Custom_Print(error.toString());
      //Toast.show("Please try again later", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

      setState(() {
        _isPageLoading = false;
      });
    });

    setState(() {
      _weatherUpdates = result!.map<WeatherUpdate>((e){
        return WeatherUpdate.fromJson(e);
      }).toList();
      _isPageLoading = false;
      _mainDisplayState = WIDGET_STATE.HAS_DATA;
      _temperature = _weatherUpdates[0].temperature.amount;
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _precipitation = _weatherUpdates[0].precipitation.amount;
        _wind = _weatherUpdates[0].wind.amount;
        _humidity = _weatherUpdates[0].humidity.amount;
      });
    });

    return result;
  }

  /*
    * @Description:
    *
    * @param:
    *
    * @return: void
    */
  Widget _weatherIcon(WeatherUpdate weatherUpdate, double size) {
    //Variables

    switch (weatherUpdate.condition.id) {
      case 1:
        return Image.asset(
          packagePath+"lib/Assets/Images/sun_500x500.png",
          width: size,
          height: size,
        );
        break;

      case 2:
        return Image.asset(
          packagePath+"lib/Assets/Images/partly_cloudy_500x500.png",
          width: size,
          height: size,
        );
        break;

      case 3:
        return Image.asset(
          packagePath+"lib/Assets/Images/cloud_x3_500x500.png",
          width: size,
          height: size,
        );
        break;

      case 4:
        return Image.asset(
          packagePath+"lib/Assets/Images/cloud_x2_rainly_500x500.png",
          width: size,
          height: size,
        );
        break;

      case 5:
        return Image.asset(
          packagePath+"lib/Assets/Images/stormy_500x500.png",
          width: size,
          height: size,
        );
        break;

      default:
        return Image.asset(
          packagePath+"lib/Assets/Images/cloud_x3_500x500.png",
          width: size,
          height: size,
        );
    }
  }
}
// class _HomePage extends State<HomePage> with WidgetsBindingObserver, TickerProviderStateMixin {
//   WIDGET_STATE _state_id = WIDGET_STATE.HAS_DATA;
//   WIDGET_STATE _mainDisplayState = WIDGET_STATE.INITIAL_STATE;
//   Widget _view = Container();
//   ThemeAttribute _themeAttribute = ThemeAttribute();
//   final Utility _utility = Utility();
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   bool _isPageLoading = false;
//   final WeatherService _weatherService = WeatherService();
//   List<WeatherUpdate> _weatherUpdates = [];
//   double _precipitation = 0.0; // Changed to double
//   double _temperature = 0.0; // Changed to double
//   double _wind = 0.0; // Changed to double
//   double _humidity = 0.0; // Changed to double
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _getWeatherUpdates();
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final Size deviceSize = MediaQuery.of(context).size;
//
//     switch (_state_id) {
//       case WIDGET_STATE.IS_LOADING:
//         _view = SafeArea(
//           child: Scaffold(
//             key: _scaffoldKey,
//             appBar: MainAppBar(),
//             body: Container(),
//           ),
//         );
//         break;
//       case WIDGET_STATE.HAS_ERROR:
//       // Handle error state
//         break;
//       case WIDGET_STATE.HAS_DATA:
//         _view = SafeArea(
//           child: Scaffold(
//             key: _scaffoldKey,
//             backgroundColor: _themeAttribute.primaryColor,
//             appBar: MainAppBar(backgroundColor: Colors.transparent),
//             body: SingleChildScrollView(child: _mainDisplay()),
//           ),
//         );
//         break;
//       default:
//         _view = SafeArea(
//           child: Scaffold(
//             key: _scaffoldKey,
//             backgroundColor: Colors.white,
//             appBar: MainAppBar(),
//             body: _mainDisplay(),
//           ),
//         );
//     }
//
//     return _view;
//   }
//
//   Widget _mainDisplay() {
//     final Size deviceSize = MediaQuery.of(context).size;
//
//     switch (_mainDisplayState) {
//       case WIDGET_STATE.IS_LOADING:
//         return Container();
//       case WIDGET_STATE.NO_DATA:
//         return Container();
//       case WIDGET_STATE.HAS_DATA:
//         return Container(
//           width: deviceSize.width,
//           padding: const EdgeInsets.only(left: 0, right: 0, bottom: 20),
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xFFFF9800), // #FF9800 (Orange)
//                 Color(0xFFF57C00), // #F57C00 (Darker Orange)
//               ],
//               begin: FractionalOffset(0.0, 0.0),
//               end: FractionalOffset(0.0, 1.0),
//               stops: [0.0, 1.0],
//               tileMode: TileMode.clamp,
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildLocationInfo(),
//               _buildWeatherIcon(deviceSize),
//               _buildTemperatureInfo(),
//               _buildWeatherDetails(deviceSize),
//               _buildHourlyForecast(),
//               _buildMoreDetailsButton(),
//               _buildDailyForecast(),
//               _buildSevenDayForecastButton(),
//             ],
//           ),
//         );
//       default:
//         return Container();
//     }
//   }
//
//   Widget _buildLocationInfo() {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.only(left: 20, right: 20),
//           child: Row(
//             children: [
//               Text(
//                 "${_weatherUpdates[0].location.city},",
//                 style: _themeAttribute.textStyle_1.apply(fontWeightDelta: 900),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 2),
//         Container(
//           padding: const EdgeInsets.only(left: 20, right: 20),
//           child: Row(
//             children: [
//               Text(
//                 _weatherUpdates[0].location.country,
//                 style: _themeAttribute.textStyle_2.apply(fontWeightDelta: 2),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 4),
//         Container(
//           padding: const EdgeInsets.only(left: 20, right: 20),
//           child: Row(
//             children: [
//               Text(
//                 DateFormat('MMM. dd, yyyy').format(DateTime.parse(_weatherUpdates[0].time)),
//                 style: _themeAttribute.textStyle_2,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildWeatherIcon(Size deviceSize) {
//     return Center(
//       child: Container(
//         child: _weatherIcon(_weatherUpdates[0], deviceSize.width * 0.4),
//       ),
//     );
//   }
//
//   Widget _buildTemperatureInfo() {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(width: 60),
//             TweenAnimationBuilder<double>(
//               tween: Tween<double>(begin: 0, end: _temperature),
//               curve: Curves.decelerate,
//               duration: const Duration(seconds: 2),
//               builder: (BuildContext context, double amount, Widget? child) {
//                 return Text(
//                   amount.toStringAsFixed(0),
//                   style: _themeAttribute.textStyle_1.apply(
//                     fontWeightDelta: 900,
//                     fontSizeDelta: 80,
//                     fontFamily: 'Iwata Maru Gothic W55',
//                   ),
//                 );
//               },
//             ),
//             Text(
//               _weatherUpdates[0].temperature.units,
//               style: _themeAttribute.textStyle_1.apply(
//                 fontSizeDelta: 60,
//                 fontFamily: 'Iwata Maru Gothic W55',
//               ),
//             ),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               _weatherUpdates[0].condition.name,
//               style: _themeAttribute.textStyle_1.apply(fontSizeDelta: 10),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Real Feel ${_weatherUpdates[0].temperature.feels_like}${_weatherUpdates[0].temperature.units}",
//               style: _themeAttribute.textStyle_2.apply(fontSizeDelta: 0),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildWeatherDetails(Size deviceSize) {
//     return Container(
//       padding: const EdgeInsets.only(left: 40, right: 40),
//       width: deviceSize.width,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _buildWeatherDetail("lib/Assets/Images/rain_drop_500x500.png", _precipitation, _weatherUpdates[0].precipitation.units),
//           _buildWeatherDetail("lib/Assets/Images/wind_500x500.png", _wind, _weatherUpdates[0].wind.units),
//           _buildWeatherDetail("lib/Assets/Images/speed_500x500.png", _humidity, _weatherUpdates[0].humidity.units),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWeatherDetail(String imagePath, double value, String unit) {
//     return Row(
//       children: [
//         Image.asset(
//           packagePath + imagePath,
//           width: 25,
//           height: 25,
//         ),
//         const SizedBox(width: 5),
//         TweenAnimationBuilder<double>(
//           tween: Tween<double>(begin: 0, end: value),
//           curve: Curves.decelerate,
//           duration: const Duration(seconds: 2),
//           builder: (BuildContext context, double amount, Widget? child) {
//             return Text(
//               "${amount.toStringAsFixed(0)}$unit",
//               style: _themeAttribute.textStyle_2,
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildHourlyForecast() {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.only(left: 20, right: 20),
//           child: Text(
//             "Today",
//             style: _themeAttribute.textStyle_1.apply(fontWeightDelta: 900),
//           ),
//         ),
//         const SizedBox(height: 5),
//         Container(
//           child: CarouselSlider(
//             options: CarouselOptions(
//               height: 100,
//               viewportFraction: 0.45,
//               initialPage: 1,
//               reverse: false,
//               enlargeCenterPage: false,
//               enableInfiniteScroll: false,
//               onPageChanged: (index, carouselPageChangedReason) {},
//             ),
//             items: _weatherUpdates[0].hourly.asMap().entries.map((entry) {
//               return GestureDetector(
//                 child: HourlyCardSmallWidget(
//                   key: GlobalKey(),
//                   stateId: WIDGET_STATE.HAS_DATA,
//                   widgetDataObject: entry.value,
//                   active: entry.key == 0,
//                 ),
//                 onTap: () {
//                   // Navigate to forecast page
//                 },
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildMoreDetailsButton() {
//     return Container(
//       padding: const EdgeInsets.only(left: 40, right: 40),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           GestureDetector(
//             child: Text(
//               "More Details >",
//               style: _themeAttribute.textStyle_2.apply(fontSizeDelta: 0),
//             ),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute<bool>(
//                   builder: (BuildContext context) => ForecastPage(
//                     key: GlobalKey(),
//                     stateId: WIDGET_STATE.HAS_DATA,
//                     widgetDataObject: _weatherUpdates,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDailyForecast() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           padding: const EdgeInsets.only(left: 20, right: 20),
//           width: MediaQuery.of(context).size.width * 0.8,
//           child: Column(
//             children: [
//               _buildDailyForecastRow(0),
//               _buildDailyForecastRow(1),
//               _buildDailyForecastRow(2),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDailyForecastRow(int index) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Container(
//           width: 80,
//           child: Text(
//             index == 0 ? "Today" : index == 1 ? "Tomorrow" : DateFormat('EEEE').format(DateTime.parse(_weatherUpdates[index].time)),
//             style: _themeAttribute.textStyle_2.apply(fontSizeDelta: 0),
//           ),
//         ),
//         _weatherIcon(_weatherUpdates[index], 25.0),
//         Text(
//           "${_weatherUpdates[index].temperature.low}${_weatherUpdates[index].temperature.units}/${_weatherUpdates[index].temperature.high}${_weatherUpdates[index].temperature.units}",
//           style: _themeAttribute.textStyle_2.apply(fontSizeDelta: 0),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSevenDayForecastButton() {
//     return GestureDetector(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width * 0.8,
//             height: 35,
//             decoration: BoxDecoration(
//               color: _themeAttribute.secondaryColor,
//               borderRadius: const BorderRadius.all(Radius.circular(10)),
//             ),
//             child: Center(
//               child: Text(
//                 "7 day Forecast",
//                 style: _themeAttribute.textStyle_1.apply(fontSizeDelta: 2, fontWeightDelta: 1),
//               ),
//             ),
//           ),
//         ],
//       ),
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute<bool>(
//             builder: (BuildContext context) => ForecastPage(
//               key: GlobalKey(),
//               stateId: WIDGET_STATE.HAS_DATA,
//               widgetDataObject: _weatherUpdates,
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _pageLoader() {
//     if (_isPageLoading) {
//       return Container(
//         height: 3,
//         margin: const EdgeInsets.only(bottom: 5),
//         child: const LinearProgressIndicator(backgroundColor: Colors.black),
//       );
//     } else {
//       return Container(height: 3, margin: const EdgeInsets.only(bottom: 5));
//     }
//   }
//
//   Future<List<dynamic>?> _getWeatherUpdates() async {
//     setState(() {
//       _mainDisplayState = WIDGET_STATE.IS_LOADING;
//     });
//
//     List<dynamic>? result = await _weatherService.getWeatherUpdates().then((value) {
//       _utility.Custom_Print("Function Complete Successfully");
//       _utility.Custom_Print(value.toString());
//       return value;
//     }).catchError((error) {
//       _utility.Custom_Print("Future returned Error");
//       _utility.Custom_Print(error.toString());
//       setState(() {
//         _isPageLoading = false;
//       });
//       Fluttertoast.showToast(
//         msg: "Error retrieving weather updates",
//         toastLength: Toast.LENGTH_LONG,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//     });
//
//     setState(() {
//       _weatherUpdates = result!.map<WeatherUpdate>((e) => WeatherUpdate.fromJson(e)).toList();
//       _isPageLoading = false;
//       _mainDisplayState = WIDGET_STATE.HAS_DATA;
//       _temperature = _weatherUpdates[0].temperature.amount.toDouble(); // Convert to double
//     });
//
//     Future.delayed(Duration(seconds: 1), () {
//       setState(() {
//         _precipitation = _weatherUpdates[0].precipitation.amount.toDouble(); // Convert to double
//         _wind = _weatherUpdates[0].wind.amount.toDouble(); // Convert to double
//         _humidity = _weatherUpdates[0].humidity.amount.toDouble(); // Convert to double
//       });
//     });
//
//     return result;
//   }
//
//   Widget _weatherIcon(WeatherUpdate weatherUpdate, double size) {
//     switch (weatherUpdate.condition.id) {
//       case 1:
//         return Image.asset(
//           packagePath + "lib/Assets/Images/sun_500x500.png",
//           width: size,
//           height: size,
//         );
//       case 2:
//         return Image.asset(
//           packagePath + "lib/Assets/Images/partly_cloudy_500x500.png",
//           width: size,
//           height: size,
//         );
//       case 3:
//         return Image.asset(
//           packagePath + "lib/Assets/Images/cloud_x3_500x500.png",
//           width: size,
//           height: size,
//         );
//       case 4:
//         return Image.asset(
//           packagePath + "lib/Assets/Images/cloud_x2_rainly_500x500.png",
//           width: size,
//           height: size,
//         );
//       case 5:
//         return Image.asset(
//           packagePath + "lib/Assets/Images/stormy_500x500.png",
//           width: size,
//           height: size,
//         );
//       default:
//         return Image.asset(
//           packagePath + "lib/Assets/Images/cloud_x3_500x500.png",
//           width: size,
//           height: size,
//         );
//     }
//   }
// }