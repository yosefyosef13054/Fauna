import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class ZoomScaffold extends StatefulWidget {
  final Widget menuScreen;
  final Layout contentScreen;

  ZoomScaffold({
    this.menuScreen,
    this.contentScreen,
  });

  @override
  _ZoomScaffoldState createState() => new _ZoomScaffoldState();
}

class _ZoomScaffoldState extends State<ZoomScaffold>
    with TickerProviderStateMixin {
  Curve scaleDownCurve = new Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve scaleUpCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideOutCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideInCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  int _currentSelected = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentSelected = index;
    });
  }

  createContentDisplay() {
    return zoomAndSlideContent(new Container(
      child: new Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: new AppBar(
        //   backgroundColor:
        //       _currentSelected == 0 ? Color(0xff9C27B0) : Colors.transparent,
        //   elevation: 0.0,
        //   leading: new IconButton(
        //       icon: Icon(
        //         Icons.menu,
        //         color: Colors.black,
        //       ),
        //       onPressed: () {
        //         Provider.of<MenuController>(context, listen: false).toggle();
        //       }),
        // ),
        body: widget.contentScreen.contentBuilder(context),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentSelected,
          onTap: _onItemTapped,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          items: [
            BottomNavigationBarItem(
              title: _currentSelected == 0
                  ? ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (Rect bounds) {
                        return ui.Gradient.linear(
                          Offset(4.0, 24.0),
                          Offset(24.0, 4.0),
                          [Color(0xFFFF3D00), Color(0xFF9C27B0)],
                        );
                      },
                      child: Text(
                        'Explore',
                        style: TextStyle(fontSize: 10),
                      ),
                    )
                  : Text(
                      'Explore',
                      style: TextStyle(fontSize: 10),
                    ),
              icon: _currentSelected == 0
                  ? ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (Rect bounds) {
                        return ui.Gradient.linear(
                          Offset(4.0, 24.0),
                          Offset(24.0, 4.0),
                          [Color(0xFFFF3D00), Color(0xFF9C27B0)],
                        );
                      },
                      child: Image.asset(
                        "assets/explore.webp",
                        width: 25,
                        height: 25,
                      ),
                    )
                  : Image.asset(
                      "assets/explore.webp",
                      width: 25,
                      height: 25,
                    ),
            ),
            BottomNavigationBarItem(
              title: _currentSelected == 1
                  ? ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (Rect bounds) {
                        return ui.Gradient.linear(
                          Offset(4.0, 24.0),
                          Offset(24.0, 4.0),
                          [Color(0xFFFF3D00), Color(0xFF9C27B0)],
                        );
                      },
                      child: Text(
                        'Chats',
                        style: TextStyle(fontSize: 10),
                      ),
                    )
                  : Text(
                      'Chats',
                      style: TextStyle(fontSize: 10),
                    ),
              icon: _currentSelected == 1
                  ? ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (Rect bounds) {
                        return ui.Gradient.linear(
                          Offset(4.0, 24.0),
                          Offset(24.0, 4.0),
                          [Color(0xFFFF3D00), Color(0xFF9C27B0)],
                        );
                      },
                      child: Image.asset(
                        "assets/chats.webp",
                        width: 25,
                        height: 25,
                      ),
                    )
                  : Image.asset(
                      "assets/chats.webp",
                      width: 25,
                      height: 25,
                    ),
            ),
            BottomNavigationBarItem(
                title: _currentSelected == 2
                    ? ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds) {
                          return ui.Gradient.linear(
                            Offset(4.0, 24.0),
                            Offset(24.0, 4.0),
                            [Color(0xFFFF3D00), Color(0xFF9C27B0)],
                          );
                        },
                        child: Text(
                          'Become Breeder',
                          style: TextStyle(fontSize: 10),
                        ))
                    : Text(
                        'Become Breeder',
                        style: TextStyle(fontSize: 10),
                      ),
                icon: _currentSelected == 2
                    ? ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds) {
                          return ui.Gradient.linear(
                            Offset(4.0, 24.0),
                            Offset(24.0, 4.0),
                            [Color(0xFFFF3D00), Color(0xFF9C27B0)],
                          );
                        },
                        child: Image.asset(
                          "assets/breeder.webp",
                          width: 25,
                          height: 25,
                        ))
                    : Image.asset(
                        "assets/breeder.webp",
                        width: 25,
                        height: 25,
                      )),
            BottomNavigationBarItem(
                title: _currentSelected == 3
                    ? ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds) {
                          return ui.Gradient.linear(
                            Offset(4.0, 24.0),
                            Offset(24.0, 4.0),
                            [Color(0xFFFF3D00), Color(0xFF9C27B0)],
                          );
                        },
                        child: Text(
                          'Favorite',
                          style: TextStyle(fontSize: 10),
                        ))
                    : Text(
                        'Favorite',
                        style: TextStyle(fontSize: 10),
                      ),
                icon: _currentSelected == 3
                    ? ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds) {
                          return ui.Gradient.linear(
                            Offset(4.0, 24.0),
                            Offset(24.0, 4.0),
                            [Color(0xFFFF3D00), Color(0xFF9C27B0)],
                          );
                        },
                        child: Image.asset(
                          "assets/favorites.webp",
                          width: 25,
                          height: 25,
                        ))
                    : Image.asset(
                        "assets/favorites.webp",
                        width: 25,
                        height: 25,
                      )),
            BottomNavigationBarItem(
                title: _currentSelected == 4
                    ? ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds) {
                          return ui.Gradient.linear(
                            Offset(4.0, 24.0),
                            Offset(24.0, 4.0),
                            [Color(0xFFFF3D00), Color(0xFF9C27B0)],
                          );
                        },
                        child: Text(
                          'Profile',
                          style: TextStyle(fontSize: 10),
                        ))
                    : Text(
                        'Profile',
                        style: TextStyle(fontSize: 10),
                      ),
                icon: _currentSelected == 4
                    ? ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds) {
                          return ui.Gradient.linear(
                            Offset(4.0, 24.0),
                            Offset(24.0, 4.0),
                            [Color(0xFFFF3D00), Color(0xFF9C27B0)],
                          );
                        },
                        child: Image.asset(
                          "assets/profile.webp",
                          width: 25,
                          height: 25,
                        ))
                    : Image.asset(
                        "assets/profile.webp",
                        width: 25,
                        height: 25,
                      )),
          ],
        ),
      ),
    ));
  }

  zoomAndSlideContent(Widget content) {
    var slidePercent, scalePercent;

    switch (Provider.of<MenuController>(context, listen: false).state) {
      case MenuState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case MenuState.open:
        slidePercent = 1.2;
        scalePercent = 1.2;
        break;
      case MenuState.opening:
        slidePercent = slideOutCurve.transform(
            Provider.of<MenuController>(context, listen: false).percentOpen);
        scalePercent = scaleDownCurve.transform(
            Provider.of<MenuController>(context, listen: false).percentOpen);
        break;
      case MenuState.closing:
        slidePercent = slideInCurve.transform(
            Provider.of<MenuController>(context, listen: false).percentOpen);
        scalePercent = scaleUpCurve.transform(
            Provider.of<MenuController>(context, listen: false).percentOpen);
        break;
    }

    final slideAmount = 275.0 * slidePercent;
    final contentScale = 1.0 - (0.2 * scalePercent);
    final cornerRadius =
        16.0 * Provider.of<MenuController>(context, listen: false).percentOpen;

    return new Transform(
      transform: new Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: new Container(
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.black12,
              offset: const Offset(0.0, 5.0),
              blurRadius: 15.0,
              spreadRadius: 10.0,
            ),
          ],
        ),
        child: new ClipRRect(
            borderRadius: new BorderRadius.circular(cornerRadius),
            child: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Scaffold(
            body: widget.menuScreen,
          ),
        ),
        createContentDisplay()
      ],
    );
  }
}

class ZoomScaffoldMenuController extends StatefulWidget {
  final ZoomScaffoldBuilder builder;

  ZoomScaffoldMenuController({
    this.builder,
  });

  @override
  ZoomScaffoldMenuControllerState createState() {
    return new ZoomScaffoldMenuControllerState();
  }
}

class ZoomScaffoldMenuControllerState
    extends State<ZoomScaffoldMenuController> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(
        context, Provider.of<MenuController>(context, listen: false));
  }
}

typedef Widget ZoomScaffoldBuilder(
    BuildContext context, MenuController menuController);

class Layout {
  final WidgetBuilder contentBuilder;

  Layout({
    this.contentBuilder,
  });
}

class MenuController extends ChangeNotifier {
  final TickerProvider vsync;
  final AnimationController _animationController;
  MenuState state = MenuState.closed;

  MenuController({
    this.vsync,
  }) : _animationController = new AnimationController(vsync: vsync) {
    _animationController
      ..duration = const Duration(milliseconds: 250)
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = MenuState.opening;
            break;
          case AnimationStatus.reverse:
            state = MenuState.closing;
            break;
          case AnimationStatus.completed:
            state = MenuState.open;
            break;
          case AnimationStatus.dismissed:
            state = MenuState.closed;
            break;
        }
        notifyListeners();
      });
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  get percentOpen {
    return _animationController.value;
  }

  open() {
    _animationController.forward();
  }

  close() {
    _animationController.reverse();
  }

  toggle() {
    if (state == MenuState.open) {
      close();
    } else if (state == MenuState.closed) {
      open();
    }
  }
}

enum MenuState {
  closed,
  opening,
  open,
  closing,
}
