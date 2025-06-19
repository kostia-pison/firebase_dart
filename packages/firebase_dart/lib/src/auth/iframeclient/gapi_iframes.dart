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
  @staticInterop
  external IThenable ping();

  @staticInterop
  external void restyle(IframeRestyleOptions parameters);

  @staticInterop
  external void send(
      String type, dynamic data, Function onDone, IframesFilter filter);

  @staticInterop
  external void register(String eventName, IframeEventHandler callback,
      [IframesFilter filter]);

  @staticInterop
  external void unregister(String eventName, IframeEventHandler callback);
}

@JS()
@anonymous
@staticInterop
abstract class Context {
  @staticInterop
  external void openChild(IframeOptions options);

  @staticInterop
  external void open(IframeOptions options, [Function(Iframe) onOpen]);
}

@JS()
@anonymous
@staticInterop
abstract class IframeAttributes {
  @staticInterop
  external CSSStyleDeclaration? style;

  @staticInterop
  external factory IframeAttributes({CSSStyleDeclaration? style});
}

@JS()
@anonymous
@staticInterop
abstract class IframeRestyleOptions {
  @staticInterop
  external bool? setHideOnLeave;

  @staticInterop
  external factory IframeRestyleOptions({bool? setHideOnLeave});
}

@JS()
@anonymous
@staticInterop
abstract class IframeEvent {
  @staticInterop
  external String type;

  @staticInterop
  external IframeAuthEvent? authEvent;
}

@JS()
@anonymous
@staticInterop
abstract class IframeEventHandlerResponse {
  @staticInterop
  external String status;

  @staticInterop
  external factory IframeEventHandlerResponse({String status});
}

typedef IframeEventHandler = IframeEventHandlerResponse Function(
    IframeEvent, Iframe);

@JS()
@anonymous
@staticInterop
abstract class IframeAuthEvent {
  @staticInterop
  external String? eventId;

  @staticInterop
  external String? postBody;

  @staticInterop
  external String? sessionId;

  @staticInterop
  external String? providerId;

  @staticInterop
  external String? tenantId;

  @staticInterop
  external String type;

  @staticInterop
  external String? urlResponse;

  @staticInterop
  external IframeError? error;
}

@JS()
@anonymous
@staticInterop
abstract class IframeError {
  @staticInterop
  external String code;

  @staticInterop
  external String message;
}

@JS()
@anonymous
@staticInterop
abstract class IframeOptions {
  @staticInterop
  external String get url;
  @staticInterop
  external HTMLElement? get where;
  @staticInterop
  external IframeAttributes? get attributes;
  @staticInterop
  external IframesFilter? messageHandlersFilter;
  @staticInterop
  external bool? dontclear;

  @staticInterop
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
  @staticInterop
  external void then(Function callback, Function onError);
}

@JS()
@staticInterop
external IframesFilter get CROSS_ORIGIN_IFRAMES_FILTER;

@JS()
@staticInterop
abstract class IframesFilter {}
