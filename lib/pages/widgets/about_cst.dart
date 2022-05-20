import 'package:flutter/material.dart';

class AboutCST extends StatelessWidget {
  const AboutCST({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.white,
      shadowColor: Colors.amber[500],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(5.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.orange[800],
              border: Border.all(
                color: Colors.amber.shade100,
                width: 2,
              ),
            ),
            child: const Center(
              child: Text(
                'རིམ་ལུགས་ཀྱི་མཉམ་འབྲེལ་ཚོང་རོགས།',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.only(bottom: 10),
                height: 150,
                width: 150,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset('assets/images/cst_logo.png'),
              ),
              const Expanded(
                child: Text(
                  '''ཚན་རིག་དང་འཕྲུལ་རིག་མཐོ་རིམ་སློབ་གྲྭ། \nwww.cst.edu.bt \nitd.cst@rub.edu.bt
                  ''',
                  // overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
