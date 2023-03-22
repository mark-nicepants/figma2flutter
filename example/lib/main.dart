import 'package:example/generated/tokens.g.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ITokens tokens = LightTokens();

  @override
  Widget build(BuildContext context) {
    return Tokens(
      tokens: tokens,
      child: MaterialApp(
        title: 'Figma2Flutter Demo',
        home: Scaffold(
          appBar: AppBar(title: const Text('Figma2Flutter')),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ToggleButtons(
                  isSelected: [
                    tokens is LightTokens,
                    tokens is DarkTokens,
                  ],
                  onPressed: (index) {
                    setState(() {
                      tokens = index == 0 ? LightTokens() : DarkTokens();
                    });
                  },
                  children: const [
                    Icon(Icons.light_mode),
                    Icon(Icons.dark_mode),
                  ],
                ),
                const SizedBox(height: 8),
                const _Card(),
              ],
            ),
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
      token: context.tokens.composition.cardComp.copyWith(
        fill: context.tokens.color.bgDefault,
        textStyle: context.tokens.textStyle.typographyBody.copyWith(
          color: context.tokens.color.fgDefault,
        ),
      ),
      axis: Axis.vertical,
      children: const [
        Text(
          'Hello World',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text('This is a composable widget based of a token'),
      ],
    );
  }
}
