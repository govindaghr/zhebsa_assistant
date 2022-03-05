import 'package:flutter/material.dart';

class Tab3Card extends StatelessWidget {
  const Tab3Card({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final TextStyle textStyle = Theme.of(context).textTheme.headline4;
    return Card(
      color: Colors.white,
      shadowColor: Colors.amber[500],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 5,
          ),
          AppBar(
            title: const Text(
              'རིམ་ལུགས་ཀྱི་སྐོར།',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            backgroundColor: Colors.orange[800],
          ),
          const SizedBox(
            height: 5,
          ),
          AppBar(
            title: const Text(
              'མི་མང་གི་དོན་ལུ་རིམ་ལུགས་བཟོ་མི།',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            backgroundColor: Colors.orange[800],
          ),
          const SizedBox(
            height: 5,
          ),
          AppBar(
            title: const Text(
              'རིམ་ལུགས་ཀྱི་ནང་དོན་བཟོ་མི།',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            backgroundColor: Colors.orange[800],
          ),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}
