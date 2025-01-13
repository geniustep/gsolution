import 'package:get/get.dart';
import 'package:gsolution/common/api_factory/modules/home_api_module.dart';
import 'package:gsolution/src/home/model/res_partner_model.dart';

class HomeController extends GetxController {
  var listOfPartners = <Records>[].obs;

  // getPartners() {
  //   resPartnerApi(
  //     onResponse: (response) {
  //       listOfPartners.assignAll(response.records!);
  //     },
  //   );
  // }
}
