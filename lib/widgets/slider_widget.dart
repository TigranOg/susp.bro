import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:suspension_setup/db/susp_entity.dart';
import 'package:suspension_setup/db/susp_entity_dao.dart';

class SliderWidget extends StatefulWidget {
  final int clicks;
  final double sliderHeight;
  final int min;
  final int max;
  final SuspEntityDao suspDao;
  final SuspEntity? mSuspEntity;
  final bool isFork;
  final suspType;

  SliderWidget(
      {required this.suspDao,
      required this.mSuspEntity,
      required this.isFork,
      required this.suspType,
      required this.clicks,
      this.sliderHeight = 48,
      this.max = 10,
      this.min = 0});

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  late double _value;
  late bool _isRebound;

  void setValue(int value) async {
    print("2 - save value $value");
    // int revertedValue = widget.max - value;
    // print("3 - revertedValue $revertedValue");
    // value = revertedValue;

    switch (widget.suspType) {
      case SuspEnum.HSR:
        if (widget.isFork) {
          if (widget.mSuspEntity!.forkHSRebound != value) {
            widget.mSuspEntity!.forkHSRebound = value;
            await widget.suspDao.updateSuspEntity(widget.mSuspEntity!);
          }
        } else {
          if (widget.mSuspEntity!.shockHSRebound != value) {
            widget.mSuspEntity!.shockHSRebound = value;
            await widget.suspDao.updateSuspEntity(widget.mSuspEntity!);
          }
        }
        break;
      case SuspEnum.LSR:
        if (widget.isFork) {
          if (widget.mSuspEntity!.forkLSReb != value) {
            widget.mSuspEntity!.forkLSReb = value;
            await widget.suspDao.updateSuspEntity(widget.mSuspEntity!);
          }
        } else {
          if (widget.mSuspEntity!.shockLSReb != value) {
            widget.mSuspEntity!.shockLSReb = value;
            await widget.suspDao.updateSuspEntity(widget.mSuspEntity!);
          }
        }
        break;
      case SuspEnum.HSC:
        if (widget.isFork) {
          if (widget.mSuspEntity!.forkHSComp != value) {
            widget.mSuspEntity!.forkHSComp = value;
            await widget.suspDao.updateSuspEntity(widget.mSuspEntity!);
          }
        } else {
          if (widget.mSuspEntity!.shockHSComp != value) {
            widget.mSuspEntity!.shockHSComp = value;
            await widget.suspDao.updateSuspEntity(widget.mSuspEntity!);
          }
        }
        break;
      case SuspEnum.LSC:
        if (widget.isFork) {
          if (widget.mSuspEntity!.forkLSComp != value) {
            widget.mSuspEntity!.forkLSComp = value;
            await widget.suspDao.updateSuspEntity(widget.mSuspEntity!);
          }
        } else {
          if (widget.mSuspEntity!.shockLSComp != value) {
            widget.mSuspEntity!.shockLSComp = value;
            await widget.suspDao.updateSuspEntity(widget.mSuspEntity!);
          }
        }
        break;
    }
  }

  double setInitialValue() {
    double testValue = (widget.clicks - widget.min) / (widget.max - widget.min);
    print("1 - init value $testValue");
    return 1.0 - testValue;
  }

  @override
  void initState() {
    super.initState();

    switch (widget.suspType) {
      case SuspEnum.HSR:
        _isRebound = true;
        break;
      case SuspEnum.LSR:
        _isRebound = true;
        break;
      case SuspEnum.HSC:
        _isRebound = false;
        break;
      case SuspEnum.LSC:
        _isRebound = false;
        break;
    }

    _value = setInitialValue();
  }

  @override
  Widget build(BuildContext context) {
    print("build - value $_value");

    return Container(
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Text(
                '${this.widget.max}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: this.widget.sliderHeight * .3,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    // activeTrackColor: Colors.white.withOpacity(1),
                    // inactiveTrackColor: Colors.white.withOpacity(.5),
                    trackHeight: 10.0,
                    thumbShape: CustomSliderThumbCircle(
                      thumbRadius: this.widget.sliderHeight * .4,
                      min: this.widget.min,
                      max: this.widget.max,
                    ),
                    overlayColor: Colors.white.withOpacity(.4),
                    //valueIndicatorColor: Colors.white,
                    activeTickMarkColor: Colors.white,
                    inactiveTickMarkColor:
                        _isRebound ? Colors.redAccent : Colors.blueAccent,
                  ),
                  child: Slider(
                      value: _value,
                      divisions: this.widget.max,
                      onChanged: (value) {
                        setState(() {
                          int realValue =
                              (widget.min + (widget.max - widget.min) * value)
                                  .round();
                          _value = value;
                          int revertedValue = widget.max - realValue;
                          setValue(revertedValue);
                        });
                      }),
                ),
              ),
              Text(
                '${this.widget.min}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: this.widget.sliderHeight * .3,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: _isRebound ? EdgeInsets.fromLTRB(25, 0, 25, 0) : EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_isRebound)
                  SvgPicture.asset(
                    'assets/svg/bunny_rebound.svg',
                    height: 20,
                  )
                else
                  Text("Opened", style: TextStyle(fontWeight: FontWeight.bold),),
                if (_isRebound)
                  SvgPicture.asset(
                    'assets/svg/turtle_rebound.svg',
                    height: 15,
                  )
                else
                  Text("Closed/Firm", style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSliderThumbRect extends SliderComponentShape {
  final double thumbRadius;
  final thumbHeight;
  final int min;
  final int max;

  const CustomSliderThumbRect({
    required this.thumbRadius,
    this.thumbHeight,
    required this.min,
    required this.max,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: center, width: thumbHeight * 1.2, height: thumbHeight * .6),
      Radius.circular(thumbRadius * .4),
    );

    final paint = Paint()
      ..color = sliderTheme.activeTrackColor! //Thumb Background Color
      ..style = PaintingStyle.fill;

    TextSpan span = new TextSpan(
        style: new TextStyle(
            fontSize: thumbHeight * .3,
            fontWeight: FontWeight.w700,
            color: sliderTheme.thumbColor,
            height: 1),
        text: '${getValue(value)}');
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
        Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawRRect(rRect, paint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    // return (min + (max - min) * value).round().toString();
    int val = (min + (max - min) * value).round();
    int invertedVal = max - val;
    return invertedVal.toString();
  }
}

class CustomSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final int min;
  final int max;

  const CustomSliderThumbCircle({
    required this.thumbRadius,
    this.min = 0,
    this.max = 10,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = Colors.white //Thumb Background Color
      ..style = PaintingStyle.fill;

    TextSpan span = new TextSpan(
      style: new TextStyle(
        fontSize: thumbRadius * .8,
        fontWeight: FontWeight.w700,
        color: sliderTheme.thumbColor, //Text Color of Value on Thumb
      ),
      text: getValue(value),
    );

    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
        Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawCircle(center, thumbRadius * .9, paint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    // return (min + (max - min) * value).round().toString();
    int val = (min + (max - min) * value).round();
    int invertedVal = max - val;
    return invertedVal.toString();
  }
}
