import 'package:flutter/material.dart';
import 'package:touch_to_expand_container/touch_to_expand_container.dart';
import 'panels/map_placeholder.dart';
void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => DemoAppState();
}

class DemoAppState extends State<DemoApp> {
  double widgetHeight = 200;
  double widgetWidth = 200;
  double widgetExpandHeight = 390;
  double widgetExpandWidth = 350;
  double expandedOffsetX = 0;
  double expandedOffsetY = 0;
  bool showBarrier2 = true;
  bool showBarrier5 = true;
  final container2Key = GlobalKey<TouchToExpandContainerState>();
  final container5Key = GlobalKey<TouchToExpandContainerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PageView(
          children: [
            SingleChildScrollView(
              child: TouchToExpandOverlayWrapper(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 160, width: double.infinity),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 134,
                            height: 120,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              "The\nTouchTo\nExpand\nContainer",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                height: 1.2
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          SizedBox(width: 60),

                          Container(
                            width: 134,
                            height: 120,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              "made by\nChleosl",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                height: 2
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 54),

                      TouchToExpandContainer(
                        child: MapView(),
                        width: 160,
                        height: 160,
                      ),

                      SizedBox(height: 60),

                      Container(
                        width: 340,
                        height: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          border: Border.all(color: Colors.black, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          "it responds to the overscrolling stretch effect if there's a parents that is scrollable, like SingleChildScrollView or PageView.",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 16),


                      Container(
                        width: 340,
                        height: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          border: Border.all(color: Colors.black, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          "it not just only projects the 'preview' of child but it also maintains a continuous instance with it. Integrating and Complying with the surrounding contexts are Especially important in UX design.",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 60),


                      Container(
                        width: 340,
                        height: 16,
                        decoration: BoxDecoration(color: const Color.fromARGB(120, 220, 220, 220)),
                      ),

                      SizedBox(height: 8),

                      Container(
                        width: 340,
                        height: 32,
                        decoration: BoxDecoration(color: const Color.fromARGB(120, 220, 220, 220)),
                      ),



                      SizedBox(height: 82),







                      Container(
                        width: 340,
                        height: 130,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Text(
                          "The TouchToExpandContainer not only overlays the contents with the live preview but it also can make the expanded container itself to dynamically readjust its height or width, offset and background barriers, etc.",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 86),

                      TouchToExpandContainer(
                        width: widgetWidth,
                        height: widgetHeight,
                        expandedWidth: widgetExpandWidth,
                        expandedHeight: widgetExpandHeight,
                        expandedOffset: Offset(
                          expandedOffsetX,
                          expandedOffsetY,
                        ),
                        showBarrier: showBarrier2,
                        key: container2Key,
                        child: Builder(
                          builder: (context) {
                            return Stack(
                              children: [
                                MapView(),
                                Builder(
                                  builder: (context) {
                                    final expandedState =
                                        ExpandedStateProvider.of(context);
                                    final isExpanded =
                                        expandedState?.isExpanded ?? false;

                                    if (!isExpanded) return SizedBox.shrink();

                                    return Positioned(
                                      bottom: 10,
                                      left: 10,
                                      right: 10,
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.9,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Expanded Width: ${widgetExpandWidth.toStringAsFixed(0)}',
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 30,
                                                        child: Slider(
                                                          value:
                                                              widgetExpandWidth,
                                                          min: 200,
                                                          max: (MediaQuery.of(
                                                                    context,
                                                                  ).size.width *
                                                                  0.95)
                                                              .clamp(
                                                                201,
                                                                double.infinity,
                                                              ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              widgetExpandWidth =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Expanded Height: ${widgetExpandHeight.toStringAsFixed(0)}',
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 30,
                                                        child: Slider(
                                                          value:
                                                              widgetExpandHeight,
                                                          min: 200,
                                                          max: (MediaQuery.of(
                                                                        context,
                                                                      )
                                                                      .size
                                                                      .height *
                                                                  0.95)
                                                              .clamp(
                                                                201,
                                                                double.infinity,
                                                              ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              widgetExpandHeight =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Offset X: ${expandedOffsetX.toStringAsFixed(0)}',
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 30,
                                                        child: Slider(
                                                          value:
                                                              expandedOffsetX,
                                                          min: -200,
                                                          max: 200,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              expandedOffsetX =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Offset Y: ${expandedOffsetY.toStringAsFixed(0)}',
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 30,
                                                        child: Slider(
                                                          value:
                                                              expandedOffsetY,
                                                          min: -200,
                                                          max: 200,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              expandedOffsetY =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: widgetHeight / 6,
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final screenSize = MediaQuery.of(context).size;
                            final maxExpandedWidth = screenSize.width * 0.95;
                            final maxExpandedHeight = screenSize.height * 0.95;

                            return Column(
                              children: [
                                // 첫 번째 행: Width | Height
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Width: ${widgetWidth.toStringAsFixed(0)}',
                                          ),
                                          Slider(
                                            value: widgetWidth,
                                            min: 50,
                                            max: 300,
                                            onChanged: (value) {
                                              setState(() {
                                                widgetWidth = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Height: ${widgetHeight.toStringAsFixed(0)}',
                                          ),
                                          Slider(
                                            value: widgetHeight,
                                            min: 50,
                                            max: 300,
                                            onChanged: (value) {
                                              setState(() {
                                                widgetHeight = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                // 두 번째 행: Expanded Width | Expanded Height
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Expanded Width: ${widgetExpandWidth.toStringAsFixed(0)}',
                                          ),
                                          Slider(
                                            value: widgetExpandWidth,
                                            min: 200,
                                            max: maxExpandedWidth,
                                            onChanged: (value) {
                                              setState(() {
                                                widgetExpandWidth = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Expanded Height: ${widgetExpandHeight.toStringAsFixed(0)}',
                                          ),
                                          Slider(
                                            value: widgetExpandHeight,
                                            min: 200,
                                            max: maxExpandedHeight,
                                            onChanged: (value) {
                                              setState(() {
                                                widgetExpandHeight = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                // 세 번째 행: Offset X | Offset Y
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Offset X: ${expandedOffsetX.toStringAsFixed(0)}',
                                          ),
                                          Slider(
                                            value: expandedOffsetX,
                                            min: -200,
                                            max: 200,
                                            onChanged: (value) {
                                              setState(() {
                                                expandedOffsetX = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Offset Y: ${expandedOffsetY.toStringAsFixed(0)}',
                                          ),
                                          Slider(
                                            value: expandedOffsetY,
                                            min: -200,
                                            max: 200,
                                            onChanged: (value) {
                                              setState(() {
                                                expandedOffsetY = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 10),

                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Card(
                                    elevation: 2,
                                    child: SwitchListTile(
                                      title: Text('showBarrier boolean'),
                                      subtitle: Text(
                                        'Toggle background barrier',
                                      ),
                                      value: showBarrier2,
                                      onChanged: (value) {
                                        setState(() {
                                          showBarrier2 = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),

                                SizedBox(height: 6),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed:
                                          () =>
                                              container2Key.currentState
                                                  ?.expand(),
                                      child: Text('Expand by key'),
                                    ),
                                    SizedBox(width: 46),
                                    ElevatedButton(
                                      onPressed:
                                          () =>
                                              container2Key.currentState
                                                  ?.collapse(),
                                      child: Text('Collapse by key'),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 36),

                      Container(
                        width: 340,
                        height: 58,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: Text(
                          "The TouchToExpandContainers that are decoration fields had filled with.",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 28),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TouchToExpandContainer(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            expandedDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 40,
                                  offset: Offset(0, 16),
                                ),
                              ],
                            ),
                            child: MapView(),
                          ),

                          SizedBox(width: 28),

                          TouchToExpandContainer(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            expandedDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 40,
                                  offset: Offset(0, 16),
                                ),
                              ],
                            ),
                            child: MapView(),
                          ),
                        ],
                      ),

                      SizedBox(height: 110),

                      Container(
                        width: 340,
                        height: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          border: Border.all(color: Colors.black, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          "You can add 'handle' on the Expanded Overlay to make it 'draggable': isHandled boolean with CustomPainter.",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 60),

                      TouchToExpandContainer(
                        height: 200,
                        width: 200,
                        expandedHeight: 390,
                        expandedWidth: 350,
                        isHandled: true,
                        handlebarOffset: Offset(30, 0),
                        key: container5Key,
                        showBarrier: showBarrier5,
                        child: MapView(),
                      ),

                      SizedBox(height: 60),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Card(
                          elevation: 2,
                          child: SwitchListTile(
                            title: Text('showBarrier boolean'),
                            subtitle: Text('Toggle background barrier'),
                            value: showBarrier5,
                            onChanged: (value) {
                              setState(() {
                                showBarrier5 = value;
                              });
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 6),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed:
                                () => container5Key.currentState?.expand(),
                            child: Text('Expand by key'),
                          ),
                          SizedBox(width: 36),
                          ElevatedButton(
                            onPressed:
                                () => container5Key.currentState?.collapse(),
                            child: Text('Collapse by key'),
                          ),
                        ],
                      ),

                      SizedBox(height: 60),
                      
                      

                      
                      Container(
                        width: 340,
                        height: 120,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          border: Border.all(color: Colors.black, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          "There are also other various parameters you can play/explore with, but these are overall important parameters with it.",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 90),


                    ],
                  ),
                ),
              ),
            ),




          ],
        ),
      ),
    );
  }
}
