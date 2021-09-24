import 'dart:ffi';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suspension_setup/cubit/susp_cubit.dart';
import 'package:suspension_setup/db/app_database.dart';
import 'package:suspension_setup/db/susp_entity.dart';
import 'package:suspension_setup/widgets/glass_widget.dart';
import 'package:suspension_setup/widgets/slider_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suspension_setup/widgets/text_with_bold_widget.dart';
import 'db/susp_entity_dao.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  final SuspEntityDao suspDao = database.suspDao;
  SuspEntity? entity = await suspDao.findSuspEntityById(1);
  if (entity == null) {
    entity = SuspEntity.getDefault();
    suspDao.insertSuspEntity(SuspEntity.getDefault());
  }

  runApp(MyApp(suspDao, entity));
}

late bool mUseMobileLayout;
final BorderRadius mBorderRadius = BorderRadius.circular(20.0);
late final SuspEntityDao mSuspDao;
late SuspEntity? mSuspEntity;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.x
  final SuspEntityDao dao;
  final SuspEntity? entity;

  const MyApp(this.dao, this.entity);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Susp.Bro',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        // primarySwatch: Colors.blueGrey,
      ),
      home: BlocProvider<SuspCubit>(
        create: (context) => SuspCubit(dao),
        child: MyHomePage(
          title: 'Susp.Bro',
          dao: dao,
          entity: entity,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final SuspEntityDao dao;
  final SuspEntity? entity;

  MyHomePage(
      {Key? key, required this.title, required this.dao, required this.entity})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late FToast fToast;
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];

  GlobalKey suspensionContainerKey = GlobalKey();
  GlobalKey settingButtonTutorialKey = GlobalKey();

  late AnimationController _forkAnimationController,
      _shockAnimationController,
      _xForkFlipAnimationController,
      _xShockFlipAnimationController;

  Tween<double> _suspTween = Tween(begin: 1.2, end: 1);
  Tween<double> _xFlipTween = Tween(begin: 0, end: 1);

  bool _showForkSetup = false;
  bool _showShockSetup = false;

  Widget? _forkWidgetSwitcher;
  Widget? _shockWidgetSwitcher;

  late final SuspCubit mCubit;

  @override
  void initState() {
    super.initState();
    mCubit = BlocProvider.of<SuspCubit>(context);

    _forkAnimationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _forkAnimationController.repeat(reverse: true);
    _forkAnimationController.addStatusListener((status) {
      if (AnimationStatus.reverse == status) {
        if (!_showForkSetup) _forkAnimationController.reset();
      }
    });

    _shockAnimationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _shockAnimationController.addStatusListener((status) {
      if (AnimationStatus.reverse == status) {
        if (!_showShockSetup) _shockAnimationController.reset();
      }
    });

    _xForkFlipAnimationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    _xShockFlipAnimationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    _forkWidgetSwitcher = SuspensionWidget(
      isFork: true,
      suspDao: widget.dao,
      openDetailPage: _openOrCloseForkSetup,
    );

    _shockWidgetSwitcher = SuspensionWidget(
      isFork: false,
      suspDao: widget.dao,
      openDetailPage: _openOrCloseShockSetup,
    );

    fToast = FToast();
    fToast.init(context);

    if (widget.entity!.showTutorial!)
      Future.delayed(Duration.zero, showTutorial);
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    mUseMobileLayout = shortestSide < 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
            key: settingButtonTutorialKey,
            icon: const Icon(Icons.settings),
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: 1, child: Text("Tutorial")),
              PopupMenuItem<int>(value: 0, child: Text("Add new profile")),
              PopupMenuItem<int>(value: 2, child: Text("UI Setting")),
            ],
            onSelected: (item) {
              switch (item) {
                case 0:
                  _showToast();
                  break;
                case 1:
                  showTutorial(showSettingsTutorial: false);
                  break;
                case 2:
                  _showToast();
                  break;
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            SvgPicture.asset(
              'assets/svg/background_mountains.svg',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            //Svg bike
            Align(
              alignment:
                  mUseMobileLayout ? Alignment.center : Alignment.centerLeft,
              child: SvgBikeWidget(
                forkAnimation: _getForkAnimation(),
                shockAnimation: _getShockAnimation(),
              ),
            ),
            Padding(
              padding: mUseMobileLayout
                  ? EdgeInsets.fromLTRB(0, 40, 0, 40)
                  : EdgeInsets.fromLTRB(150, 0, 150, 0),
              child: Align(
                  alignment: mUseMobileLayout
                      ? Alignment.center
                      : Alignment.centerRight,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: mUseMobileLayout
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                      children: [
                        ScalesAndFlipWidget(
                          key: suspensionContainerKey,
                          xFlipTween: _xFlipTween,
                          xSuspensionFlipAnimationController:
                              _xForkFlipAnimationController,
                          isFork: true,
                          child: BlocBuilder<SuspCubit, SuspState>(
                            builder: (context, state) {
                              if (state is SuspInitial) {
                                mCubit.getSuspFromDB(1);
                                return CircularProgressIndicator();
                              } else if (state is SuspLoading) {
                                return CircularProgressIndicator();
                              } else if (state is SuspLoaded) {
                                mSuspEntity = state.suspEntity;
                                return _forkWidgetSwitcher!;
                              }
                              return CircularProgressIndicator();
                            },
                          ),
                        ),
                        SizedBox(
                          height: 200,
                        ),
                        ScalesAndFlipWidget(
                          xFlipTween: _xFlipTween,
                          xSuspensionFlipAnimationController:
                              _xShockFlipAnimationController,
                          isFork: false,
                          child: BlocBuilder<SuspCubit, SuspState>(
                            builder: (context, state) {
                              if (state is SuspInitial) {
                                return CircularProgressIndicator();
                              } else if (state is SuspLoading) {
                                return CircularProgressIndicator();
                              } else if (state is SuspLoaded) {
                                mSuspEntity = state.suspEntity;
                                return _shockWidgetSwitcher!;
                              } else
                                return CircularProgressIndicator();
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("This feature will be available later"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 3),
    );
  }

  void showTutorial({bool showSettingsTutorial = true}) {
    initTargets(showSettingsTutorial);
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.grey.shade700,
      paddingFocus: 5.0,
      opacityShadow: 0.8,
      hideSkip: true,
      onClickTarget: (target) {
        if (target.identify == 'suspensionContainerKey1')
          _openOrCloseForkSetup(SuspEnum.HSR);
        else if (target.identify == 'suspensionContainerKey2')
          _openOrCloseForkSetup(SuspEnum.HSR);
      },
    )..show();
  }

  void initTargets(bool showSettingsTutorial) {
    targets.clear();
    if (showSettingsTutorial)
      targets.add(TargetFocus(
          identify: "settingButtonTutorialKey",
          keyTarget: settingButtonTutorialKey,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 100),
                      Container(
                        child: Text(
                          "Here you can find UI settings and additional suspension help to adjust your suspension",
                          style: TextStyle(color: Colors.white),
                        ),
                        height: 100,
                      ),
                      TextButton(
                        child: Text(
                          "Got It",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        onPressed: () {
                          tutorialCoachMark.next();
                        },
                      ),
                    ],
                  ),
                );
              },
            )
          ]));

    targets.add(TargetFocus(
        identify: "suspensionContainerKey1",
        keyTarget: suspensionContainerKey,
        alignSkip: Alignment.center,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 80),
                    Text(
                      "Notations",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWithBoldWidget(
                          textBold: 'HSR',
                          text: '- High Speed Rebound',
                          boldFirst: true,
                        ),
                        SizedBox(height: 2),
                        TextWithBoldWidget(
                          textBold: 'LSR',
                          text: '- Low Speed Rebound',
                          boldFirst: true,
                        ),
                        SizedBox(height: 2),
                        TextWithBoldWidget(
                          textBold: 'HSC',
                          text: '- High Speed Compression',
                          boldFirst: true,
                        ),
                        SizedBox(height: 2),
                        TextWithBoldWidget(
                          textBold: 'LSC',
                          text: '- Low Speed Compression',
                          boldFirst: true,
                        ),
                        SizedBox(height: 2),
                        TextWithBoldWidget(
                          textBold: 'PSI',
                          text: '- A measurement for an air sprung',
                          boldFirst: true,
                        ),
                        SizedBox(height: 2),
                        TextWithBoldWidget(
                          textBold: 'LBS',
                          text: '- A measurement for a coil sprung',
                          boldFirst: true,
                        ),
                        SizedBox(height: 2),
                        TextWithBoldWidget(
                          textBold: 'Tokens',
                          text: '- Volume spacers in an air chamber',
                          boldFirst: true,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    TextButton(
                      child: Text(
                        "Got It",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      onPressed: () {
                        tutorialCoachMark.next();
                        _openOrCloseForkSetup(SuspEnum.HSR);
                      },
                    ),
                  ],
                ),
              );
            },
          )
        ]));

    targets.add(TargetFocus(
        identify: "suspensionContainerKey2",
        keyTarget: suspensionContainerKey,
        alignSkip: Alignment.center,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              var shortestSide = MediaQuery.of(context).size.shortestSide;
              double widthOfScreen = MediaQuery.of(context).size.width;
              mUseMobileLayout = shortestSide < 600;

              return Container(
                width: widthOfScreen / 3,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 80),
                    Text(
                      "Compression/Rebound adjustment",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Companies, such as RockShox and Fox, use the concept shown in the picture:",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: mUseMobileLayout ? widthOfScreen : widthOfScreen / 2.5,
                          child: Image.asset('assets/img/susp_adjustments.png'),
                        ),
                        Text(
                          "*Taken from the official website www.ridefox.com",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      child: Text(
                        "Got It",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      onPressed: () {
                        widget.entity!.showTutorial = false;
                        widget.dao.updateSuspEntity(widget.entity!);
                        tutorialCoachMark.next();
                        _openOrCloseForkSetup(SuspEnum.MAIN);
                      },
                    ),
                  ],
                ),
              );
            },
          )
        ]));
  }

  Animation<double> _getForkAnimation() {
    return _suspTween.animate(CurvedAnimation(
        parent: _forkAnimationController, curve: Curves.easeInOutQuad));
  }

  Animation<double> _getShockAnimation() {
    return _suspTween.animate(CurvedAnimation(
        parent: _shockAnimationController, curve: Curves.easeInOutQuad));
  }

  void _openOrCloseForkSetup(SuspEnum suspType) {
    setState(() {
      if (_showShockSetup) {
        _showShockSetup = false;
        _shockWidgetSwitcher = SuspensionWidget(
          isFork: false,
          suspDao: widget.dao,
          openDetailPage: _openOrCloseShockSetup,
        );
        _xShockFlipAnimationController.reverse();
      }

      if (!_showForkSetup) {
        _forkWidgetSwitcher = KnobWidget(
          closeCallback: _openOrCloseForkSetup,
          isFork: true,
          suspType: suspType,
          suspDao: widget.dao,
        );
        _forkAnimationController.repeat(reverse: true);
        _xForkFlipAnimationController.forward();
      } else {
        _forkWidgetSwitcher = SuspensionWidget(
            isFork: true,
            suspDao: widget.dao,
            openDetailPage: _openOrCloseForkSetup);
        _xForkFlipAnimationController.reverse();
      }

      _showForkSetup = !_showForkSetup;
    });

    mCubit.getSuspFromDBNoLoading(1);
  }

  void _openOrCloseShockSetup(SuspEnum suspType) {
    setState(() {
      if (_showForkSetup) {
        _showForkSetup = false;
        _forkWidgetSwitcher = SuspensionWidget(
          isFork: true,
          suspDao: widget.dao,
          openDetailPage: _openOrCloseForkSetup,
        );
        _xForkFlipAnimationController.reverse();
      }

      if (!_showShockSetup) {
        _shockWidgetSwitcher = KnobWidget(
          closeCallback: _openOrCloseShockSetup,
          isFork: false,
          suspType: suspType,
          suspDao: widget.dao,
        );
        _shockAnimationController.repeat(reverse: true);
        _xShockFlipAnimationController.forward();
      } else {
        _shockWidgetSwitcher = SuspensionWidget(
          isFork: false,
          suspDao: widget.dao,
          openDetailPage: _openOrCloseShockSetup,
        );
        _xShockFlipAnimationController.reverse();
      }

      _showShockSetup = !_showShockSetup;
    });

    mCubit.getSuspFromDBNoLoading(1);
  }

  @override
  void dispose() {
    _forkAnimationController.dispose();
    _shockAnimationController.dispose();
    _xForkFlipAnimationController.dispose();
    _xShockFlipAnimationController.dispose();

    super.dispose();
  }
}

class ScalesAndFlipWidget extends StatelessWidget {
  const ScalesAndFlipWidget({
    Key? key,
    required Tween<double> xFlipTween,
    required AnimationController xSuspensionFlipAnimationController,
    required Widget? child,
    required bool isFork,
  })  : _xFlipTween = xFlipTween,
        _xSuspensionFlipAnimationController =
            xSuspensionFlipAnimationController,
        _child = child,
        _isFork = isFork,
        super(key: key);

  final Tween<double> _xFlipTween;
  final AnimationController _xSuspensionFlipAnimationController;
  final Widget? _child;
  final bool _isFork;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _xFlipTween.animate(_xSuspensionFlipAnimationController),
      builder: (_, child) {
        return Transform(
          alignment: mUseMobileLayout
              ? FractionalOffset.topCenter
              : Alignment(0.25, 0),
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateY(2 * pi * _xSuspensionFlipAnimationController.value),
          child: child,
        );
      },
      child: GlassEffectWidget(
        isFork: _isFork,
        borderRadius: mBorderRadius,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: _child,
        ),
      ),
    );
  }
}

class SuspensionWidget extends StatelessWidget {
  SuspensionWidget({
    Key? key,
    required bool isFork,
    required SuspEntityDao suspDao,
    required void Function(SuspEnum) openDetailPage,
  })  : _isFork = isFork,
        _suspDao = suspDao,
        _openDetailPage = openDetailPage,
        super(key: key);

  final bool _isFork;
  final SuspEntityDao _suspDao;
  final void Function(SuspEnum) _openDetailPage;

  final ButtonStyle style = ElevatedButton.styleFrom(
      primary: Colors.red,
      fixedSize: Size(120, 10),
      textStyle: const TextStyle(fontSize: 15));

  final _psiController = TextEditingController();
  final _tokensController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String hsrLabel = _isFork
        ? "${mSuspEntity!.forkHSRebound}/${mSuspEntity!.forkHSRebMaxClick}"
        : "${mSuspEntity!.shockHSRebound}/${mSuspEntity!.shockHSRebMaxClick}";

    String hscLabel = _isFork
        ? "${mSuspEntity!.forkHSComp}/${mSuspEntity!.forkHSCompMaxClick}"
        : "${mSuspEntity!.shockHSComp}/${mSuspEntity!.shockHSCompMaxClick}";

    String lsrLabel = _isFork
        ? "${mSuspEntity!.forkLSReb}/${mSuspEntity!.forkLSRebMaxClick}"
        : "${mSuspEntity!.shockLSReb}/${mSuspEntity!.shockLSRebMaxClick}";

    String lscLabel = _isFork
        ? "${mSuspEntity!.forkLSComp}/${mSuspEntity!.forkLSCompMaxClick}"
        : "${mSuspEntity!.shockLSComp}/${mSuspEntity!.shockLSCompMaxClick}";

    _psiController.text =
        _isFork ? "${mSuspEntity!.forkPsi}" : "${mSuspEntity!.shockPsi}";
    _tokensController.text =
        _isFork ? "${mSuspEntity!.forkTokens}" : "${mSuspEntity!.shockTokens}";

    _psiController.addListener(() async {
      if (_isFork) {
        if (mSuspEntity!.forkPsi != int.parse(_psiController.text)) {
          mSuspEntity!.forkPsi = int.parse(_psiController.text);
          await _suspDao.updateSuspEntity(mSuspEntity!);
        }
      } else {
        if (mSuspEntity!.shockPsi != int.parse(_psiController.text)) {
          mSuspEntity!.shockPsi = int.parse(_psiController.text);
          await _suspDao.updateSuspEntity(mSuspEntity!);
        }
      }
    });

    _tokensController.addListener(() async {
      if (_isFork) {
        if (mSuspEntity!.forkTokens != int.parse(_tokensController.text)) {
          mSuspEntity!.forkTokens = int.parse(_tokensController.text);
          await _suspDao.updateSuspEntity(mSuspEntity!);
        }
      } else {
        if (mSuspEntity!.shockTokens != int.parse(_tokensController.text)) {
          mSuspEntity!.shockTokens = int.parse(_tokensController.text);
          await _suspDao.updateSuspEntity(mSuspEntity!);
        }
      }
    });

    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                      style: style.copyWith(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.redAccent)),
                      onPressed: () {
                        _openDetailPage(SuspEnum.HSR);
                      },
                      child: TextWithBoldWidget(
                        text: 'HSR',
                        textBold: hsrLabel,
                        boldFirst: false,
                      )),
                ),
                Container(
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                      style: style.copyWith(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blueAccent)),
                      onPressed: () {
                        _openDetailPage(SuspEnum.HSC);
                      },
                      child: TextWithBoldWidget(
                          text: 'HSC', textBold: hscLabel, boldFirst: false)),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                      style: style.copyWith(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.redAccent)),
                      onPressed: () {
                        _openDetailPage(SuspEnum.LSR);
                      },
                      child: TextWithBoldWidget(
                          text: 'LSR', textBold: lsrLabel, boldFirst: false)),
                ),
                Container(
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                      style: style.copyWith(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blueAccent)),
                      onPressed: () {
                        _openDetailPage(SuspEnum.LSC);
                      },
                      child: TextWithBoldWidget(
                          text: 'LSC', textBold: lscLabel, boldFirst: false)),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  width: 120,
                  child: TextFormField(
                    enableInteractiveSelection: false,
                    controller: _psiController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'PSI/LBS',
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: 120,
                  child: TextFormField(
                    enableInteractiveSelection: false,
                    controller: _tokensController,
                    textAlignVertical: TextAlignVertical.top,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    style: TextStyle(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tokens',
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class KnobWidget extends StatefulWidget {
  final void Function(SuspEnum s) closeCallback;
  final bool isFork;
  final suspType;
  final SuspEntityDao suspDao;

  KnobWidget({
    Key? key,
    required this.closeCallback,
    required this.isFork,
    required this.suspType,
    required this.suspDao,
  }) : super(key: key);

  @override
  KnobWidgetState createState() => KnobWidgetState();
}

class KnobWidgetState extends State<KnobWidget> {
  int? _maxClicks = 10;
  int? _clicks = 10;
  String title = "";
  final maxClickController = TextEditingController();

  void setMaxClicks(String text) async {
    int maxClicks = int.parse(text);

    switch (widget.suspType) {
      case SuspEnum.HSR:
        if (widget.isFork) {
          if (mSuspEntity!.forkHSRebMaxClick != maxClicks) {
            mSuspEntity!.forkHSRebMaxClick = maxClicks;
            await widget.suspDao.updateSuspEntity(mSuspEntity!);
          }
        } else {
          if (mSuspEntity!.shockHSRebMaxClick != maxClicks) {
            mSuspEntity!.shockHSRebMaxClick = maxClicks;
            await widget.suspDao.updateSuspEntity(mSuspEntity!);
          }
        }
        break;
      case SuspEnum.LSR:
        if (widget.isFork) {
          if (mSuspEntity!.forkLSRebMaxClick != maxClicks) {
            mSuspEntity!.forkLSRebMaxClick = maxClicks;
            await widget.suspDao.updateSuspEntity(mSuspEntity!);
          }
        } else {
          if (mSuspEntity!.shockLSRebMaxClick != maxClicks) {
            mSuspEntity!.shockLSRebMaxClick = maxClicks;
            await widget.suspDao.updateSuspEntity(mSuspEntity!);
          }
        }
        break;
      case SuspEnum.HSC:
        if (widget.isFork) {
          if (mSuspEntity!.forkHSCompMaxClick != maxClicks) {
            mSuspEntity!.forkHSCompMaxClick = maxClicks;
            await widget.suspDao.updateSuspEntity(mSuspEntity!);
          }
        } else {
          if (mSuspEntity!.shockHSCompMaxClick != maxClicks) {
            mSuspEntity!.shockHSCompMaxClick = maxClicks;
            await widget.suspDao.updateSuspEntity(mSuspEntity!);
          }
        }
        break;
      case SuspEnum.LSC:
        if (widget.isFork) {
          if (mSuspEntity!.forkLSCompMaxClick != maxClicks) {
            mSuspEntity!.forkLSCompMaxClick = maxClicks;
            await widget.suspDao.updateSuspEntity(mSuspEntity!);
          }
        } else {
          if (mSuspEntity!.shockLSCompMaxClick != maxClicks) {
            mSuspEntity!.shockLSCompMaxClick = maxClicks;
            await widget.suspDao.updateSuspEntity(mSuspEntity!);
          }
        }
        break;
    }

    setState(() {
      _maxClicks = maxClicks;
    });
  }

  int? getMaxClicks() {
    int? maxClicks = 5; //Default value
    switch (widget.suspType) {
      case SuspEnum.HSR:
        title = "High Speed Rebound";
        if (widget.isFork) {
          maxClicks = mSuspEntity!.forkHSRebMaxClick;
          _clicks = mSuspEntity!.forkHSRebound;
        } else {
          maxClicks = mSuspEntity!.shockHSRebMaxClick;
          _clicks = mSuspEntity!.shockHSRebound;
        }
        break;
      case SuspEnum.LSR:
        title = "Low Speed Rebound";
        if (widget.isFork) {
          maxClicks = mSuspEntity!.forkLSRebMaxClick;
          _clicks = mSuspEntity!.forkLSReb;
        } else {
          maxClicks = mSuspEntity!.shockLSRebMaxClick;
          _clicks = mSuspEntity!.shockLSReb;
        }
        break;
      case SuspEnum.HSC:
        title = "High Speed Compression";
        if (widget.isFork) {
          maxClicks = mSuspEntity!.forkHSCompMaxClick;
          _clicks = mSuspEntity!.forkHSComp;
        } else {
          maxClicks = mSuspEntity!.shockHSCompMaxClick;
          _clicks = mSuspEntity!.shockHSComp;
        }
        break;
      case SuspEnum.LSC:
        title = "Low Speed Compression";
        if (widget.isFork) {
          maxClicks = mSuspEntity!.forkLSCompMaxClick;
          _clicks = mSuspEntity!.forkLSComp;
        } else {
          maxClicks = mSuspEntity!.shockLSCompMaxClick;
          _clicks = mSuspEntity!.shockLSComp;
        }
        break;
    }

    return maxClicks;
  }

  @override
  Widget build(BuildContext context) {
    _maxClicks = getMaxClicks();
    maxClickController.text = _maxClicks.toString();

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: SliderWidget(
                suspDao: widget.suspDao,
                mSuspEntity: mSuspEntity,
                isFork: widget.isFork,
                suspType: widget.suspType,
                clicks: _clicks!,
                max: _maxClicks!,
              ),
            ),
            Container(
              height: 40,
              width: 130,
              child: TextFormField(
                enableInteractiveSelection: false,
                controller: maxClickController,
                onChanged: (text) {
                  setMaxClicks(text);
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Set Max clicks',
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
              onPressed: () {
                widget.closeCallback(SuspEnum.MAIN);
              },
              icon: Icon(
                Icons.close,
                color: Colors.redAccent,
              )),
        ),
      ],
    );
  }
}

class SvgBikeWidget extends StatelessWidget {
  const SvgBikeWidget({
    Key? key,
    required Animation<double> forkAnimation,
    required Animation<double> shockAnimation,
  })  : _forkAnimation = forkAnimation,
        _shockAnimation = shockAnimation,
        super(key: key);

  final Animation<double> _forkAnimation;
  final Animation<double> _shockAnimation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          'assets/svg/bike.svg',
        ),
        ScaleTransition(
            scale: _forkAnimation,
            child: SvgPicture.asset('assets/svg/fork.svg')),
        ScaleTransition(
          scale: _shockAnimation,
          child: SvgPicture.asset('assets/svg/shock.svg'),
        ),
      ],
    );
  }
}
