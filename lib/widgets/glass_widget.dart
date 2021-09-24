import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class GlassEffectWidget extends StatelessWidget {
  const GlassEffectWidget({
    Key? key,
    required this.isFork,
    required this.child,
    required this.borderRadius,
  }) : super(key: key);

  final Widget child;
  final bool isFork;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final double height = 180;
    final double width = 320;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: borderRadius,
          child: Container(
            height: height,
            width: width,
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                  child: Container(
                    height: height,
                    child: Text(" "),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.15), blurRadius: 30)
                    ],
                    border: Border.all(
                        color: Colors.white.withOpacity(0.2), width: 1.0),
                    borderRadius: borderRadius,
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.5),
                          Colors.white.withOpacity(0.2),
                        ]),
                  ),
                  height: height,
                  width: double.infinity,
                  child: child,
                ),
              ],
            ),
          ),
        ),
        Transform(
          transform: Matrix4.rotationZ(-pi/4),
          alignment: isFork ? Alignment(-1.2,2.2) : Alignment(-1,2.5),
          child: Text(
            isFork ? "Fork" : "Shock",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ],
    );
  }
}
