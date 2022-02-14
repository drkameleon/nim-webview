{.passC: "-I" & currentSourcePath().substr(0, high(currentSourcePath()) - 4) .}

when defined(macosx):
    #{.compile("webview.cc","-DWEBVIEW_COCOA=1 -DOBJC_OLD_DISPATCH_PROTOTYPES=1 -std=c++11 -framework WebKit").}

    {.passL: "-L. -lwebview.o -lstdc++ -framework WebKit".}
    {.passC: "-DWEBVIEW_HEADER=1 -DWEBVIEW_COCOA=1".}
    

type
    WebviewT*  {.importc: "webview_t", header: "webview.h".} = pointer

proc createWebview*(debug: cint = 0, window: pointer = nil): WebviewT {.importc: "webview_create", header: "webview.h".}
proc runWebview*(wv: WebviewT) {.importc: "webview_run", header: "webview.h".}
proc setWebviewTitle*(wv: WebviewT, title: cstring) {.importc: "webview_set_title", header: "webview.h".}
proc setWebviewSize*(wv: WebviewT, width: cint, height: cint, constraints: cint) {.importc: "webview_set_size", header: "webview.h".}
proc navigateWebview*(wv: WebviewT, url: cstring) {.importc: "webview_navigate", header: "webview.h".}
proc terminateWebview*(wv: WebviewT) {.importc: "webview_terminate", header: "webview.h".}
proc destroyWebview*(wv: WebviewT) {.importc: "webview_destroy", header: "webview.h".}