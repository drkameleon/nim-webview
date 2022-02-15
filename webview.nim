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

var webviewHeader {.compileTime.} = "webview.h"
{.passC: "-I" & currentSourcePath().substr(0, high(currentSourcePath()) - 4) .}

when defined(linux):
    {.compile("webview.cc","-std=c++11").}
    {.passC: "-DWEBVIEW_GTK=1 " &
             staticExec"pkg-config --cflags gtk+-3.0 webkit2gtk-4.0".}
    {.passL: "-lstdc++ " &
             staticExec"pkg-config --libs gtk+-3.0 webkit2gtk-4.0".}
elif defined(freebsd):
    {.compile("webview.cc","-std=c++11").}
    {.passC: "-DWEBVIEW_GTK=1 " &
             staticExec"pkg-config --cflags gtk3 webkit2-gtk3".}
    {.passL: "-lstdc++ " &
             staticExec"pkg-config --libs gtk3 webkit2-gtk3".}
elif defined(macosx):
    {.compile("webview.cc","-std=c++11").}
    {.passC: "-DWEBVIEW_COCOA=1".}
    {.passL: "-lstdc++ -framework WebKit".}
elif defined(windows):
    when not defined(WEBVIEW_NOEDGE):
        {.compile("webview.cc","/std:c++17 /EHsc").}
        {.passC: "-DWEBVIEW_EDGE=1".}
        {.passL: """/EHsc /std:c++17 "deps\libs\x64\WebView2LoaderStatic.lib" version.lib shell32.lib""".}
    else:
        webviewHeader = "webview_win_old.h"
        {.passC: "-DWEBVIEW_STATIC -DWEBVIEW_IMPLEMENTATION -DWEBVIEW_WINAPI=1".}
        {.passL: "-lole32 -lcomctl32 -loleaut32 -luuid -lgdi32".}

#=======================================
# Types
#=======================================

when not defined(WEBVIEW_NOEDGE):
    static: echo "Compiling with: " & webviewHeader
    type
        Webview* {.header: webviewHeader, importc: "webview_t".} = pointer

        Constraints* = enum
            Default = 0
            Minimum = 1
            Maximum = 2
            Fixed = 3
else:
    type
        WebviewPrivObj  {.importc: "struct webview_priv", header: webviewHeader, bycopy.} = object
        WebviewObj*     {.importc: "struct webview", header: webviewHeader, bycopy.} = object
            url*        {.importc: "url".}: cstring
            title*      {.importc: "title".}: cstring
            width*      {.importc: "width".}: cint
            height*     {.importc: "height".}: cint
            resizable*  {.importc: "resizable".}: cint
            debug*      {.importc: "debug".}: cint
            invokeCb    {.importc: "external_invoke_cb".}: pointer
            priv        {.importc: "priv".}: WebviewPrivObj
            userdata    {.importc: "userdata".}: pointer
        Webview* = ptr WebviewObj

#=======================================
# Function prototypes
#=======================================

when not defined(WEBVIEW_NOEDGE):
    proc webview_create(debug: cint = 0, window: pointer = nil): Webview {.header: webviewHeader, importc.}
    proc webview_destroy(w: Webview) {.header: webviewHeader, importc.}
    proc webview_run(w: Webview) {.header: webviewHeader, importc.}
    proc webview_terminate(w: Webview) {.header: webviewHeader, importc.}
    # webview_dispatch not implemented yet
    proc webview_get_window(w: Webview): pointer {.header: webviewHeader, importc.}
    proc webview_set_title(w: Webview, title: cstring) {.header: webviewHeader, importc.}
    proc webview_set_size(w: Webview, width: cint, height: cint, constraints: Constraints) {.header: webviewHeader, importc.}
    proc webview_navigate(w: Webview, url: cstring) {.header: webviewHeader, importc.}
    proc webview_init(w: Webview, js: cstring) {.header: webviewHeader, importc.}
    proc webview_eval(w: Webview, js: cstring) {.header: webviewHeader, importc.}
    # webview_bind not implemented yet
    # webview_return not implemented yet
else:
    proc webview_init*(w: Webview): cint {.header: webviewHeader, importc.}
    proc webview_loop*(w: Webview; blocking: cint): cint {.header: webviewHeader, importc.}
    proc webview_eval*(w: Webview; js: cstring): cint {.header: webviewHeader, importc.}
    proc webview_inject_css*(w: Webview; css: cstring): cint {.header: webviewHeader, importc.}
    proc webview_set_title*(w: Webview; title: cstring) {.header: webviewHeader, importc.}
    proc webview_set_color*(w: Webview; r,g,b,a: uint8) {.header: webviewHeader, importc.}
    proc webview_set_fullscreen*(w: Webview; fullscreen: cint) {.header: webviewHeader, importc.}
    #proc webview_dialog*(w: Webview; dlgtype: DialogType; flags: cint; title: cstring; arg: cstring; result: cstring; resultsz: csize_t) {.header: webviewHeader, importc.}
    #proc dispatch(w: Webview; fn: pointer; arg: pointer) {.importc: "webview_dispatch", header: "webview.h".}
    proc webview_terminate*(w: Webview) {.header: webviewHeader, importc.}
    proc webview_exit*(w: Webview) {.header: webviewHeader, importc.}
    proc webview_debug*(format: cstring) {.header: webviewHeader, importc.}
    proc webview_print_log*(s: cstring) {.importc: "webview_print_log", header: "webview.h".}
    proc webview*(title: cstring; url: cstring; w: cint; h: cint; resizable: cint): cint {.header: webviewHeader, importc.}

#=======================================
# Wrappers
#=======================================

when not defined(WEBVIEW_NOEDGE):
    proc setSize*(this: Webview, width: int, height: int, constraints: Constraints) =
        webview_set_size(this, width=width.cint, height=height.cint, constraints)

    proc navigateTo*(this: Webview, url: string) =
        webview_navigate(this, url.cstring)

    proc run*(this: Webview) =
        webview_run(this)

    proc inject*(this: Webview, js: string) =
        webview_init(this, js.cstring)

    proc eval*(this: Webview, js: string) =
        webview_eval(this, js.cstring)

    proc terminate*(this: Webview) =
        webview_terminate(this)

proc destroy*(this: Webview) =
    when not defined(WEBVIEW_NOEDGE):
        webview_destroy(this)
    else:
        webview_exit(this)

#=======================================
# Methods
#=======================================

proc newWebview*(title: string, url: string = "", width: int = 640, height: int = 480, constraints = Default, debug=false): Webview =
    when not defined(WEBVIEW_NOEDGE):
        result = webview_create(debug.cint)
        webview_set_title(result, title=title.cstring)
        webview_set_size(result, width.cint, height.cint, constraints)
        if url != @"":
            webview_navigate(result, url.cstring)
    else:
        result = cast[Webview](alloc0(sizeof(WebviewObj)))
        result.title = title.cstring
        result.url = url.cstring
        result.width = width.cint
        result.height = height.cint
        result.resizable = Constraints.cint
        result.debug = debug.cint

proc show*(this: Webview) =
    when not defined(WEBVIEW_NOEDGE):
        this.run()
        this.destroy()
    else:
        while webview_loop(this) == 0:
            discard
        this.destroy()

proc changeTitle*(this: Webview, title: string) =
    webview_set_title(this, title=title.cstring)

proc evaluate*(this: Webview, js: string) =
    webview_eval(this, js.cstring)