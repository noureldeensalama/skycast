import 'package:flutter/material.dart';

import '../Models/ThemeAttribute.dart';

enum AppBarMode {
  menu,
  back,
}

// ignore: must_be_immutable
class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBarMode _appBarMode;
  final double _elevation;
  Color backgroundColor;
  ThemeAttribute _themeAttribute = ThemeAttribute();

  MainAppBar({
    final AppBarMode appBarMode = AppBarMode.menu,
    // final elevation: 0.0,
    this.backgroundColor = Colors.white})
      : this._appBarMode = appBarMode,
        this._elevation = 0;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: _elevation,
      backgroundColor: backgroundColor,
      title: GestureDetector(
        onTap: (){},
        child: _appBarMode == AppBarMode.menu ? Container() : Container(
          child: Text(
            "7 Day Forecast",
            style: _themeAttribute.textStyle_1 .apply(
              fontWeightDelta: 900,
            ),
          ),
        ),
      ),
      leading: _appBarMode == AppBarMode.menu
          ? GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: const RotatedBox(
                  quarterTurns: 4,
                  child: Icon(
                      Icons.sort,
                      size: 30,
                      color: Colors.white,
                  ),
              ),
            )
          : _appBarMode == AppBarMode.back
              ? GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    color: Colors.transparent,
                    child:  Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                       border: Border.all(
                        color: Colors.white,
                        width: 2
                       ),
                       borderRadius: BorderRadius.circular(30)
                      ),
                      child: const  Icon(
                        Icons.keyboard_arrow_left_outlined,
                        color: Colors.white,
                        size: 25.0,
                      ),
                    )
                  ),
                )
              : null,
      actions: const [
        /*if (_appBarMode == AppBarMode.menu)
          GestureDetector(
            onTap: () => (){},
            child: Icon(
              Icons.exit_to_app,
              size: 36.0,
              color: Colors.black
            ),
          )*/
      ],
    );
  }
}
