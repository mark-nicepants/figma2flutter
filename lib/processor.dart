import 'package:figma2flutter/exceptions/process_token_exception.dart';
import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/models/token_theme.dart';
import 'package:figma2flutter/transformers/transformer.dart';

typedef TransformerFactory = Transformer Function(List<Token> resolved);

class Processor {
  final List<TokenTheme> themes;
  final List<TransformerFactory> singleTokenTransformerFactories;
  final List<TransformerFactory> multiTokenTransformerFactories;

  Processor({
    required this.themes,
    this.singleTokenTransformerFactories = const [],
    this.multiTokenTransformerFactories = const [],
  });

  void process([List<String> filteredTypes = const []]) {
    for (final theme in themes) {
      //print('Generating Theme: ${theme.name}');
      final resolved = theme.resolvedTokens;
      if (filteredTypes.isNotEmpty) {
        resolved.removeWhere((element) {
          for (final type in filteredTypes) {
            if (element.path.startsWith('.$type.')) {
              return true;
            }
          }
          return false;
        });
      }

      final single = _loopProcess(singleTokenTransformerFactories, resolved);
      final multi = _loopProcess(multiTokenTransformerFactories, resolved)
          .cast<MultiTokenTransformer>()
        ..forEach((element) => element.postProcess());

      theme.transformers.addAll(
        [...single, ...multi].where((element) => element.lines.isNotEmpty),
      );
    }
  }

  List<Transformer> _loopProcess(
    List<TransformerFactory> factories,
    List<Token> tokens,
  ) {
    final transformers = factories.map((f) => f(tokens)).toList();
    for (final transformer in transformers) {
      for (final token in tokens) {
        _safeProcess(transformer, token);
      }
    }
    return transformers;
  }

  void _safeProcess(Transformer transformer, Token token) {
    try {
      transformer.process(token);
    } catch (e) {
      throw ProcessTokenException(
        'Error while processing ${token.path}.${token.name}',
        e,
      );
    }
  }
}
