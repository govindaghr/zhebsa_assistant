import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:zhebsa_assistant/pages/components/loading_indicator.dart';
import 'package:zhebsa_assistant/pages/load_favourite.dart';
import 'package:zhebsa_assistant/api/zhesa_provider.dart';
import 'package:zhebsa_assistant/pages/search_icon.dart';
import 'package:zhebsa_assistant/pages/about_us.dart';
import 'package:zhebsa_assistant/pages/drawer/drawer_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final ZhesaAPIProvider _zhesaAPIProvider = ZhesaAPIProvider();

  bool isSwitched = false;

  updateLanguage(bool val) {
    Locale locale;
    if (val) {
      locale = const Locale('en', 'US');
    } else {
      locale = const Locale('dz', 'BT');
    }
    Get.updateLocale(locale);
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Zhesa',
        text: 'Zhesa Learning App',
        linkUrl:
            'https://play.google.com/store/apps/details?id=com.zhesa.zhebsa_assistant',
        chooserTitle: 'Zhesa Learning App');
  }

  // ZhesaProvider zhesaProvider;
  Future<void> syncData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
      LoadingIndicatorDialog().show(context);
      await _zhesaAPIProvider.getAllZhesa(context);
      await _zhesaAPIProvider.getAllDzongkha(context);
      await _zhesaAPIProvider.getAllZhesaDzongkha(context);
      LoadingIndicatorDialog().dismiss();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error! Internet connection required'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    // DatabaseService().showWordOfDay();
    // syncData();
  }

  void displayDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Synchronize New Data?'),
          content: const Text(
              'Please note that it will consume your additional memory and internet data.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                syncData();
              },
              child: const Text('ACCEPT'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarTextStyle: const TextStyle(fontWeight: FontWeight.bold),
        title: Center(
          child: Text(
            'title'.tr,
            // style: const TextStyle(fontWeight: FontWeight.w600),
          ), //ཞེ་སའི་ཚིག་མཛོད།
        ),
        actions: [
          FlutterSwitch(
            width: 80.0,
            height: 35.0,
            value: isSwitched,
            // valueFontSize: 14,
            activeText: "DZO",
            inactiveText: "ENG",
            inactiveColor: Colors.red.shade600,
            activeColor: Colors.red,
            showOnOff: true,
            onToggle: (val) {
              setState(() {
                isSwitched = val;
                updateLanguage(isSwitched);
              });
            },
          ),
          IconButton(
            onPressed: share,
            icon: const Icon(Icons.share),
          ),
          /* IconButton(
            onPressed: (() {
              displayDialog();
            }), //syncData,
            icon: const Icon(Icons.cloud_sync_outlined),
          ), */
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const MyHeaderDrawer(),
            const SizedBox(
              height: 20.0,
            ),
            ListTile(
              title: Text('favourite'.tr),
              leading: Icon(
                Icons.favorite_border,
                color: Colors.red[500],
              ),
              onTap: () {
                _tabController.index = 0;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('search'.tr),
              leading: Icon(
                Icons.search_rounded,
                color: Colors.red[500],
              ),
              onTap: () {
                _tabController.index = 1;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('about'.tr),
              leading: Icon(
                Icons.info_outline,
                color: Colors.red[500],
              ),
              onTap: () {
                _tabController.index = 2;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('share'.tr),
              leading: Icon(
                Icons.share,
                color: Colors.red[500],
              ),
              onTap: () {
                share();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sync'),
              leading: Icon(
                Icons.cloud_sync_outlined,
                color: Colors.red[500],
              ),
              onTap: () {
                displayDialog();
                // Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.zero,
        height: 70,
        decoration: BoxDecoration(
          // color: Theme.of(context).cardColor,
          color: Colors.amber.shade50,
          // color: Colors.black12,
          border: Border.all(
            color: Colors.amber.shade100,
            // color: Colors.white30,
            width: 2,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Center(
          child: TabBar(
            // dragStartBehavior: null,
            indicatorColor: Colors.orange.shade800,
            indicatorWeight: 3.0,
            labelColor: Colors.deepOrange,
            unselectedLabelColor: Colors.black54,

            labelStyle: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              // fontFamily: 'Uchen',
            ),
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                iconMargin: EdgeInsets.zero,
                icon: const Icon(Icons.favorite_outline),
                text: 'favourite'.tr,
              ),
              Tab(
                iconMargin: EdgeInsets.zero,
                icon: const Icon(Icons.search_outlined),
                text: 'search'.tr,
              ),
              Tab(
                iconMargin: EdgeInsets.zero,
                icon: const Icon(Icons.info_outline),
                text: 'about'.tr,
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(controller: _tabController, children: const <Widget>[
        // FavouritePage(),
        Favourite(),
        SearchIcon(),
        AboutUs(),
      ]),
    );
  }
}
