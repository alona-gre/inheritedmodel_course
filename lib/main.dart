import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:developer' as devtools show log;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var color1 = Colors.blue;
  var color2 = Colors.yellow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: AvailableColorWidget(
        col1: color1,
        col2: color2,
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      color1 = colors.getRandomElement();
                    });
                  },
                  child: const Text('Change Color 1'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      color2 = colors.getRandomElement();
                    });
                  },
                  child: const Text('Change Color 2'),
                ),
              ],
            ),
            const ColorWidget(
              color: AvailableColors.one,
            ),
            const ColorWidget(
              color: AvailableColors.two,
            ),
          ],
        ),
      ),
    );
  }
}

enum AvailableColors { one, two }

class AvailableColorWidget extends InheritedModel<AvailableColors> {
  final MaterialColor col1;
  final MaterialColor col2;

  const AvailableColorWidget({
    Key? key,
    required this.col1,
    required this.col2,
    required Widget child,
  }) : super(key: key, child: child);

  static AvailableColorWidget of(BuildContext context, AvailableColors aspect) {
    return InheritedModel.inheritFrom<AvailableColorWidget>(
      context,
      aspect: aspect,
    )!;
  }

  @override
  bool updateShouldNotify(covariant AvailableColorWidget oldWidget) {
    devtools.log('updateShouldNotify');
    return col1 != oldWidget.col1 || col2 != oldWidget.col2;
  }

  @override
  bool updateShouldNotifyDependent(covariant AvailableColorWidget oldWidget,
      Set<AvailableColors> dependencies) {
    devtools.log('updateShouldNotifyDependent');

    if (dependencies.contains(AvailableColors.one) && col1 != oldWidget.col1) {
      return true;
    }
    if (dependencies.contains(AvailableColors.two) && col2 != oldWidget.col2) {
      return true;
    }
    return false;
  }
}

class ColorWidget extends StatelessWidget {
  final AvailableColors color;

  const ColorWidget({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (color) {
      case AvailableColors.one:
        devtools.log("Color1 widget got rebuilt");
        break;
      case AvailableColors.two:
        devtools.log("Color2 widget got rebuilt");
        break;
    }

    final provider = AvailableColorWidget.of(
      context,
      color,
    );

    return Container(
      height: 100,
      color: color == AvailableColors.one ? provider.col1 : provider.col2,
    );
  }
}

final colors = [
  Colors.blue,
  Colors.red,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.cyan,
  Colors.brown,
  Colors.amber,
  Colors.deepPurple,
];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(
        Random().nextInt(length),
      );
}
