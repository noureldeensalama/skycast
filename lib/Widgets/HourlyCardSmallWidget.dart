import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../Models/Constants.dart';
import '../Models/ThemeAttribute.dart';
import '../Models/Utility.dart';
import '../Models/WidgetState.dart';
import '../Models/WeatherUpdate.dart';

class HourlyCardSmallWidget extends StatefulWidget {
  final WIDGET_STATE stateId;
  final WeatherUpdate widgetDataObject;
  final bool active;


  const HourlyCardSmallWidget({required Key key, this.stateId = WIDGET_STATE.INITIAL_STATE, required this.widgetDataObject, this.active = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HourlyCardSmallWidgetState(stateId: this.stateId, widgetDataObject: this.widgetDataObject, active: this.active);
}

class _HourlyCardSmallWidgetState extends State<HourlyCardSmallWidget> {
    /*[Attributes]*/
    WIDGET_STATE stateId;
    late WeatherUpdate widgetDataObject;
    bool active;
    Widget _view = Container();
    ThemeAttribute _themeAttribute = ThemeAttribute();
    Utility _utility = Utility();


    _HourlyCardSmallWidgetState({this.stateId = WIDGET_STATE.INITIAL_STATE, required this.widgetDataObject, this.active = false});


    @override
    void initState(){
        super.initState();
    }
    

    @override
    Widget build(BuildContext context) {
        final Size deviceSize = MediaQuery.of(context).size;
        final double cardWidth = 250;
        final double cardHeight = 250;

        //Set view
        switch(stateId)
        {
            case WIDGET_STATE.INITIAL_STATE:
            {
                _view = Container(
                  height: cardHeight,
                  width: cardWidth,
                  child: Shimmer.fromColors(
                    baseColor: HexColor("#d3d3d3").withOpacity(0.5),
                    highlightColor: Colors.white,
                    enabled: true,
                    child: Card(
                        color: Colors.blue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Container()
                    )
                  )
                );
                break;
            }

            case WIDGET_STATE.IS_LOADING:
            {
                _view = Container();
                break;
            }

            case WIDGET_STATE.NO_DATA:
            {
                _view = Container();
                break;
            }

            case WIDGET_STATE.HAS_ERROR:
            {
                _view = Container();
                break;
            }

            case WIDGET_STATE.HAS_DATA:
            {
                _view = Container(
                    height: cardHeight,
                    width: cardWidth,
                    padding: EdgeInsets.only(top: 0, bottom: 0, left: 5, right: 5),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      //borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Card(
                        color: active ? _themeAttribute.primaryColor.withOpacity(0.5) : _themeAttribute.secondaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _weatherIcon(widgetDataObject),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      active ? Text("Now",
                                        style: _themeAttribute.textStyle_2 .apply(
                                          fontSizeDelta: 0,
                                          fontWeightDelta: 2,
                                          color: Colors.white
                                        ),
                                      ) : Text(DateTime.parse(widgetDataObject.time).hour.toString()+":00",
                                        style: _themeAttribute.textStyle_2 .apply(
                                          fontSizeDelta: 0,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      active ? Text(widgetDataObject.temperature.amount.toString()+widgetDataObject.temperature.units,
                                        style: _themeAttribute.textStyle_2 .apply(
                                          fontSizeDelta: 0,
                                          color: Colors.white
                                        ),
                                      ) : Text(widgetDataObject.temperature.amount.toString()+widgetDataObject.temperature.units,
                                        style: _themeAttribute.textStyle_2 .apply(
                                          fontSizeDelta: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                        )
                    ),
                );
                break;
            }

            default:
            {
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
    Widget _weatherIcon(WeatherUpdate weatherUpdate) {
      //Variables
      
      switch (weatherUpdate.condition.id) {
        case 1:
          return Image.asset(
            packagePath+"lib/Assets/Images/sun_500x500.png",
            width: 75,
            height: 75,
          );
          break;

        case 2:
          return Image.asset(
            packagePath+"lib/Assets/Images/partly_cloudy_500x500.png",
            width: 75,
            height: 75,
          );
          break;

        case 3:
          return Image.asset(
            packagePath+"lib/Assets/Images/cloud_x3_500x500.png",
            width: 75,
            height: 75,
          );
          break;

        case 4:
          return Image.asset(
            packagePath+"lib/Assets/Images/cloud_x2_rainly_500x500.png",
            width: 75,
            height: 75,
          );
          break;

        case 5:
          return Image.asset(
            packagePath+"lib/Assets/Images/stormy_500x500.png",
            width: 75,
            height: 75,
          );
          break;

        default:
          return Image.asset(
            packagePath+"lib/Assets/Images/cloud_x3_500x500.png",
            width: 75,
            height: 75,
          );
      }

  }

}