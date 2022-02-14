when defined(macosx):
    #{.compile("webview.cc","-DWEBVIEW_COCOA=1 -DOBJC_OLD_DISPATCH_PROTOTYPES=1 -std=c++11 -framework WebKit").}
    {.passL: "-L.cache -lwebview.cc.o -lc++".}

when not defined(NOWEBVIEW):
    {.passC: "-DWEBVIEW_HEADER=1 -DWEBVIEW_COCOA=1".}
    {.passC: "-I" & currentSourcePath().substr(0, high(currentSourcePath()) - 4) .}

type
    WebviewT*  {.importc: "webview_t", header: "webview.h".} = pointer
    Webview* = ref object of RootObj
        view: WebviewT


proc createWebview*(debug: cint = 0, window: pointer = nil): WebviewT {.importc: "webview_create", header: "webview.h".}
proc runWebview*(wv: WebviewT) {.importc: "webview_run", header: "webview.h".}
proc navigateWebview*(wv: WebviewT, url: cstring) {.importc: "webview_navigate", header: "webview.h".}
proc terminateWebview*(wv: WebviewT) {.importc: "webview_terminate", header: "webview.h".}
proc destroyWebview*(wv: WebviewT) {.importc: "webview_destroy", header: "webview.h".}

# // Runs the main loop until it's terminated. After this function exits - you
# // must destroy the webview.
# WEBVIEW_API void webview_run(webview_t w);

# // Stops the main loop. It is safe to call this function from another other
# // background thread.
# WEBVIEW_API void webview_terminate(webview_t w);

# // Posts a function to be executed on the main thread. You normally do not need
# // to call this function, unless you want to tweak the native window.
# WEBVIEW_API void
# webview_dispatch(webview_t w, void (*fn)(webview_t w, void *arg), void *arg);

# // Returns a native window handle pointer. When using GTK backend the pointer
# // is GtkWindow pointer, when using Cocoa backend the pointer is NSWindow
# // pointer, when using Win32 backend the pointer is HWND pointer.
# WEBVIEW_API void *webview_get_window(webview_t w);

# // Updates the title of the native window. Must be called from the UI thread.
# WEBVIEW_API void webview_set_title(webview_t w, const char *title);

# // Window size hints
# #define WEBVIEW_HINT_NONE 0  // Width and height are default size
# #define WEBVIEW_HINT_MIN 1   // Width and height are minimum bounds
# #define WEBVIEW_HINT_MAX 2   // Width and height are maximum bounds
# #define WEBVIEW_HINT_FIXED 3 // Window size can not be changed by a user
# // Updates native window size. See WEBVIEW_HINT constants.
# WEBVIEW_API void webview_set_size(webview_t w, int width, int height,
#                                   int hints);

# // Navigates webview to the given URL. URL may be a data URI, i.e.
# // "data:text/html,<html>...</html>". It is often ok not to url-encode it
# // properly, webview will re-encode it for you.
# WEBVIEW_API void webview_navigate(webview_t w, const char *url);

# // Injects JavaScript code at the initialization of the new page. Every time
# // the webview will open a the new page - this initialization code will be
# // executed. It is guaranteed that code is executed before window.onload.
# WEBVIEW_API void webview_init(webview_t w, const char *js);

# // Evaluates arbitrary JavaScript code. Evaluation happens asynchronously, also
# // the result of the expression is ignored. Use RPC bindings if you want to
# // receive notifications about the results of the evaluation.
# WEBVIEW_API void webview_eval(webview_t w, const char *js);

# // Binds a native C callback so that it will appear under the given name as a
# // global JavaScript function. Internally it uses webview_init(). Callback
# // receives a request string and a user-provided argument pointer. Request
# // string is a JSON array of all the arguments passed to the JavaScript
# // function.
# WEBVIEW_API void webview_bind(webview_t w, const char *name,
#                               void (*fn)(const char *seq, const char *req,
#                                          void *arg),
#                               void *arg);

# // Allows to return a value from the native binding. Original request pointer
# // must be provided to help internal RPC engine match requests with responses.
# // If status is zero - result is expected to be a valid JSON result value.
# // If status is not zero - result is an error JSON object.
# WEBVIEW_API void webview_return(webview_t w, const char *seq, int status,
#                                 const char *result);

# proc init*(w: Webview): cint {.importc: "webview_init", header: "webview.h".}
# proc loop*(w: Webview; blocking: cint): cint {.importc: "webview_loop", header: "webview.h".}
# proc eval*(w: Webview; js: cstring): cint {.importc: "webview_eval", header: "webview.h".}
# proc getEval*(w: Webview; js: cstring): cstring {.importc: "webview_eval_get", header: "webview.h".}
# proc injectCss*(w: Webview; css: cstring): cint {.importc: "webview_inject_css", header: "webview.h".}
# proc setTitle*(w: Webview; title: cstring) {.importc: "webview_set_title", header: "webview.h".}
# proc setColor*(w: Webview; r,g,b,a: uint8) {.importc: "webview_set_color", header: "webview.h".}
# proc setFullscreen*(w: Webview; fullscreen: cint) {.importc: "webview_set_fullscreen", header: "webview.h".}
# proc dialog*(w: Webview; dlgtype: DialogType; flags: cint; title: cstring; arg: cstring; result: cstring; resultsz: csize_t) {.importc: "webview_dialog", header: "webview.h".}

proc doSth*() =
    echo "I'm doing something"