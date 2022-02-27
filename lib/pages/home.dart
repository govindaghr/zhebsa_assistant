import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'favourite.dart';
import 'search_icon.dart';
import 'package:flutter_switch/flutter_switch.dart';
// import '../locale/localeString.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool isSwitched = false;

  // final List locale = [
  //   {'name': 'ENG', 'locale': const Locale('en', 'US')},
  //   {'name': 'DZO', 'locale': const Locale('dz', 'BT')},
  // ];

  updateLanguage(bool val) {
    Locale locale;
    if (val) {
      locale = const Locale('en', 'US');
    } else {
      locale = const Locale('dz', 'BT');
    }
    Get.updateLocale(locale);
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
        actions: [
          FlutterSwitch(
            value: isSwitched,
            activeText: "ENG",
            inactiveText: "DZO",
            inactiveColor: Colors.orangeAccent,
            activeColor: Colors.red,
            showOnOff: true,
            onToggle: (val) {
              setState(() {
                isSwitched = val;
                updateLanguage(isSwitched);
              });
            },
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
        title: Center(
          child: Text('title'.tr), //ཞེ་སའི་ཚིག་མཛོད།
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Center(
          child: TabBar(
            indicatorColor: Colors.white,
            // isScrollable: true,
            labelStyle:
                const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                icon: const Icon(Icons.favorite),
                text: 'favourite'.tr,
              ),
              /* Tab(
              icon: Icon(Icons.schedule),
              text: 'འདས་པའི་འཚོལ།',
            ), */
              Tab(
                icon: const Icon(Icons.search),
                text: 'search'.tr,
              ),
              Tab(
                icon: const Icon(Icons.notifications),
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
        Icon(Icons.person),
      ]),
    );
  }
}
