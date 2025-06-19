// ignore_for_file: non_constant_identifier_names

@JS('gapi.iframes')
library gapi.iframes;

import 'dart:js_interop';

import 'package:web/web.dart';

@JS()
@staticInterop
external Context getContext();

@JS()
@staticInterop
class Iframe {
  external IThenable ping();

  external void restyle(IframeRestyleOptions parameters);

  external void send(
      String type, dynamic data, Function onDone, IframesFilter filter);

  external void register(String eventName, IframeEventHandler callback,
      [IframesFilter filter]);
  external void unregister(String eventName, IframeEventHandler callback);
}

@JS()
@anonymous
@staticInterop
abstract class Context {
  external void openChild(IframeOptions options);

  external void open(IframeOptions options, [Function(Iframe) onOpen]);
}

@JS()
@anonymous
@staticInterop
abstract class IframeAttributes {
  external CSSStyleDeclaration? style;

  external factory IframeAttributes({CSSStyleDeclaration? style});
}

@JS()
@anonymous
@staticInterop
abstract class IframeRestyleOptions {
  external bool? setHideOnLeave;

  external factory IframeRestyleOptions({bool? setHideOnLeave});
}

@JS()
@anonymous
@staticInterop
abstract class IframeEvent {
  external String type;

  external IframeAuthEvent? authEvent;
}

@JS()
@anonymous
@staticInterop
abstract class IframeEventHandlerResponse {
  external String status;

  external factory IframeEventHandlerResponse({String status});
}

typedef IframeEventHandler = IframeEventHandlerResponse Function(
    IframeEvent, Iframe);

@JS()
@anonymous
@staticInterop
abstract class IframeAuthEvent {
  external String? eventId;

  external String? postBody;

  external String? sessionId;

  external String? providerId;

  external String? tenantId;

  external String type;

  external String? urlResponse;

  external IframeError? error;
}

@JS()
@anonymous
@staticInterop
abstract class IframeError {
  external String code;

  external String message;
}

@JS()
@anonymous
@staticInterop
abstract class IframeOptions {
  external String get url;
  external HTMLElement? get where;
  external IframeAttributes? get attributes;
  external IframesFilter? messageHandlersFilter;
  external bool? dontclear;

  external factory IframeOptions({
    String url,
    HTMLElement? where,
    IframeAttributes? attributes,
    IframesFilter? messageHandlersFilter,
    bool? dontclear,
  });
}

@JS()
@anonymous
@staticInterop
abstract class IThenable {
  external void then(Function callback, Function onError);
}

@JS()
@staticInterop
external IframesFilter get CROSS_ORIGIN_IFRAMES_FILTER;

@JS()
@staticInterop
abstract class IframesFilter {}
