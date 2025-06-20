@JS('gapi')
library gapi;

import 'dart:js_interop';

@JS()
external void load(String libraries, LoadConfig config);

@JS()
@anonymous
abstract class LoadConfig {
  external factory LoadConfig({
    Function callback,
    Function onerror,
    num timeout,
    Function ontimeout,
  });

  external Function get callback;
  external Function get onerror;
  external num get timeout;
  external Function get ontimeout;
}
