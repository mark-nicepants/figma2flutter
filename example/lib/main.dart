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
    final tokens = context.tokens;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Composition(
        token: tokens.composition.cardComp.copyWith(
          textStyle: tokens.textStyle.typographyBody.copyWith(
            color: tokens.color.fgDefault,
          ),
        ),
        axis: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enable 2FA',
            style: tokens.textStyle.typographyH5Bold,
          ),
          Text(
            'Two-factor authentication (2FA) is an identity and access management security method that requires two forms of identification to access resources and data.',
            style: tokens.textStyle.typographyBody.copyWith(
              color: tokens.color.fgMuted,
            ),
          ),
          const _Button(label: 'Enable'),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Composition(
      token: context.tokens.composition.buttonComp,
      axis: Axis.horizontal,
      children: [
        Text(
          label,
          style: TextStyle(
            color: context.tokens.color.accentOnAccent,
          ),
        ),
      ],
    );
  }
}
