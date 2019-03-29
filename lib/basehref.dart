import 'dart:async';

import 'package:build/build.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class BaseHrefBuilder implements Builder {
  String href;

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
      print("Setting <base href=\"${href}\" />");

      var base = _getFirst(head.getElementsByTagName("base"));
      if (base == null) {
        base = document.createElement("base");
        head.append(base);
      }
      base.attributes['href'] = href;

      var output = buildStep.inputId.changeExtension(buildExtensions['.html'][0]);
      await buildStep.writeAsString(output, document.outerHtml);
    }
  }

  @override
  final buildExtensions = const {
    '.html': ['.basehref.html']
  };
}
