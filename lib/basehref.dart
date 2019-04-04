import 'dart:async';

import 'package:build/build.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:logging/logging.dart';
//


class BaseHrefBuilder implements Builder {
  String href;
  final _logger = Logger('BaseHrefBuilder');

  BaseHrefBuilder(BuilderOptions options) {
    if (options.config.containsKey("href")) {
      this.href = options.config["href"];
    } else {
      this.href = "/";
    }
  }

  dom.Element _getFirst(List<dom.Element> nodes) {
    if (nodes != null && nodes.length > 0) {
      return (nodes.first);
    }
    return (null);
  }

  @override
  Future build(BuildStep buildStep) async {
    dom.Document document = parser.parse(await buildStep.readAsString(buildStep.inputId));
    var head = _getFirst(document.getElementsByTagName("head"));

    if (head != null) {
      _logger.info("Setting <base href=\"${href}\">\n");

      var base = _getFirst(head.getElementsByTagName("base"));
      if (base == null) {
        base = document.createElement("base");
        head.append(base);
      }
      base.attributes['href'] = href;

      var output = buildStep.inputId.changeExtension(buildExtensions['.html'][0]);
      _logger.info("Output file : ${output.path}\n");

      /// No need to await writeAsString() [Builder]
      buildStep.writeAsString(output, document.outerHtml);
    }
  }

  @override
  final buildExtensions = const {
    '.html': ['.basehref.html']
  };
}
