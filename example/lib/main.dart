import 'package:flutter/material.dart';
import 'package:touch_to_expand_container/touch_to_expand_container.dart';
import 'panels/map_placeholder.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PageView(
          children: [

            SingleChildScrollView(
              child: TouchToExpandOverlayWrapper(
                child: SizedBox()

              ),
            ),
            


          ],
        ),
      ),
    );
  }
}