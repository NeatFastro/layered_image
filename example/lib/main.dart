import 'package:flutter/material.dart';
import 'package:layered_image/layered_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stalker example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          height: 580,
          child: LayeredImage(
            backgroundImageUrl: 'https://neatfastro.com/wp-content/uploads/2021/07/background.jpeg',
            layersImagesUrl: [
              'https://neatfastro.com/wp-content/uploads/2021/07/super-scaled-1.png',
              'https://neatfastro.com/wp-content/uploads/2021/07/batman-scaled-1.png',
              'https://neatfastro.com/wp-content/uploads/2021/07/aquaman-scaled-1.png',
            ],
          ),
        ),
      ),
    );
  }
}
