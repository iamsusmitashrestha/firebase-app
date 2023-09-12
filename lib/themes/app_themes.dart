// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const FONT_FAMILY = "Poppins";
const PRIMARY_COLOR = Color(0xff203341);
const LIGHT_PRIMARY_COLOR = Color.fromARGB(255, 21, 83, 128);

const SECONDARY_COLOR = Color(0XFF3CA2EA);
const ERROR_COLOR = Color(0xFFe10000);
const DARK_GREY = Color(0xFF959595);
const LIGHT_GREY = Color(0xFFdedede);
const CHIP_GREY = Color(0xFFC4C4C4);

abstract class AppThemes {
  static ThemeData light = ThemeData.light().copyWith(
    primaryColor: PRIMARY_COLOR,
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: FONT_FAMILY,
        ),
  );
}
