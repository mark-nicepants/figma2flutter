import 'package:example/generated/tokens.g.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Figma2Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Tokens.materialColors.red,
          backgroundColor: Tokens.colors.white,
          accentColor: Tokens.colors.purple,
        ).copyWith(
          secondary: Tokens.materialColors.yellow,
        ),
      ),
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
      token: Tokens.compositions.testCard,
      axis: Axis.vertical,
      children: [
        const Text('Hello World', style: TextStyle(fontSize: 20)),
        Text(
          'This is a composable widget based of a token',
          style: Tokens.textStyles.defaultBodyMedium,
        ),
      ],
    );
  }
}
