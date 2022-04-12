// import 'package:get/state_manager.dart';
import 'package:get/get.dart';

import '../../database/za_darabase.dart';

class IconController extends GetxController {
  RxBool isPlaying = false.obs;
  RxBool isFavourite = false.obs;
}

class SearchController extends GetxController {
  RxList allData = [].obs;
  RxList recentData = [].obs;
}
