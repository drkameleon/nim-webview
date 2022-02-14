import webview

var wt: WebviewT

wt = createWebview()
wt.setWebviewTitle("TEST")
wt.setWebviewSize(400,300,0)
wt.navigateWebview("data:text/html, <h1>It worked! Yay!</h1>")
wt.runWebview()
wt.destroyWebview()