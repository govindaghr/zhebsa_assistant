import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'favourite.dart';
import 'search_icon.dart';
import 'notification.dart';
import 'package:flutter_switch/flutter_switch.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
        title: 'Zhebsa Assistant',
        text: 'Zhebsa Assistant',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title');
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('title'.tr), //ཞེ་སའི་ཚིག་མཛོད།
        ),
        actions: [
          FlutterSwitch(
            width: 80.0,
            height: 30.0,
            value: isSwitched,
            activeText: "ENG",
            inactiveText: "DZO",
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
          /* ToggleSwitch(
            // minWidth: 90.0,
            // cornerRadius: 20.0,
            minHeight: 20,
            activeBgColors: [
              [Colors.green[800]!],
              [Colors.red[800]!]
            ],
            // activeFgColor: Colors.white,
            // inactiveBgColor: Colors.grey,
            // inactiveFgColor: Colors.white,
            initialLabelIndex: 1,
            totalSwitches: 2,
            labels: const ['True', 'False'],
            // radiusStyle: true,
            onToggle: (index) {
              print('switched to: $index');
            },
          ), */
        ],
        /* bottom: TabBar(
          // indicatorColor: Color(0xfffffffe),
          isScrollable: true,
          labelStyle:
              const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.favorite),
              text: 'ཞེ་ས་དགའ་ཤོས།',
            ),
            Tab(
              icon: Icon(Icons.schedule),
              text: 'འདས་པའི་འཚོལ།',
            ),
            Tab(
              icon: Icon(Icons.search),
              text: 'འཚོལ།',
            ),
            Tab(
              icon: Icon(Icons.notifications),
              // text: 'ཁྱབ་བསྒྲགས།',
              text: 'About',
            ),
            // ElevatedButton(
            //   onPressed: () => Navigator.of(context)
            //       .push(MaterialPageRoute(builder: (_) => const SearchPage())),
            //   child: Column(
            //     children: const <Widget>[Icon(Icons.ac_unit), Text("Search")],
            //   ),
            // ),
          ],
        ), */
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepOrange,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
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
            // isScrollable: true,
            /* labelPadding: EdgeInsets.zero,
            padding: const EdgeInsets.all(0.0),
            indicator: BoxDecoration(
              border: Border.all(width: 1),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey[600],
            ), */

            labelStyle: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                icon: const Icon(Icons.favorite_outline),
                text: 'favourite'.tr,
              ),
              /* Tab(
              icon: Icon(Icons.schedule),
              text: 'འདས་པའི་འཚོལ།',
            ), */
              Tab(
                icon: const Icon(Icons.search_outlined),
                text: 'search'.tr,
              ),
              Tab(
                icon: const Icon(Icons.info_outline),
                // text: 'ཁྱབ་བསྒྲགས།',
                text: 'about'.tr,
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(controller: _tabController, children: const <Widget>[
        FavouritePage(),
        // Icon(Icons.directions_transit),
        SearchIcon(),
        // Icon(Icons.person),
        Tab3Card(),
      ]),
    );
  }
}
