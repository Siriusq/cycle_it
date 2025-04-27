import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

//  Neumorphism design

extension Neumorphism on Widget {
  addNeumorphism({
    double borderRadius = 10.0,
    double offset = 5.0,
    double blurRadius = 10,
    Color lightColor = const Color(0xE8FFFFFF),
    Color shadowColor = const Color(0x26234395),
    bool isInset = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        boxShadow: [
          BoxShadow(offset: Offset(offset, offset), blurRadius: blurRadius, color: shadowColor, inset: isInset),
          BoxShadow(offset: Offset(-offset, -offset), blurRadius: blurRadius, color: lightColor, inset: isInset),
        ],
      ),
      child: this,
    );
  }
}
