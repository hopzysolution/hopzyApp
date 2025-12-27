import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WebViewPagesScreen extends StatelessWidget {
  String title = '', url = '', body = '';

  WebViewPagesScreen({
    super.key,
    required String titleMain,
    required String urlToLoad,
    required String bodyTags,
  }) {
    title = titleMain;
    url = urlToLoad;
    body = bodyTags;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // appBar: AppBar(title: Text(title)),
      body: WebViewPagesScreenBody(
        titleMain: title,
        bodyTags: body,
        urlToLoad: url,
      ),
    );
  }
}

class WebViewPagesScreenBody extends StatefulWidget {
  String title = '', url = '', body = '';
  bool isLoading = true;


  WebViewPagesScreenBody({
    super.key,
    required String titleMain,
    required String urlToLoad,
    required String bodyTags,
  }) {
    title = titleMain;
    url = urlToLoad;
    body = bodyTags;
  }

  @override
  State<WebViewPagesScreenBody> createState() => _WebViewPagesScreenBodyState();
}

class _WebViewPagesScreenBodyState extends State<WebViewPagesScreenBody> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late final WebViewController _controller;
  late WebViewController webViewControllerr;
  bool urlAndBodyNotFound = false;
  bool isUpiUrl(String url) {
    url = url.toLowerCase();

    return url.startsWith("upi:")
        || url.startsWith("upi://")
        || url.startsWith("intent:")
        || url.contains("upi/pay")
        || url.contains("paytm")
        || url.contains("phonepe")
        || url.contains("gpay")
        || url.contains("tez");
  }


  @override
  void initState() {
    super.initState();
    debugPrint("------widget.url........${widget.url}");
    webViewManager(widget.url);
    if (widget.url.isEmpty && widget.body.isEmpty) {
      urlAndBodyNotFound = true;
      setState(() {});
    }
  }

  // loading website url
  // Future<void> webViewManager(String url) async {
  //   _controller = WebViewController()
  //     ..enableZoom(false)
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..setBackgroundColor(const Color(0x00000000));
  //
  //   // ✅ 1. Restore token BEFORE loading anything
  //
  //
  //   // ✅ 2. Navigation delegate
  //   _controller.setNavigationDelegate(
  //     NavigationDelegate(
  //       onPageStarted: (_) {
  //         setState(() => widget.isLoading = true);
  //       },
  //
  //       onPageFinished: (url) async {
  //         if (!mounted) return;
  //
  //         setState(() => widget.isLoading = false);
  //
  //         try {
  //           // ✅ If redirected to login, clear token immediately
  //           if (url.contains('/login')) {
  //             await _secureStorage.delete(key: 'accessToken');
  //             debugPrint("🔓 accessToken cleared (login page)");
  //             return;
  //           }
  //
  //           // ✅ Read accessToken safely from WebView
  //           final result = await _controller.runJavaScriptReturningResult("""
  //     (function() {
  //       try {
  //         return localStorage.getItem('accessToken');
  //       } catch (e) {
  //         return null;
  //       }
  //     })();
  //   """);
  //
  //           // ✅ Normalize result
  //           String? token;
  //           if (result is String && result.isNotEmpty && result != 'null') {
  //             token = result.replaceAll('"', '');
  //           }
  //
  //           // ✅ Validate token before saving
  //           if (token != null && token.length > 10) {
  //             final existingToken = await _secureStorage.read(key: 'accessToken');
  //
  //             // Save only if changed
  //             if (existingToken != token) {
  //               await _secureStorage.write(
  //                 key: 'accessToken',
  //                 value: token,
  //               );
  //               debugPrint("✅ accessToken captured & stored");
  //             }
  //           }
  //         } catch (e) {
  //           // Never crash WebView for token issues
  //           debugPrint("⚠️ accessToken read error: $e");
  //         }
  //       },
  //
  //
  //       onNavigationRequest: (request) async {
  //         final reqUrl = request.url;
  //
  //         if (reqUrl.startsWith("upi:") ||
  //             reqUrl.contains("paytm") ||
  //             reqUrl.contains("phonepe") ||
  //             reqUrl.contains("gpay") ||
  //             reqUrl.contains("upi/pay")) {
  //           try {
  //             final uri = Uri.parse(reqUrl);
  //             if (await canLaunchUrl(uri)) {
  //               await launchUrl(uri, mode: LaunchMode.externalApplication);
  //             }
  //           } catch (_) {}
  //           return NavigationDecision.prevent;
  //         }
  //
  //         return NavigationDecision.navigate;
  //       },
  //     ),
  //   );
  //
  //   // ✅ 3. Load page LAST
  //   if (widget.body.isNotEmpty) {
  //     await _controller.loadHtmlString(widget.body);
  //   } else {
  //     await _controller.loadRequest(Uri.parse(url));
  //   }
  //
  //   webViewControllerr = _controller;
  // }

  Future<void> webViewManager(String url) async {
    _controller = WebViewController()
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))

      ..setNavigationDelegate(
        NavigationDelegate(
          // onProgress: (int progress) {
          //   // Update loading bar.
          // },
          onPageStarted: (String url) {
            setState(() {
              widget.isLoading = true;
            });
            print("----------------->>>>SECTION REMOVER>>>>>${url}");
            _controller.runJavaScript("""
  function removeElements() {
    // Remove elements by tag name
    var headers = document.getElementsByTagName('header');
    for (var i = 0; i < headers.length; i++) {
      headers[i].style.display = 'none';
    }

    var footers = document.getElementsByTagName('footer');
    for (var i = 0; i < footers.length; i++) {
      footers[i].style.display = 'none';
    }

    // Remove elements by class name and tag


   var siteHeaders = document.getElementsByClassName('sc-kqGpvY nmGRv pf-41_ pf-color-scheme-1');
    var headings = document.getElementsByTagName('div');

    Array.from(siteHeaders).forEach(function(siteHeader) {
      Array.from(headings).forEach(function(heading) {
        if (siteHeader === heading) {
          siteHeader.style.display = 'none';
        }
      });
    });


  }

  var interval = setInterval(function() {
    removeElements();
  }, 10);
   setTimeout(function() {
    clearInterval(interval);
  }, 5000);

""");
            print("--------------starting1 ${url}");
          },
          onPageFinished: (String url) async {
            if (!mounted) return;

            setState(() {
              widget.isLoading = false;
            });

            // 🔐 Flutter-only token capture (NO website change)
            try {
              // If redirected to login → clear token
              if (url.contains('/login')) {
                await _secureStorage.delete(key: 'accessToken');
                debugPrint("🔓 accessToken cleared (login page)");
                return;
              }

              final result = await _controller.runJavaScriptReturningResult("""
      (function() {
        try {
          return localStorage.getItem('accessToken');
        } catch (e) {
          return null;
        }
      })();
    """);

              if (result is String && result.isNotEmpty && result != 'null') {
                final token = result.replaceAll('"', '');

                if (token.length > 10) {
                  final existingToken =
                  await _secureStorage.read(key: 'accessToken');

                  // Save only if changed
                  if (existingToken != token) {
                    await _secureStorage.write(
                      key: 'accessToken',
                      value: token,
                    );
                    debugPrint("✅ accessToken captured & stored");
                  }
                }
              }
            } catch (e) {
              // Never crash WebView
              debugPrint("⚠️ accessToken read error: $e");
            }
          },


          // onWebResourceError: (WebResourceError error) {
          // LoadingDialog.hide(context);
          // Dialogs.ErrorAlertInOut(
          //     context: context,
          //     message:
          //         "Error page not found" //AppLocalizations.of(context)!.errorpagenotfound
          //     );
          // },
          onNavigationRequest: (NavigationRequest request) async {
            debugPrint("Inside url testing");
            final String reqUrl = request.url;
            // ✅ Handle UPI / PayTM / PhonePe / GPay links
            if (reqUrl.startsWith("upi:") ||
                reqUrl.startsWith("upi://") ||
                reqUrl.contains("paytm") ||
                reqUrl.contains("phonepe") ||
                reqUrl.contains("gpay") ||
                reqUrl.contains("tez") ||
                reqUrl.contains("upi/pay")) {
              debugPrint("requrl is ${reqUrl}");

              try {
                Uri uri = Uri.parse(reqUrl);
                debugPrint("parsed uri is ${uri}");

                if (await canLaunchUrl(uri)) {
                  debugPrint("can launch url");
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  debugPrint("cannot launch url");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("No UPI app found")),
                  );
                }
              } catch (e) {
                debugPrint("UPI Launch Error: $e");
              }
              debugPrint("stopping launch url");
              return NavigationDecision.prevent;
            }
            print("-------asd-------${request.url}");
            if (request.url.contains("products")) {
              final lastSegment = extractLastSegment(request.url);
              print(
                request.url + "--------------navigation print " + lastSegment,
              );
              // ProductDetailsScreen productDetailsScreen = ProductDetailsScreen(
              //   lastSegment,
              // );

              // _controller.setJavaScriptMode(JavaScriptMode.disabled);
              // context.push(
              //   "/${Routes.productDetailsScreen}",
              //   extra: productDetailsScreen,
              // );
              return NavigationDecision.prevent;
            } else if (request.url.contains("collections")) {
              // final handle = extractLastSegment(request.url);
              // print(request.url + "--------------navigation print " + handle);
              // ProductListScreen productListScreen = ProductListScreen(
              //   handle,
              //   "",
              // );
              // _controller.setJavaScriptMode(JavaScriptMode.disabled);
              // context.push(
              //   "/${Routes.productListScreen}",
              //   extra: productListScreen,
              // );
              return NavigationDecision.prevent;
            } else {
              return NavigationDecision.navigate;
            }
          },
          //new
          // onNavigationRequest: (NavigationRequest request) async {
          //   debugPrint("Inside url testing");
          //   final url = request.url;
          //
          //   if (isUpiUrl(url)) {
          //     try {
          //       String fixedUrl = url.replaceAll("intent://", "upi://");
          //       final uri = Uri.parse(fixedUrl);
          //
          //       if (await canLaunchUrl(uri)) {
          //         await launchUrl(uri, mode: LaunchMode.externalApplication);
          //       }
          //     } catch (e) {
          //       debugPrint("UPI Intent Error: $e");
          //     }
          //
          //     return NavigationDecision.prevent;
          //   }
          //
          //   return NavigationDecision.navigate;
          // },
          // onUrlChange: (change) async {
          //   final url = change.url ?? "";
          //   print("URL Changed: $url");
          //
          //   if (isUpiUrl(url)) {
          //     String fixedUrl = url.replaceAll("intent://", "upi://");
          //     await launchUrl(Uri.parse(fixedUrl), mode: LaunchMode.externalApplication);
          //   }
          // },

        ),
      );
    print(
      "-------------------------------------------url------------------------------ ${url}",
    );
    widget.body.isNotEmpty
        ? _controller.loadHtmlString("""
      <!DOCTYPE html>
        <html>
          <head>
          <link rel="preconnect" href="https://fonts.googleapis.com">
          <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
          <link href="https://fonts.googleapis.com/css2?display=swap" rel="stylesheet">
          <meta name="viewport" content="width=device-width, initial-scale=0.8">
           <style>
           .change
            {
            }
             </style>
            </head>
           <body class="change"
           style="margin: 0; padding: 0;"
           >
            ${widget.body}
          </body>
        </html>
      """)
        : _controller.loadRequest(Uri.parse(url));

    webViewControllerr = _controller;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if(await _controller.canGoBack()){
          _controller.goBack();
          return false;
        }
        return true;
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: widget.body.isEmpty ? EdgeInsets.all(0) : EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: urlAndBodyNotFound
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            (urlAndBodyNotFound)
                ? Center(
                    child: Text(
                      "Not Found",
                    ),
                  )
                : widget.isLoading
                ? Container(
                    margin: EdgeInsets.only(top: 0, bottom: 10),
                    alignment: Alignment.bottomCenter,
                    width: MediaQuery.of(context).size.width,
                    height: 4,
                    child: LinearProgressIndicator(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.black,
                      backgroundColor: Colors.white,
                    ),
                  )
                : Expanded(child: RefreshIndicator(
              onRefresh: ()async=>_controller.reload(),
                child: WebViewWidget(controller: _controller))),
          ],
        ),
      ),
    );
  }

  String extractLastSegment(String url) {
    final segments = Uri.parse(url).pathSegments;
    return segments.isNotEmpty ? segments.last : '';
  }
}
