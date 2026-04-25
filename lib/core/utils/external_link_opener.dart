import 'external_link_opener_stub.dart'
    if (dart.library.html) 'external_link_opener_web.dart' as impl;

Future<bool> openExternalLink(String url) => impl.openExternalLink(url);
