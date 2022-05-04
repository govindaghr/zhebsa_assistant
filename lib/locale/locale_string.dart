import 'package:get/get.dart';

class LocaleString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'title': 'Zhebsa',
          'favourite': 'Favourite',
          'search': 'Search',
          'about': 'About',
          'wordOfTheDay': 'Word of the Day',
        },
        'dz_BT': {
          'title': 'ཞེ་སའི་ཚིག་མཛོད།',
          'favourite': 'ཞེ་ས་དགའ་ཤོས།',
          'search': 'འཚོལ།',
          'about': 'སྐོར་ལས།',
          'wordOfTheDay': 'ཉིནམ་འདི་གི་ཞེ་ས།',
        },
      };
}
