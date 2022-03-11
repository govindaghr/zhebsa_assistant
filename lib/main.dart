import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'locale/locale_string.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() => runApp(const ZhebsaApp());

class ZhebsaApp extends StatelessWidget {
  const ZhebsaApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      /*Media Queary scale factor to maintain same size across different media */
      builder: (context, widget) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, widget!),
        maxWidth: 1200,
        minWidth: 450,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(450, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
          const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
          const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
        ],
        background: Container(
          color: const Color(0xFFF5F5F5),
        ),
      ),
      title: 'Zhebsa Assistant',
      debugShowCheckedModeBanner: false,
      translations: LocaleString(),
      locale: const Locale('dz', 'BT'),
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        primaryColor: Colors.deepOrange[500],
        primaryColorLight: Colors.deepOrange[300],
        primaryColorDark: const Color(0x00c41c00),
        secondaryHeaderColor: Colors.orange[500],
        //S — Light Orange #ffc947
        //s-Dark Oranhgr ##c66900
      ),
      home: const HomePage(),
    );
  }
}
