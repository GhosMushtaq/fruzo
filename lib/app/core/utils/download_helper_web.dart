// Web-only implementation using dart:html
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void downloadApp() {
  final anchor = html.AnchorElement(href: '/fruzo.apk')
    ..setAttribute('download', 'Fruzo.apk')
    ..style.display = 'none';
  html.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
}

bool get canDownloadApp => true;
