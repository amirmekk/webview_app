import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime? currentBackPressTime;
  bool _isLoading = false;
  late WebViewController _controller;
  double progress = 0;

  final Completer<WebViewController> _completerController =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  Future<bool> _goBack(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      //switch leave or stay in the app in case there is no history to go back to
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => _goBack(context),
        child: Scaffold(
          appBar: AppBar(
            // add title if wanted
            //title: Text("Flutter"),
            leading: IconButton(
                onPressed: () async {
                  if (await _controller.canGoBack()) {
                    _controller.goBack();
                  }
                },
                icon: Icon(Icons.arrow_back_ios)),
            actions: [
              IconButton(
                onPressed: () {
                  _controller.reload();
                },
                icon: Icon(
                  Icons.refresh,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              progress == 1
                  ? SizedBox()
                  : LinearProgressIndicator(value: progress),
              Expanded(
                child: WebView(
                  onPageStarted: (url) {
                    setState(() {
                      _isLoading = true;
                    });
                  },
                  onPageFinished: (url) {
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  initialUrl: 'https://flutter.dev',
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _completerController.future
                        .then((value) => _controller = value);
                    _completerController.complete(webViewController);
                  },
                  onProgress: (p) {
                    setState(() {
                      this.progress = p / 100;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
