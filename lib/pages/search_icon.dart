import 'package:flutter/material.dart';
import 'package:zhebsa_assistant/pages/components/custom_search.dart';

class SearchIcon extends StatelessWidget {
  const SearchIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () =>
                      showSearch(context: context, delegate: CustomSearch()),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(
                          color: Colors.red,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 9.5, top: 1.6),
                        child: Icon(
                          Icons.search_sharp,
                          color: Colors.deepOrange,
                          size: 30.0,
                        ),
                      ),
                      Text(
                        "འཚོལ།",
                        style: Theme.of(context).textTheme.bodyText2?.merge(
                              const TextStyle(
                                  color: Colors.deepOrange, fontSize: 16.0),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
