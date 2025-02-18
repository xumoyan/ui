import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:polkawallet_ui/components/v3/plugin/tabBarPlugin.dart';

class MetaHubPage extends StatefulWidget {
  MetaHubPage(
      {required this.pluginName,
      required this.metaItems,
      this.colors = const [Color(0xFFE40C5A), Color(0xFFFF4C3C)],
      Key? key})
      : super(key: key);
  final String pluginName;
  final List<Color> colors;
  final List<MetaHubItem> metaItems;

  @override
  _MetaHubPageState createState() => _MetaHubPageState();
}

class _MetaHubPageState extends State<MetaHubPage>
    with TickerProviderStateMixin {
  final SwiperController _swiperController = SwiperController();
  final TabBarPluginController _tabBarPluginController =
      TabBarPluginController();
  int _currentIndex = 0;
  bool _isTabBarOnClick = false;
  final double _viewportFraction = 0.8;
  final List<String> _titles = [];

  AnimationController? controller;
  double animationNumber = 0;
  late Animation<double> animation;

  void _startAnimation() {
    this.controller = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeInOutQuint))
        .animate(this.controller!);
    animation.addListener(() {
      setState(() {
        animationNumber = animation.value;
      });
    });
    Future.delayed(Duration(milliseconds: 150), () {
      controller!.forward();
    });
  }

  @override
  void initState() {
    widget.metaItems.forEach((element) {
      _titles.add(element.title);
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _startAnimation();
    });
    super.initState();
  }

  Widget buildDoorTop() {
    final proportion = MediaQuery.of(context).size.width /
        MediaQuery.of(context).size.height *
        0.32;
    final factor =
        1 - animationNumber > proportion ? 1 - animationNumber : proportion;
    return ClipRect(
        child: Align(
            heightFactor: factor,
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: (MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom) /
                  2,
              decoration: new BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                      'packages/polkawallet_ui/assets/images/door_top.png'),
                ),
              ),
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 14),
                  child: TabBarPlugin(
                    datas: _titles,
                    controller: _tabBarPluginController,
                    onChange: (index) {
                      _swiperController.move(index);
                      _currentIndex = index;
                      _isTabBarOnClick = true;
                    },
                  ),
                ),
                height: 65,
                width: double.infinity,
              ),
            )));
  }

  Widget buildDoorBottom() {
    return ClipRect(
        child: Align(
            heightFactor: 1 - animationNumber,
            alignment: Alignment.topCenter,
            child: Image.asset(
              'packages/polkawallet_ui/assets/images/door_bottom.png',
              width: double.infinity,
              fit: BoxFit.cover,
            )));
  }

  @override
  Widget build(BuildContext context) {
    final itemWidth = MediaQuery.of(context).size.width * _viewportFraction;
    final itemHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        71 -
        28 -
        60 -
        50 -
        50;
    return Scaffold(
        // appBar: PreferredSize(
        //   child: Center(
        //     child: Padding(
        //       padding: EdgeInsets.only(
        //           top: MediaQuery.of(context).padding.top, left: 16, right: 16),
        //       child: TabBarPlugin(
        //         datas: _titles,
        //         controller: _tabBarPluginController,
        //         onChange: (index) {
        //           _swiperController.move(index);
        //           _currentIndex = index;
        //           _isTabBarOnClick = true;
        //         },
        //       ),
        //     ),
        //   ),
        //   preferredSize: Size.fromHeight(71),
        // ),
        body: SafeArea(
            child: Stack(children: [
      Container(
        padding: EdgeInsets.only(
            top: 28 +
                (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom) /
                    2 *
                    0.2,
            bottom: 60),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    "packages/polkawallet_ui/assets/images/metaHub_bg.png"),
                fit: BoxFit.fill),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.0],
                colors: [Color(0xFF4D5458), Color(0xFF191A22)])),
        child: Swiper(
          outer: true,
          physics: BouncingScrollPhysics(),
          controller: _swiperController,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          "packages/polkawallet_ui/assets/images/metaHub_item_bg.png"),
                      fit: BoxFit.fill)),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.all(19),
                    margin: EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 7,
                        bottom: 65 / 553 * itemHeight),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: const Radius.circular(10),
                            topRight: const Radius.circular(10)),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                            colors: [Color(0xFF27292F), Color(0xFF202020)])),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: boundingTextSize(
                                  widget.metaItems[index].title,
                                  Theme.of(context)
                                      .textTheme
                                      .headline3
                                      ?.copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFFF8E66)))
                              .width,
                          child: Column(
                            children: [
                              Text(
                                widget.metaItems[index].title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    ?.copyWith(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFF8E66)),
                              ),
                              Divider(
                                height: 4,
                                thickness: 4,
                                color: Color(0xFFFF8E66),
                              )
                            ],
                          ),
                          margin: EdgeInsets.only(bottom: 24),
                        ),
                        Expanded(child: widget.metaItems[index].context)
                      ],
                    ),
                  ),
                  Container(
                    height: 26 / 553 * itemHeight,
                    width: 132 / 288 * itemWidth,
                    margin: EdgeInsets.only(
                        right: 34 / 288 * itemWidth,
                        bottom: 15 / 553 * itemHeight),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: const Radius.circular(2),
                            topRight: const Radius.circular(6),
                            bottomLeft: const Radius.circular(2),
                            bottomRight: const Radius.circular(2)),
                        color: Color(0xFF0B0B0B)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                                height: 11 / 553 * itemHeight,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        stops: [0.0, 1.0],
                                        colors: widget.colors)))),
                        Padding(
                          padding: EdgeInsets.only(left: 7),
                          child: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                        colors: widget.colors,
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight)
                                    .createShader(bounds);
                              },
                              blendMode: BlendMode.srcATop,
                              child: Text(
                                widget.pluginName.toUpperCase(),
                                style: Theme.of(context)
                                    .appBarTheme
                                    .titleTextStyle
                                    ?.copyWith(fontSize: 16),
                              )),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
          itemCount: widget.metaItems.length,
          viewportFraction: _viewportFraction,
          scale: 0.8,
          fade: 0.5,
          loop: false,
          onIndexChanged: (index) {
            if (_isTabBarOnClick == false) {
              _tabBarPluginController.move(index);
              _currentIndex = index;
            }
            if (index == _currentIndex) {
              _isTabBarOnClick = false;
            }
          },
        ),
      ),
      buildDoorTop(),
      Align(alignment: Alignment.bottomCenter, child: buildDoorBottom()),
    ])));
  }

  static Size boundingTextSize(String text, TextStyle? style) {
    if (text == null || text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: text, style: style))
      ..layout();
    return textPainter.size;
  }
}

class MetaHubItem {
  const MetaHubItem(this.title, this.context);

  final String title;
  final Widget context;
}
