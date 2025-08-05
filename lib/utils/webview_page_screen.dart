import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ridebooking/utils/app_colors.dart';
import 'package:ridebooking/utils/app_theme.dart';
import 'package:ridebooking/utils/app_typography.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPagesScreen extends StatefulWidget {
  String title = '', url = '', body = '';

  WebViewPagesScreen(
      {super.key,
      required String titleMain,
      required String urlToLoad,
      required String bodyTags}) {
    title = titleMain;
    url = urlToLoad;
    body = bodyTags;
  }

  @override
  State<WebViewPagesScreen> createState() => _WebViewPagesScreenState();
}

class _WebViewPagesScreenState extends State<WebViewPagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        // appBar: AppBar(
        //   // leading: IconButton(
        //   //     icon: Container(
        //   //       width: 30, //MediaQuery.of(context).size.width * 0.09,
        //   //       height: 30, //MediaQuery.of(context).size.height * 0.09,
        //   //       padding: EdgeInsets.fromLTRB(5, 5, 2, 5),
        //   //       child: SvgPicture.asset("assets/images/arrow-back.svg",
        //   //           colorFilter: ColorFilter.mode(
        //   //               AppTheme.appBarTextColor!, BlendMode.srcIn)),
        //   //     ),
        //   //     onPressed: () {
        //   //       Navigator.of(context).pop();
        //   //     }),
        //   title: Text(title,
        //       style: TextStyle(
        //           fontSize: 20,
        //           fontWeight: FontWeight.bold,
        //           color: Colors.black)),
        // ),
        body: WebViewPagesScreenBody(
          titleMain: widget.title,
          bodyTags: widget.body,
          urlToLoad: widget.url,
        ));
  }
}

class WebViewPagesScreenBody extends StatefulWidget {
  String title = '', url = '', body = '';
  bool isLoading = true;
  WebViewPagesScreenBody(
      {super.key,
      required String titleMain,
      required String urlToLoad,
      required String bodyTags}) {
    title = titleMain;
    url = urlToLoad;
    body = bodyTags;
  }

  @override
  State<WebViewPagesScreenBody> createState() => _WebViewPagesScreenBodyState();
}

class _WebViewPagesScreenBodyState extends State<WebViewPagesScreenBody> {
  late final WebViewController _controller;
  late WebViewController webViewControllerr;
  bool urlAndBodyNotFound = false;

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

    // Remove elements by class name and tag   class ==>Bottom bar widget
    
   
   var siteHeaders = document.getElementsByClassName('multicolumn color-scheme-3 gradient background-none no-heading');
    var headings = document.getElementsByTagName('div');
    
    Array.from(siteHeaders).forEach(function(siteHeader) {
      Array.from(headings).forEach(function(heading) {
        if (siteHeader === heading) {
          siteHeader.style.display = 'none';
        }
      });
    });


//class ==>uai userway_dark  

    var userway = document.getElementsByClassName('uai userway_dark');
    var userwayDiv = document.getElementsByTagName('div');
    
    Array.from(userway).forEach(function(userway) {
      Array.from(userwayDiv).forEach(function(userwayDiv) {
        if (userway === userwayDiv) {
          userway.style.display = 'none';
        }
      });
    });


//class===>>swym-inject swym-ready

    var heart = document.getElementsByClassName('swym-inject swym-ready');
  var heartDiv = document.getElementsByTagName('div');

    Array.from(heart).forEach(function(heart) {
      Array.from(heartDiv).forEach(function(heartDiv) {
        if (heart === heartDiv) {
          heart.style.display = 'none';
        }
      });
    });


//Rewards smile-ui-lite-launcher-frame-container

 var rewards = document.getElementsById('smile-ui-lite-launcher-frame-container');
 rewards.style.display = 'none';
  var rewardsDiv = document.getElementsByTagName('div');

    Array.from(rewards).forEach(function(rewards) {
      Array.from(rewardsDiv).forEach(function(rewardsDiv) {
        if (rewards === rewardsDiv) {
          rewards.style.display = 'none';
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
            print("--------------start ${url}");
          },
          onPageFinished: (String url) {
            setState(() {
              widget.isLoading = false;
            });
            print("--------------start ${url}");
          },
          // onWebResourceError: (WebResourceError error) {
          // LoadingDialog.hide(context);
          // Dialogs.ErrorAlertInOut(
          //     context: context,
          //     message:
          //         "Error page not found" //AppLocalizations.of(context)!.errorpagenotfound
          //     );
          // },
          // onNavigationRequest: (NavigationRequest request) async {
          //   print("-------asd-------${request.url}");
          //   if (request.url.contains("products")) {
          //     final lastSegment = extractLastSegment(request.url);
          //     print(request.url +
          //         "--------------navigation print " +
          //         lastSegment);
          // widget.onClick.call(lastSegment);

          //   ProductDetailsScreen productDetailsScreen =
          //       ProductDetailsScreen(lastSegment);

          //   _controller.setJavaScriptMode(JavaScriptMode.disabled);
          //   context.push("${RouteGenerate.productDetailsScreen}",
          //       extra: productDetailsScreen);
          //   return NavigationDecision.prevent;
          // } else if (request.url.contains("collections")) {
          //   final handle = extractLastSegment(request.url);
          //   print(request.url + "--------------navigation print " + handle);
          //   ProductListScreen productListScreen =
          //       ProductListScreen(handle, "");
          //   _controller.setJavaScriptMode(JavaScriptMode.disabled);
          //   context.push("${RouteGenerate.productListScreen}",
          //       extra: productListScreen);
          //   return NavigationDecision.prevent;
          // } else {
          //   return NavigationDecision.navigate;
          // }
          // },
        ),
      );
    print(
        "-------------------------------------------url------------------------------ ${url}");
    widget.body.isNotEmpty ? _controller.loadHtmlString("""
      <!DOCTYPE html>
        <html>
          <head>
          <link rel="preconnect" href="https://fonts.googleapis.com">
          <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
          <link href="https://fonts.googleapis.com/css2?family=${AppTypography.textTheme}&display=swap" rel="stylesheet">
          <meta name="viewport" content="width=device-width, initial-scale=0.8">
           <style>
           .change
            {
            font-family: '${AppTypography.textTheme}', serif;
            }
             </style> 
            </head>
           <body class="change" style="margin: 0; padding: 0; color: #${AppColors.primaryBlue};">
            ${widget.body}
          </body>
        </html>
      """) : _controller.loadRequest(Uri.parse(url));

    webViewControllerr = _controller;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      // style:,
                    ))
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
                          ))
                      : Expanded(
                          child: WebViewWidget(
                          controller: _controller,
                        ))
            ]));
  }

  String extractLastSegment(String url) {
    final segments = Uri.parse(url).pathSegments;
    return segments.isNotEmpty ? segments.last : '';
  }
}
