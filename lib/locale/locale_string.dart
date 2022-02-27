import 'package:get/get.dart';

class LocaleString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'title': 'Zhebsa Assistant',
          'favourite': 'Favourite',
          'search': 'Search',
          'about': 'About',
        },
        'dz_BT': {
          'title': 'ཞེ་སའི་ཚིག་མཛོད།',
          'favourite': 'ཞེ་ས་དགའ་ཤོས།',
          'search': 'འཚོལ།',
          'about': 'སྐོར་ལས།',
        },
      };
}
