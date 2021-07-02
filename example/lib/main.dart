import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_union_pay/flutter_union_pay.dart';
import 'package:flutter_union_pay/enum/union_pay_enum.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterUnionPay.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

    FlutterUnionPay.listen((result) {
      showDialog(
        context: context,
        child: SimpleDialog(
          title: Text('TEST'),
          children: [
            Text(result.status.toString()),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FlutterUnionPay.pay(
              tn: "879155096764620468515",
              mode: PaymentMode.product,
              scheme: "UnionPayExample",
            ).then((value) {
              print("##########$value");
            });
          },
          child: Icon(Icons.payment),
        ),
        appBar: AppBar(
          title: const Text('Plugin Example App'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            Builder(builder: (context) {
              return TextButton(
                onPressed: () {
                  FlutterUnionPay.isPaymentAppInstalled.then((value) {
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text(value.toString())));
                  });
                },
                child: Text('Check Payment App Installed'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
