import 'dart:html' as html;
import 'dart:js' as js;

void clearAllCaches() {
  // Clear sessionStorage and localStorage
  html.window.sessionStorage.clear();
  html.window.localStorage.clear();

  // Clear cookies
  html.document.cookie = '';

  // Clear service worker cache
  js.context.callMethod('eval', [
    """
    caches.keys().then((keyList) => {
      return Promise.all(keyList.map((key) => caches.delete(key)));
    });
  """
  ]);

  // Force page reload
  html.window.location.reload();
}
