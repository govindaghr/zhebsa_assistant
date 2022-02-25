import 'package:flutter/material.dart';
import 'favourite.dart';
import 'search_icon.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: const Center(
          child: Text('ཞེ་སའི་ཚིག་མཛོད།'),
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
            indicatorColor: Colors.deepOrange,
            // isScrollable: true,
            labelStyle:
                const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                icon: Icon(Icons.favorite),
                text: 'ཞེ་ས་དགའ་ཤོས།',
              ),
              /* Tab(
              icon: Icon(Icons.schedule),
              text: 'འདས་པའི་འཚོལ།',
            ), */
              Tab(
                icon: Icon(Icons.search),
                text: 'འཚོལ།',
              ),
              Tab(
                icon: Icon(Icons.notifications),
                // text: 'ཁྱབ་བསྒྲགས།',
                text: 'About',
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
