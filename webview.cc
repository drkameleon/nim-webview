// Linux
// CPPFLAGS="`pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.0` -lstdc++"
// MacOS
// CPPFLAGS="-std=c++11 -framework WebKit"
// Windows (x64)
// CPPFLAGS="-mwindows -L./dll/x64 -lwebview -lWebView2Loader"
//
// g++ -c -std=c++11 -framework WebKit webview.cc -o webview.o

#include "webview.h"