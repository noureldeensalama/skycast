import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ThemeAttribute{

    //Colors
    final Color _primaryColor = HexColor('#FF9800');
    // final Color _primaryColor = const Color.fromARGB(255, 4, 22, 78); //hex: #01164D
    final Color _secondaryColor = HexColor('#00796B');

    //Text Styles
    TextStyle _textStyle_1 = TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold
    );

    TextStyle _textStyle_2 = TextStyle(
        color: Colors.grey[200],
        fontSize: 17,
        fontWeight: FontWeight.normal
    );

    ThemeAttribute();

    Color get primaryColor{
        return _primaryColor;
    }

    Color get secondaryColor{
        return _secondaryColor;
    }

    //Standard small black text
    TextStyle get textStyle_1{
        return _textStyle_1;
    }

    //Standard Page header Large text
    TextStyle get textStyle_2{
        return _textStyle_2;
    }
}