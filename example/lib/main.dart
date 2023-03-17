import 'package:example/generated/tokens.g.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Figma2Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Tokens.materialColors.brand,
          backgroundColor: Tokens.colors.white,
          accentColor: Tokens.colors.purple,
        ).copyWith(
          secondary: Tokens.materialColors.yellow,
        ),
      ),
      home: const Scaffold(
        body: Center(child: _Card()),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card();

  @override
  Widget build(BuildContext context) {
    return Composition(
      token: Tokens.compositions.testCard,
      axis: Axis.vertical,
      children: const [
        Text('Hello World', style: TextStyle(fontSize: 20)),
        Text('This is a composable widget based of a token'),
      ],
    );
  }
}
