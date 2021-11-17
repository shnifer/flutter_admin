// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void saveFile(Object bytes, String fileName) {
  js.context.callMethod("saveAs", <Object>[
    html.Blob(<Object>[bytes]),
    fileName
  ]);
}