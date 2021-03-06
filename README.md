# nim-webview
![License](https://img.shields.io/github/license/drkameleon/nim-webview?style=for-the-badge) ![Language](https://img.shields.io/badge/language-Nim-6A7FC8.svg?style=for-the-badge)   [![Build Status](https://img.shields.io/github/workflow/status/drkameleon/nim-webview/Linux?style=for-the-badge)](https://github.com/drkameleon/nim-webview/actions)

Nim wrapper for Serge Zaitsev's new [Webview](https://github.com/webview/webview).

The purpose of this repo is to support the new version of the webview and replace: https://github.com/oskca/webview. Plus, make a suitable, drop-in replacement for the obsolete version used for [Arturo](https://github.com/arturo-lang/arturo)'s webview component/library.

Ah, I forgot: and all of this without any dependencies or accompanying DLLs whatsoever. You just compile and ship.

## Tested on

- Linux (Ubuntu)
- MacOS
- Windows 10+

## Example

To get an idea of how simple it to use, have a look at our *test.nim*:


```nim
import webview

var wt = newWebview("TEST", "data:text/html, <h1>It worked! Yay!</h1>")
wt.show()
```

## Building

To build the test app, all you have to do is:

```bash
nim c test.nim
```

> 💡 **For Windows:** (aka the elephant in the room) if you're building with MinGW, it would be a better idea to build with `nim c -d:WEBVIEW_NOEDGE test.nim` (but this means that you will be left without all the fancy additions of the newer, Edge-powered version of the Webview library). If you have VCC installed and feel adventurous enough, go with `nim c --cc:vcc test.nim` and pray that it'll work. 🤞 If you want to have a look how I've managed to make it compile on Windows (no big fuss, it took me roughly 1024 tries), have a look at the CI workflow here: https://github.com/drkameleon/nim-webview/blob/main/.github/workflows/windows.yml#L42-L65)

## License

MIT License

Copyright (c) 2022 Yanis Zafirópulos (aka Dr.Kameleon)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
