import 'package:flutter/material.dart';

var C = Colours(
  purple: const Color(0xFF9876AA),
  teal: const Color(0xFF32a4a0),
  gold: const Color(0xFFffc66d),
  orange: const Color(0xFFcc7832),
  lightGray: const Color(0xFFEEEEEE),
  medGray: const Color(0xFFCCCCCC),
  darkGray: const Color(0xFF999999),
);

class Colours {
  final Color purple;
  final Color teal;
  final Color gold;
  final Color orange;
  final Color lightGray;
  final Color medGray;
  final Color darkGray;

  Colours({
    required this.purple,
    required this.teal,
    required this.gold,
    required this.orange,
    required this.lightGray,
    required this.medGray,
    required this.darkGray,
  });
}
