import 'package:gsolution/common/config/import.dart';

class AccountJournalModule {
  AccountJournalModule._();
  static readAccountJournal(
      {required List<int> ids,
      required OnResponse<List<AccountJournalModel>> onResponse}) {
    List<String> fields = [
      "id",
      "name",
      "active",
      "type",
      "company_id",
      "company_partner_id",
      "bank_account_id",
      "bank_id",
      "bank_statements_source",
      "code",
      "sequence_number_next",
      "sequence_id",
      "refund_sequence",
      "refund_sequence_number_next",
      "refund_sequence_id",
      "default_debit_account_id",
      "default_credit_account_id",
      "currency_id",
      "invoice_reference_type",
      "invoice_reference_model",
      "alias_id",
      "alias_name",
      "alias_domain",
      "profit_account_id",
      "loss_account_id",
      "post_at",
      "type_control_ids",
      "account_control_ids",
      "restrict_mode_hash_table",
      "inbound_payment_method_ids",
      "outbound_payment_method_ids",
      "message_follower_ids",
      "activity_ids",
      "message_ids",
      "message_attachment_count",
      "display_name"
    ];
    Api.read(
      model: "account.journal",
      ids: ids,
      fields: fields,
      onResponse: (response) {
        List<AccountJournalModel> accountJournal = [];
        for (var element in response) {
          accountJournal.add(
              AccountJournalModel.fromJson(element as Map<String, dynamic>));
        }
        onResponse(accountJournal);
      },
      onError: (error, data) {
        handleApiError(error);
      },
    );
  }

  static searchReadAccountJournal(
      {OnResponse? onResponse, dynamic domain}) async {
    List<String> fields = [
      "display_name",
      "inbound_payment_method_line_ids",
      "outbound_payment_method_line_ids",
      "default_account_id"
      // "inbound_payment_method_ids",
      // "outbound_payment_method_ids"
    ];
    domain = [
      // [
      //   "company_id",
      //   "parent_of",
      //   [PrefUtils.user.value.companyId]
      // ]
    ];
    try {
      await Module.getRecordsController<AccountJournalModel>(
        model: "account.journal",
        fields: fields,
        domain: domain,
        fromJson: (data) => AccountJournalModel.fromJson(data),
        onResponse: (response) {
          onResponse!(response);
        },
      );
    } catch (e) {
      handleApiError(e);
    }
  }

  static webReadAccountJournal(
      {required OnResponse onResponse, required List<int> ids}) {
    Api.webRead(
      model: 'account.journal',
      ids: ids,
      specification: {
        "default_account_id": {},
        "inbound_payment_method_line_ids": {
          "fields": {
            "available_payment_method_ids": {},
            "payment_type": {},
            "company_id": {"fields": {}},
            "sequence": {},
            "payment_method_id": {
              "fields": {"display_name": {}}
            },
            "name": {},
            "payment_account_id": {
              "fields": {"display_name": {}}
            },
            "code": {},
            "payment_provider_id": {
              "fields": {"display_name": {}}
            },
            "payment_provider_state": {}
          },
          "context": {"default_payment_type": "inbound"},
          "limit": 40,
          "order": "sequence ASC, id ASC"
        },
        "outbound_payment_method_line_ids": {
          "fields": {
            "available_payment_method_ids": {},
            "payment_type": {},
            "company_id": {"fields": {}},
            "sequence": {},
            "payment_method_id": {
              "fields": {"display_name": {}}
            },
            "name": {},
            "payment_account_id": {
              "fields": {"display_name": {}}
            }
          },
          "context": {"default_payment_type": "outbound"},
        },
      },
      onResponse: (response) {
        onResponse(response);
      },
      onError: (e, d) {
        handleApiError(e);
      },
    );
  }

  static writeAccount({
    required int journalId,
    required Map<String, dynamic> updates,
    required OnResponse onResponse,
    required OnError onError,
  }) {
    Api.webSave(
      model: 'account.journal',
      args: [journalId],
      value: updates,
      onResponse: (response) {
        onResponse(response);
      },
      onError: (e, d) {
        handleApiError(e);
      },
    );
  }
}
