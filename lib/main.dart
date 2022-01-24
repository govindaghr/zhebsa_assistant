import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() => runApp(const ZhebsaApp());

class ZhebsaApp extends StatelessWidget {
  const ZhebsaApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zhebsa Assistant',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        primaryColor: Colors.deepOrange[500],
        primaryColorLight: Colors.deepOrange[300],
        primaryColorDark: const Color(0x00c41c00),
        secondaryHeaderColor: Colors.orange[500],
        //S — Light Orange #ffc947
        //s-Dark Oranhgr ##c66900
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
