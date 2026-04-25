import 'package:dexpro/core/utils/analytics_service_stub.dart'
    if (dart.library.js_interop) 'package:dexpro/core/utils/analytics_service_web.dart'
    as analytics_impl;

void trackPageView({
  required String pagePath,
  required String pageTitle,
}) {
  analytics_impl.trackPageView(pagePath: pagePath, pageTitle: pageTitle);
}
