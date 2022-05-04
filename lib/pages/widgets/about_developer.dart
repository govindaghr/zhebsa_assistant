import 'package:flutter/material.dart';

class AboutDeveloper extends StatelessWidget {
  const AboutDeveloper({Key? key}) : super(key: key);

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
                'རིམ་ལུངས་བཟོ་མི།།',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.only(bottom: 10),
                height: 150,
                width: 150,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset('assets/images/developer.png'),
              ),
              const Expanded(
                child: Text(
                  '''Developed as Final year project by: \n\t 1. Karma Tenzin \n\t 2. Sonam Lhamo \n\t 3. Govinda Ghimeray \n\t 4. Mr. Pema Galey''',
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
