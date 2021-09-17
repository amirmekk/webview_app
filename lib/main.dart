import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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

  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackButtonPressed() {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: 'Press the back button again to exit');
        return Future.value(false);
      }
      return Future.value(true);
    }

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(widget.title),
        // ),
        body: WillPopScope(
          onWillPop: _onBackButtonPressed,
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
          ),
        ),
      ),
    );
  }
}
