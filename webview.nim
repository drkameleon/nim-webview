######################################################
# nim-webview
# New-style Zaitsev's webview wrapper
# for Nim
#
# (c) 2022 Yanis Zafirópulos
# 
# @license: see LICENSE file
# @file: nim-webview.nim
######################################################

#=======================================
# Compilation & Linking
#=======================================

{.passC: "-I" & currentSourcePath().substr(0, high(currentSourcePath()) - 4) .}
{.passL: "-lstdc++".}

when defined(linux):
    {.compile("webview.cc","-std=c++11").}
    {.passC: "-DWEBVIEW_GTK=1 " &
             staticExec"pkg-config --cflags gtk+-3.0 webkit2gtk-4.0".}
    {.passL: staticExec"pkg-config --libs gtk+-3.0 webkit2gtk-4.0".}
elif defined(freebsd):
    {.compile("webview.cc","-std=c++11").}
    {.passC: "-DWEBVIEW_GTK=1 " &
             staticExec"pkg-config --cflags gtk3 webkit2-gtk3".}
    {.passL: staticExec"pkg-config --libs gtk3 webkit2-gtk3".}
elif defined(macosx):
    {.compile("webview.cc","-std=c++11").}
    {.passC: "-DWEBVIEW_COCOA=1".}
    {.passL: "-framework WebKit".}
elif defined(windows):
    {.compile("webview.cc","/std:c++17").}
    {.passC: "-DWEBVIEW_EDGE=1".}
    {.passL: "-mwindows -L./dll/x64 -lwebview -lWebView2Loader".}

#=======================================
# Types
#=======================================
    
type
    webview_t {.header: "webview.h", importc.} = pointer
    
    Webview* = ref object of RootObj
        view: webview_t

    Constraints* = enum
        Default = 0
        Minimum = 1
        Maximum = 2
        Fixed = 3

#=======================================
# Function prototypes
#=======================================

proc webview_create(debug: cint = 0, window: pointer = nil): webview_t {.header: "webview.h", importc.}
proc webview_destroy(w: webview_t) {.header: "webview.h", importc.}
proc webview_run(w: webview_t) {.header: "webview.h", importc.}
proc webview_terminate(w: webview_t) {.header: "webview.h", importc.}
# webview_dispatch not implemented yet
proc webview_get_window(w: webview_t): pointer {.header:"webview.h", importc.}
proc webview_set_title(w: webview_t, title: cstring) {.header: "webview.h", importc.}
proc webview_set_size(w: webview_t, width: cint, height: cint, constraints: Constraints) {.header: "webview.h", importc.}
proc webview_navigate(w: webview_t, url: cstring) {.header: "webview.h", importc.}
proc webview_init(w: webview_t, js: cstring) {.header: "webview.h", importc.}
proc webview_eval(w: webview_t, js: cstring) {.header: "webview.h", importc.}
# webview_bind not implemented yet
# webview_return not implemented yet

#=======================================
# Main methods
#=======================================

proc newWebview*(title: string, width: int, height: int, constraints = Default, debug=false): Webview =
    var w = webview_create(debug.cint)
    webview_set_title(w, title=title.cstring)
    webview_set_size(w, width.cint, height.cint, constraints)
    Webview(view: w)

method setTitle*(this: Webview, title: string) {.base.} =
    webview_set_title(this.view, title=title.cstring)

method setSize*(this: Webview, width: int, height: int, constraints: Constraints) =
    webview_set_size(this.view, width=width.cint, height=height.cint, constraints)

method navigateTo*(this: Webview, url: string) {.base.} =
    webview_navigate(this.view, url.cstring)

method run*(this: Webview) {.base.} =
    webview_run(this.view)

method inject*(this: Webview, js: string) {.base} =
    webview_init(this.view, js.cstring)

method eval*(this: Webview, js: string) {.base} =
    webview_eval(this.view, js.cstring)

method terminate*(this: Webview) {.base.} =
    webview_terminate(this.view)

method destroy*(this: Webview) {.base.} =
    webview_destroy(this.view)

method show*(this: Webview) {.base.} =
    this.run()
    this.destroy()