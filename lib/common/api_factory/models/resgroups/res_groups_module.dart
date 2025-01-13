import 'package:gsolution/common/api_factory/models/resgroups/res_groups_model.dart';
import 'package:gsolution/common/config/import.dart';

class ResGroupsModule {
  ResGroupsModule._();
  static String resGroupsName = 'res.groups';
  static getResGroups({
    required OnResponse onResponse,
  }) async {
    final args = [
      [
        ["name", "ilike", "Show Full Accounting Features"]
      ],
      ["id", "name"]
    ];
    final resGroups = <ResGroupsModel>[].obs;
    try {
      Api.callKW(
          model: resGroupsName,
          method: 'search_read',
          args: args,
          onResponse: (response) {
            if (response != null) {
              for (var element in response) {
                resGroups.add(
                    ResGroupsModel.fromJson(element as Map<String, dynamic>));
              }
              onResponse(resGroups);
            }
          },
          onError: (error, data) {
            handleApiError(error);
          });
    } catch (e) {
      handleApiError(e);
    }
  }

  static resGroupsRead(
      {required List<int> ids, required OnResponse onResponse}) {
    Api.read(
        model: resGroupsName,
        fields: ["users"],
        ids: ids,
        onResponse: (response) {
          onResponse(response[0]["users"]);
        },
        onError: (e, data) {
          handleApiError(e);
        });
  }

  static writeResGroups(
      {required int id,
      required List<int> idsUser,
      required OnResponse onResponse}) {
    try {
      Api.write(
          model: resGroupsName,
          ids: [id],
          values: {"users": idsUser},
          onResponse: onResponse,
          onError: (error, data) {
            handleApiError(error);
          });
    } catch (e) {
      handleApiError(e);
    }
  }
}
