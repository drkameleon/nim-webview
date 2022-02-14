import webview

var wt: WebviewT
echo "HERE"
doSth()

wt = createWebview()
wt.navigateWebview("data:text/html, <h1>It worked! Yay!</h1>")
wt.runWebview()
wt.destroyWebview()
# 	webview_t w = webview_create(0, NULL);
# 	webview_set_title(w, "Webview Example");
# 	webview_set_size(w, 480, 320, WEBVIEW_HINT_NONE);
# 	webview_bind(w, "myFunc", myFunc, NULL);
# 	webview_navigate(w, "data:text/html, <button onclick='myFunc(\"Foo bar\")'>Click Me</button>");
# 	webview_run(w);
# 	webview_destroy(w);