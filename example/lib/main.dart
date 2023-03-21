import 'package:example/generated/tokens.g.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    HSLColor.fromColor(Colors.white).withLightness(0.5);
    return MaterialApp(
      title: 'Figma2Flutter Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Figma2Flutter')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _Card(),
            ],
          ),
        ),
      ),
    );
  }
}

// Example of using a CompositionToken in a Composition widget
class _Card extends StatelessWidget {
  const _Card();

  @override
  Widget build(BuildContext context) {
    return Composition(
      token: TokensThemeWhite.composition.cardComp,
      axis: Axis.vertical,
      children: const [
        Text(
          'Hello World',
          style: TextStyle(
            fontSize: 20,
            color: Colors.red,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text('This is a composable widget based of a token'),
      ],
    );
  }
}
