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

  void process() {
    for (final theme in themes) {
      final resolved = theme.resolvedTokens;

      final single = _loopProcess(singleTokenTransformerFactories, resolved);
      final multi = _loopProcess(multiTokenTransformerFactories, resolved);

      theme.transformers.addAll([...single, ...multi]);
    }
  }

  List<Transformer> _loopProcess(
    List<TransformerFactory> facotries,
    List<Token> tokens,
  ) {
    final transformers = facotries.map((f) => f(tokens)).toList();
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
