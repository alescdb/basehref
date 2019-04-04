import 'dart:async';

import 'package:build/build.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:logging/logging.dart';
import 'package:pedantic/pedantic.dart';

class BaseHrefBuilder implements Builder {
  String href;
  final _logger = Logger('BaseHrefBuilder');

  BaseHrefBuilder(BuilderOptions options) {
    if (options.config.containsKey('href')) {
      this.href = options.config['href'];
    } else {
      this.href = '/';
    }
  }

  dom.Element _getFirst(List<dom.Element> nodes) {
    if (nodes != null && nodes.isNotEmpty) {
      return (nodes.first);
    }
    return (null);
  }

  @override
  Future build(BuildStep buildStep) async {
    var content = await buildStep.readAsString(buildStep.inputId);
    var document = parser.parse(content);
    var head = _getFirst(document.getElementsByTagName('head'));

    if (head != null) {
      _logger.info('Setting <base href=\"$href\">\n');

      var base = _getFirst(head.getElementsByTagName('base'));
      if (base == null) {
        base = document.createElement('base');
        head.append(base);
      }
      base.attributes['href'] = href;

      var output = buildStep.inputId.changeExtension(buildExtensions['.html'][0]);
      _logger.info('Output file : ${output.path}\n');

      // No need to await writeAsString() cf. buildStep.writeAsString()
      unawaited(buildStep.writeAsString(output, document.outerHtml));
    }
  }

  @override
  final buildExtensions = const {
    '.html': ['.basehref.html']
  };
}
