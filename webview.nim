{.compile("webview.cc","-std=c++11").}
{.passC: "-I" & currentSourcePath().substr(0, high(currentSourcePath()) - 4) .}
{.passL: "-lstdc++".}

when defined(linux):
    {.passC: "-DWEBVIEW_GTK=1 " &
             staticExec"pkg-config --cflags gtk+-3.0 webkit2gtk-4.0".}
    {.passL: staticExec"pkg-config --libs gtk+-3.0 webkit2gtk-4.0".}
elif defined(freebsd):
    {.passC: "-DWEBVIEW_GTK=1 " &
             staticExec"pkg-config --cflags gtk3 webkit2-gtk3".}
    {.passL: staticExec"pkg-config --libs gtk3 webkit2-gtk3".}
elif defined(macosx):
    {.passC: "-DWEBVIEW_COCOA=1".}
    {.passL: "-framework WebKit".}
elif defined(windows):
    {.passC: "-DWEBVIEW_EDGE=1".}
    {.passL: "-mwindows -L./dll/x64 -lwebview -lWebView2Loader".}
    
type
    webview_t {.header: "webview.h", importc.} = pointer
    
    Webview* = ref object of RootObj
        view: webview_t

    Constraints* = enum
        Default = 0
        Minimum = 1
        Maximum = 2
        Fixed = 3

proc webview_create(debug: cint = 0, window: pointer = nil): webview_t {.header: "webview.h", importc.}
proc webview_run(wv: webview_t) {.header: "webview.h", importc.}
proc webview_set_title(wv: webview_t, title: cstring) {.header: "webview.h", importc.}
proc webview_set_size(wv: webview_t, width: cint, height: cint, constraints: Constraints) {.header: "webview.h", importc.}
proc webview_navigate(wv: webview_t, url: cstring) {.header: "webview.h", importc.}
proc webview_terminate(wv: webview_t) {.header: "webview.h", importc.}
proc webview_destroy(wv: webview_t) {.header: "webview.h", importc.}

proc newWebview*(
    title: string, 
    width: int, 
    height: int, 
    constraints = Default, 
    debug=false): Webview =
    
    var wv = webview_create(debug.cint)
    webview_set_title(wv, title=title.cstring)
    webview_set_size(wv, width.cint, height.cint, constraints)
    Webview(view: wv)

method navigateTo*(this: Webview, url: string) {.base.} =
    webview_navigate(this.view, url.cstring)

method show*(this: Webview) {.base.} =
    webview_run(this.view)
    webview_destroy(this.view)