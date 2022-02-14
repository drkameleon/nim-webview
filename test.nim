import webview

var wt: Webview = newWebview("TEST", 400, 400)
wt.navigateTo("data:text/html, <h1>It worked! Yay!</h1>")
wt.show()