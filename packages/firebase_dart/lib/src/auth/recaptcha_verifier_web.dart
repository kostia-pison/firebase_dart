import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:math';

import 'package:web/web.dart';

import 'auth.dart';
import 'grecaptcha.dart';
import 'impl/auth.dart';

class RecaptchaVerifierImpl implements RecaptchaVerifier {
  final FirebaseAuth auth;

  final String? container;

  final RecaptchaVerifierSize size;

  final RecaptchaVerifierTheme theme;

  final RecaptchaVerifierOnSuccess? onSuccess;

  final RecaptchaVerifierOnError? onError;

  final RecaptchaVerifierOnExpired? onExpired;

  int? widgetId;

  Element? _element;

  Completer<String>? _completer;

  RecaptchaVerifierImpl({
    required this.auth,
    this.container,
    this.size = RecaptchaVerifierSize.normal,
    this.theme = RecaptchaVerifierTheme.light,
    this.onSuccess,
    this.onError,
    this.onExpired,
  });

  @override
  void clear() {
    if (widgetId != null) {
      grecaptcha.reset(widgetId!);
      widgetId = null;
      _completer = null;
      _element?.remove();
    }
  }

  @override
  Future<int> render() async {
    await RecaptchaLoader().load();
    if (widgetId == null) {
      var element = container == null
          ? document.body!
          : document.getElementById(container!)!;
      var guaranteedEmpty = document.createElement('div')..id = 'recaptcha';
      element.children.add(guaranteedEmpty);
      _element = element = guaranteedEmpty;

      _completer = Completer();

      int? newWidgetId;

      newWidgetId = grecaptcha.render(
        element,
        createGRecaptchaParameters(
          callback: tokenCallbackToJS((v) {
            if (newWidgetId != widgetId) return;
            if (onSuccess != null) onSuccess!();
            _completer!.complete(v);
          }),
          errorCallback: errorCallbackToJS((error) {
            var e = FirebaseAuthException('recaptcha-error', '$error');
            if (onError != null) onError!(e);
            _completer!.completeError(e);
          }),
          expiredCallback: voidCallbackToJS(() {
            if (onExpired != null) onExpired!();
            _completer!
                .completeError(FirebaseAuthException('recaptcha-expired'));
          }),
          size: container == null ? 'invisible' : size.name,
          theme: theme.name,
          sitekey:
              await (auth as FirebaseAuthImpl).rpcHandler.getRecaptchaSiteKey(),
        ),
      );
      widgetId = newWidgetId;
    }

    return widgetId!;
  }

  @override
  String get type => 'recaptcha';

  @override
  Future<String> verify() async {
    if (widgetId == null) {
      await render();
    }
    if (container == null) {
      grecaptcha.execute(widgetId!);
    }

    return _completer!.future.whenComplete(() => clear());
  }
}

class RecaptchaLoader {
  static final _instance = RecaptchaLoader._();

  String? _hostLanguage;

  Future<void>? _loadFuture;

  RecaptchaLoader._();

  factory RecaptchaLoader() => _instance;

  bool _isHostLanguageValid(String hl) {
    return hl.length <= 6 && RegExp(r'^\s*[a-zA-Z0-9\-]*\s*$').hasMatch(hl);
  }

  Future<void> load([String hl = '']) {
    if (!_isHostLanguageValid(hl)) {
      throw FirebaseAuthException.argumentError('Invalid hl parameter value.');
    }

    if (_hostLanguage == hl) {
      return _loadFuture!;
    }

    var completer = Completer<void>();

    var r = Random();

    var name = '_gonload${r.nextInt(1000000)}';
    var script = HTMLScriptElement()
      ..src = Uri.parse('https://www.google.com/recaptcha/api.js')
          .replace(queryParameters: {
        'render': 'explicit',
        'onload': name,
        if (hl.isNotEmpty) 'hl': hl,
      }).toString()
      ..async = true;

    window.setProperty(
      name.toJS,
      (JSAny _) {
        completer.complete();
      }.toJS,
    );

    document.body!.append(script);

    return _loadFuture = completer.future;
  }
}
