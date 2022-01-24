import 'package:flutter/material.dart';
import 'package:zhebsa_assistant/pages/components/custom_search.dart';

class SearchIcon extends StatelessWidget {
  const SearchIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The search area here
        title: SizedBox(
          width: double.infinity,
          height: 40.0,
          // decoration: BoxDecoration(
          //     color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
              child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search_sharp),
                onPressed: () =>
                    showSearch(context: context, delegate: CustomSearch()),
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (_) => const SearchPage())),
              ),
              const Text('Search'),
            ],
          )),
        ),
      ),
    );
  }
}
