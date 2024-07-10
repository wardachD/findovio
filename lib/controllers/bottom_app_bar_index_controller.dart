import 'package:get/get.dart';

class BottomAppBarIndexController extends GetxController {
  var activeIndex = 0.obs;
  var optionalCategory = ''.obs;

  void setBottomAppBarIndex(int value) {
    activeIndex.value = value;
  }

  void setCategory(String valueOptionalCategory) {
    optionalCategory.value = valueOptionalCategory;
  }

  void setBottomAppBarIndexWithCategory(
      int value, String? valueOptionalCategory) {
    activeIndex.value = value;
    if (valueOptionalCategory == '' || valueOptionalCategory == null) {
      valueOptionalCategory = '';
    } else {
      optionalCategory.value = valueOptionalCategory;
    }
  }
}
