@JS()
library;

import 'dart:js_interop';

@JS('dexProTrackPageView')
external JSFunction? get _dexProTrackPageView;

void trackPageView({
  required String pagePath,
  required String pageTitle,
}) {
  final JSFunction? trackPageViewFunction = _dexProTrackPageView;

  if (trackPageViewFunction == null) {
    return;
  }

  trackPageViewFunction.callAsFunction(
    null,
    pagePath.toJS,
    pageTitle.toJS,
  );
}
