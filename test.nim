import webview

var wt: WebviewT

wt = createWebview()
wt.navigateWebview("data:text/html, <h1>It worked! Yay!</h1>")
wt.runWebview()
wt.destroyWebview()