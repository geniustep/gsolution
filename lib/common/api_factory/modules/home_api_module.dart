// import 'package:gsolution/common/api_factory/api.dart';
// import 'package:gsolution/common/api_factory/dio_factory.dart';
// import 'package:gsolution/common/api_factory/modules/authentication_module.dart';
// import 'package:gsolution/common/utils/utils.dart';
// import 'package:gsolution/src/home/model/res_partner_model.dart';

// resPartnerApi({required OnResponse<PartnerModel> onResponse}) {
//   Api.callKW(
//     model: "res.partner",
//     method: 'search_read',
//     args: [
//       [],
//       ["name", "email", "phone"]
//     ],
//     // domain: [],
//     // fields: ["name", "email", "image_128"],
//     onResponse: (response) {
//       var res = PartnerModel.fromJson(response);
//       print(res);
//       onResponse(res);
//     },
//     onError: (error, data) {
//       handleApiError(error);
//     },
//   );
// }
