import 'package:get/get.dart';
import 'package:tuck_shop/view/point_of_sale/pos_design.dart';

import '../../view/point_of_sale/order_detail.dart';
import '../../view/point_of_sale/pos_widgets.dart';

class CounterController extends GetxController {
  var counter = <String, int>{}.obs;
  var pendingStatusList = <String, bool>{}.obs;

  void initialController() {
    for (int i = 0; i < posBookSetVM.bookSetList.length; i++) {
      String key = '${posBookSetVM.bookSetList[i].type}-${posBookSetVM.bookSetList[i].id}';
      int qty = posBookSetVM.bookSetList[i].qty ?? 0;
      bool pendingBook = posBookSetVM.bookSetList[i].isPending ?? false;
      if (counter.containsKey(key)) {
       // pendingStatusList[key] = pendingBook;
      } else {
        counter[key] = qty;
        pendingStatusList[key] = pendingBook;
      }
    }
    update();
  }


  void resetCounters() {
    counter.clear();
    pendingStatusList.clear();
    update();
  }

  void increment(String id, String type) {
    String key = '$type-$id';
    print("key$key");
    print(counter.value);
    print(pendingStatusList.value);
    discountStatus.value = false;
    discount.value = 0.0;
    selectedDiscountType.value ="";
    if (counter.containsKey(key)) {
      counter[key] = counter[key]! + 1;

    } else {
      counter[key] = 2;

    }
    update();
  }

  void decrement(String id, String type) {
    String key = '$type-$id';
    counter[key] = counter[key] ?? 0;
    discountStatus.value = false;
    discount.value = 0.0;
    selectedDiscountType.value = "";
    if (counter[key]! > 0) {
      counter[key] = (counter[key]! - 1);
      discountStatus.value = false;
      discount.value = 0.0;
      selectedDiscountType.value = "";
    }
    update();
  }

  void updatePendingStatus(String id, String type) {
    print(counter.value);
    print(pendingStatusList.value);
    String key = '$type-$id';
    if (pendingStatusList.containsKey(key)) {
      pendingStatusList[key] = true;
      print(pendingStatusList);
    } else {
      print('$key does not exist in the pending status list');
    }
    update();
  }

  void updateAvailableStatus(String id, String type) {
    String key = '$type-$id';

    if (pendingStatusList.containsKey(key) && pendingStatusList[key] == true) {
      pendingStatusList[key] = false;
      print(pendingStatusList);
      print('Updated $key to false');
    } else {
      print('$key is not pending or does not exist in the list');
    }
    update();
  }



}

