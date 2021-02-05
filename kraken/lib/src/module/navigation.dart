import 'module_manager.dart';

typedef KrakenNavigationDecisionHandler = Future<KrakenNavigationActionPolicy> Function(KrakenNavigationAction action);
typedef KrakenNavigationErrorHandler = void Function(Object error, Object stack);

enum KrakenNavigationActionPolicy {
  // allow kraken to perform navigate.
  allow,

  // cancel kraken default's navigate action.
  cancel
}

enum KrakenNavigationType {
  // A link with an href attribute was activated by the user.
  linkActivated,

  // the view was reloaded
  reload,

  // other navigation type
  other
}

class NavigationModule extends BaseModule {
  NavigationModule(ModuleManager moduleManager) : super(moduleManager);

  @override
  void dispose() {}

  @override
  String invoke(String method, dynamic params, callback) {
    if (method == 'goTo') {
      String url = params[0];
      String sourceUrl = moduleManager.controller.bundleURL;

      Uri targetUri = Uri.parse(url);
      Uri sourceUri = Uri.parse(sourceUrl);

      if (targetUri.scheme != sourceUri.scheme ||
          targetUri.host != sourceUri.host ||
          targetUri.port != sourceUri.port ||
          targetUri.path != sourceUri.path ||
          targetUri.query != sourceUri.query) {
        moduleManager.controller.view.handleNavigationAction(sourceUrl, url, KrakenNavigationType.reload);
      }
    }

    return '';
  }
}

class KrakenNavigationAction {
  KrakenNavigationAction(this.source, this.target, this.navigationType);

  // The current source url.
  String source;

  // The target source url.
  String target;

  // The navigation type.
  KrakenNavigationType navigationType;

  @override
  String toString() => 'KrakenNavigationType(source:$source, target:$target, navigationType:$navigationType)';
}

Future<KrakenNavigationActionPolicy> defaultDecisionHandler(KrakenNavigationAction action) async {
  return KrakenNavigationActionPolicy.allow;
}

class KrakenNavigationDelegate {
  // Called when an error occurs during navigation.
  KrakenNavigationErrorHandler errorHandler;

  KrakenNavigationDecisionHandler _decisionHandler = defaultDecisionHandler;

  void setDecisionHandler(KrakenNavigationDecisionHandler handler) {
    _decisionHandler = handler;
  }

  Future<KrakenNavigationActionPolicy> dispatchDecisionHandler(KrakenNavigationAction action) async {
    return await _decisionHandler(action);
  }
}
