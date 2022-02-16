import webview

var wt = newWebview("TEST", "data:text/html, <h1>It worked! Yay!</h1>", debug=true)

# proc receiver(seq: cstring, req: cstring, arg: pointer) {.cdecl.} =
#     echo "SEQ: " & $(seq)
#     echo "GOT: " & $(req)
#     echo "arg: " & $(cast[int](arg))

#     wt.webview_return(seq, 0.cint, ($ %*("this is a message")).cstring)

# wt.webview_bind("something", receiver, cast[pointer](666))
wt.show()