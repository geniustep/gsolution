// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_picking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockPickingModel _$StockPickingModelFromJson(Map<String, dynamic> json) =>
    StockPickingModel(
      id: (json['id'] as num?)?.toInt(),
      isLocked: json['isLocked'] as bool?,
      showMarkAsTodo: json['show_mark_as_todo'],
      showCheckAvailability: json['show_check_availability'],
      showValidate: json['show_validate'],
      showLotsText: json['show_lots_text'],
      immediateTransfer: json['immediate_transfer'],
      showOperations: json['show_operations'],
      showReserved: json['show_reserved'],
      moveLineExist: json['move_line_exist'],
      hasPackages: json['has_packages'],
      state: json['state'] as String?,
      pickingTypeEntirePacks: json['picking_type_entire_packs'],
      hasScrapMove: json['has_scrap_move'] as bool?,
      hasTracking: json['has_tracking'] as bool?,
      name: json['name'] as String?,
      partnerId: json['partner_id'],
      pickingTypeId: json['picking_type_id'],
      locationId: json['location_id'],
      locationDestId: json['location_dest_id'],
      backorderId: json['backorder_id'],
      scheduledDate: json['scheduled_date'] as String?,
      dateDone: json['date_done'],
      dateDeadline: json['date_deadline'],
      origin: json['origin'],
      ownerId: json['owner_id'],
      moveLineNosuggestIds: json['move_line_nosuggest_ids'],
      packageLevelIdsDetails: json['package_level_ids_details'],
      moveLineIdsWithoutPackage:
          json['move_line_ids_without_package'] as List<dynamic>?,
      moveIdsWithoutPackage: json['move_ids_without_package'] as List<dynamic>?,
      packageLevelIds: json['package_level_ids'],
      pickingTypeCode: json['picking_type_code'] as String?,
      moveType: json['move_type'] as String?,
      priority: json['priority'] as String?,
      userId: json['user_id'],
      groupId: json['group_id'],
      companyId: json['company_id'],
      note: json['note'],
      messageFollowerIds: json['message_follower_ids'],
      activityIds: json['activity_ids'],
      messageIds: json['message_ids'],
      messageAttachmentCount:
          (json['message_attachment_count'] as num?)?.toInt(),
      displayName: json['display_name'] as String?,
      stockMoveLine: json['stock_move_line'],
      productAvilabilityState: json['products_availability_state'],
      productAvilability: json['products_availability'],
    );

Map<String, dynamic> _$StockPickingModelToJson(StockPickingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isLocked': instance.isLocked,
      'show_mark_as_todo': instance.showMarkAsTodo,
      'show_check_availability': instance.showCheckAvailability,
      'show_validate': instance.showValidate,
      'show_lots_text': instance.showLotsText,
      'immediate_transfer': instance.immediateTransfer,
      'show_operations': instance.showOperations,
      'show_reserved': instance.showReserved,
      'move_line_exist': instance.moveLineExist,
      'has_packages': instance.hasPackages,
      'state': instance.state,
      'picking_type_entire_packs': instance.pickingTypeEntirePacks,
      'has_scrap_move': instance.hasScrapMove,
      'has_tracking': instance.hasTracking,
      'name': instance.name,
      'partner_id': instance.partnerId,
      'picking_type_id': instance.pickingTypeId,
      'location_id': instance.locationId,
      'location_dest_id': instance.locationDestId,
      'backorder_id': instance.backorderId,
      'scheduled_date': instance.scheduledDate,
      'date_done': instance.dateDone,
      'date_deadline': instance.dateDeadline,
      'origin': instance.origin,
      'owner_id': instance.ownerId,
      'move_line_nosuggest_ids': instance.moveLineNosuggestIds,
      'package_level_ids_details': instance.packageLevelIdsDetails,
      'move_line_ids_without_package': instance.moveLineIdsWithoutPackage,
      'move_ids_without_package': instance.moveIdsWithoutPackage,
      'package_level_ids': instance.packageLevelIds,
      'picking_type_code': instance.pickingTypeCode,
      'move_type': instance.moveType,
      'priority': instance.priority,
      'user_id': instance.userId,
      'group_id': instance.groupId,
      'company_id': instance.companyId,
      'note': instance.note,
      'message_follower_ids': instance.messageFollowerIds,
      'activity_ids': instance.activityIds,
      'message_ids': instance.messageIds,
      'message_attachment_count': instance.messageAttachmentCount,
      'display_name': instance.displayName,
      'stock_move_line': instance.stockMoveLine,
      'products_availability_state': instance.productAvilabilityState,
      'products_availability': instance.productAvilability,
    };

StockImmediatTransfer _$StockImmediatTransferFromJson(
        Map<String, dynamic> json) =>
    StockImmediatTransfer(
      id: (json['id'] as num?)?.toInt(),
      lastUpdate: json['__last_update'],
      createDate: json['create_date'],
      createUid: json['create_uid'],
      displayName: json['display_name'] as String?,
      pickIds: json['pick_ids'],
      writeDate: json['write_date'],
      writeUid: json['write_uid'],
    );

Map<String, dynamic> _$StockImmediatTransferToJson(
        StockImmediatTransfer instance) =>
    <String, dynamic>{
      'id': instance.id,
      '__last_update': instance.lastUpdate,
      'create_date': instance.createDate,
      'create_uid': instance.createUid,
      'display_name': instance.displayName,
      'pick_ids': instance.pickIds,
      'write_date': instance.writeDate,
      'write_uid': instance.writeUid,
    };
