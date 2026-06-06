import 'package:flutter/material.dart';

abstract final class TockingColors {
  static const Color canvas = Color(0xFFFFFFFF);
  static const Color searchFill = Color(0xFFF4F4F5);
  static const Color searchBorder = Color(0xFFE9E9EC);
  static const Color searchIcon = Color(0xFF9B9BA1);
  static const Color searchText = Color(0xFF6E6E73);
}

abstract final class TockingSpacing {
  static const double appFrameWidth = 720;
  static const double appFrameHeight = 828;
  static const double appBarPadding = 12;
  static const double searchGap = 14;
}

abstract final class TockingSizes {
  static const Size logo = Size(166.5, 36);
  static const double searchIcon = 36;
  static const double searchHeight = 36;
  static const double searchMaxWidth = 276;
}

abstract final class TockingRadii {
  static const double search = 18;
}
