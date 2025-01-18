import 'dart:io';

import 'package:gsolution/common/api_factory/api_end_points.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:path_provider/path_provider.dart';

class AccountMoveModule {
  AccountMoveModule._();
  static readInvoice(
      {required List<int> ids,
      required OnResponse<List<AccountMoveModel>> onResponse}) {
    List<String> fields = [
      "campaign_id",
      "source_id",
      "medium_id",
      "sequence_prefix",
      "sequence_number",
      "activity_ids",
      "activity_state",
      "activity_user_id",
      "activity_type_id",
      "activity_type_icon",
      "activity_date_deadline",
      "my_activity_date_deadline",
      "activity_summary",
      "activity_exception_decoration",
      "activity_exception_icon",
      "activity_calendar_event_id",
      "message_is_follower",
      "message_follower_ids",
      "message_partner_ids",
      "message_ids",
      "has_message",
      "message_needaction",
      "message_needaction_counter",
      "message_has_error",
      "message_has_error_counter",
      "message_attachment_count",
      "rating_ids",
      "website_message_ids",
      "message_has_sms_error",
      "message_main_attachment_id",
      "access_url",
      "access_token",
      "access_warning",
      "name",
      "ref",
      "date",
      "state",
      "move_type",
      "is_storno",
      "journal_id",
      "journal_group_id",
      "company_id",
      "line_ids",
      "origin_payment_id",
      "matched_payment_ids",
      "payment_count",
      "statement_line_id",
      "statement_id",
      "tax_cash_basis_rec_id",
      "tax_cash_basis_origin_move_id",
      "tax_cash_basis_created_move_ids",
      "always_tax_exigible",
      "auto_post",
      "auto_post_until",
      "auto_post_origin_id",
      "hide_post_button",
      "checked",
      "posted_before",
      "suitable_journal_ids",
      "highest_name",
      "made_sequence_gap",
      "show_name_warning",
      "type_name",
      "country_code",
      "company_price_include",
      "attachment_ids",
      "restrict_mode_hash_table",
      "secure_sequence_number",
      "inalterable_hash",
      "secured",
      "invoice_line_ids",
      "invoice_date",
      "invoice_date_due",
      "delivery_date",
      "show_delivery_date",
      "invoice_payment_term_id",
      "needed_terms",
      "needed_terms_dirty",
      "tax_calculation_rounding_method",
      "partner_id",
      "commercial_partner_id",
      "partner_shipping_id",
      "partner_bank_id",
      "fiscal_position_id",
      "payment_reference",
      "display_qr_code",
      "qr_code_method",
      "invoice_outstanding_credits_debits_widget",
      "invoice_has_outstanding",
      "invoice_payments_widget",
      "preferred_payment_method_line_id",
      "company_currency_id",
      "currency_id",
      "invoice_currency_rate",
      "direction_sign",
      "amount_untaxed",
      "amount_tax",
      "amount_total",
      "amount_residual",
      "amount_untaxed_signed",
      "amount_untaxed_in_currency_signed",
      "amount_tax_signed",
      "amount_total_signed",
      "amount_total_in_currency_signed",
      "amount_residual_signed",
      "tax_totals",
      "payment_state",
      "status_in_payment",
      "amount_total_words",
      "reversed_entry_id",
      "reversal_move_ids",
      "invoice_vendor_bill_id",
      "invoice_source_email",
      "invoice_partner_display_name",
      "is_manually_modified",
      "quick_edit_mode",
      "quick_edit_total_amount",
      "quick_encoding_vals",
      "narration",
      "is_move_sent",
      "is_being_sent",
      "move_sent_values",
      "invoice_user_id",
      "user_id",
      "invoice_origin",
      "invoice_incoterm_id",
      "incoterm_location",
      "invoice_cash_rounding_id",
      "sending_data",
      "invoice_pdf_report_id",
      "invoice_pdf_report_file",
      "invoice_filter_type_domain",
      "bank_partner_id",
      "tax_lock_date_message",
      "display_inactive_currency_warning",
      "tax_country_id",
      "tax_country_code",
      "has_reconciled_entries",
      "show_reset_to_draft_button",
      "partner_credit_warning",
      "partner_credit",
      "duplicated_ref_ids",
      "need_cancel_request",
      "show_update_fpos",
      "payment_term_details",
      "show_payment_term_details",
      "show_discount_details",
      "abnormal_amount_warning",
      "abnormal_date_warning",
      "taxes_legal_notes",
      "next_payment_date",
      "id",
      "display_name",
      "create_uid",
      "create_date",
      "write_uid",
      "write_date",
      "payment_ids",
      "statement_line_ids",
      "ubl_cii_xml_id",
      "ubl_cii_xml_file",
      "transaction_ids",
      "authorized_transaction_ids",
      "transaction_count",
      "amount_paid",
      "expense_sheet_id",
      "show_commercial_partner_warning",
      "purchase_vendor_bill_id",
      "purchase_id",
      "purchase_order_count",
      "purchase_order_name",
      "is_purchase_matched",
      "stock_move_id",
      "stock_valuation_layer_ids",
      "wip_production_ids",
      "wip_production_count",
      "team_id",
      "sale_order_count",
    ];
    Api.read(
      model: "account.move",
      ids: ids,
      fields: fields,
      onResponse: (response) {
        List<AccountMoveModel> invoices = [];
        for (var element in response) {
          invoices
              .add(AccountMoveModel.fromJson(element as Map<String, dynamic>));
        }
        onResponse(invoices);
      },
      onError: (error, data) {
        handleApiError(error);
      },
    );
  }

  static searchReadAccountMove({OnResponse? onResponse, dynamic domain}) async {
    List<String> fields = [
      'invoice_origin',
      "name",
      'line_ids',
      'partner_id',
      'amount_untaxed',
      'amount_tax',
      'amount_total',
      'amount_residual',
      'invoice_line_ids',
      'status_in_payment',
      'amount_total_in_currency_signed',
      'invoice_partner_display_name',
      'invoice_date',
      'invoice_date_due',
    ];
    if (PrefUtils.user.value.isAdmin!) {
      fields.add('invoice_payments_widget');
    }

    domain = [];
    try {
      await Module.getRecordsController<AccountMoveModel>(
        model: "account.move",
        fields: fields,
        domain: domain,
        fromJson: (data) => AccountMoveModel.fromJson(data),
        onResponse: (response) {
          print("Productos obtenidos: ${response.length}");
          onResponse!(response);
        },
      );
    } catch (e) {
      print("Error obteniendo invoice: $e");
      handleApiError(e);
    }
  }

  static searchInvoicePartnersId(
      {int offset = 0,
      List<dynamic>? domain,
      required OnResponse<dynamic> onResponse}) {
    List<String> fields = [
      "partner_id",
    ];
    Api.searchRead(
        model: "account.move",
        domain: domain!,
        offset: offset,
        fields: fields,
        onResponse: (response) {
          if (response != null) {
            onResponse(response["records"]);
          }
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static loadViewInvoice(
      {required List<int> args,
      required OnResponse onResponse,
      Map<String, dynamic>? context,
      Map<String, dynamic>? kwargs}) {
    Api.callKW(
        model: "account.move",
        method: "load_views",
        kwargs: kwargs,
        args: args,
        context: context,
        onResponse: (response) {
          onResponse(response);
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static createSaleAdvancePaymentInv(
      {required Map<String, dynamic>? maps,
      int offset = 0,
      required List domain,
      required OnResponse<Map<int, List<SalesAdvancePaymentInvoice>>>
          onResponse}) {
    Map<String, dynamic> newMap = Map.from(maps!);
    Api.create(
        model: "sale.advance.payment.inv",
        values: newMap,
        onResponse: (response) {
          // onResponse(response);
        },
        onError: (String error, Map<String, dynamic> data) {
          print('error');
        });
  }

  static confirmInvoice(
      {required List<int> args, required OnResponse<bool> onResponse}) {
    Api.callKW(
        model: "account.move",
        method: "action_confirm",
        args: args,
        onResponse: (response) {
          onResponse(response);
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static cancelMethod(
      {required List<int> args, required OnResponse<bool> onResponse}) {
    Api.callKW(
        model: "account.move",
        method: "action_cancel",
        args: args,
        onResponse: (response) {
          onResponse(response);
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static draftMethod(
      {required List<int> args, required OnResponse<bool> onResponse}) {
    Api.callKW(
        model: "account.move",
        method: "action_draft",
        args: args,
        onResponse: (response) {
          onResponse(response);
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static createInvoiceCall(
      {required List<int> args,
      required int id,
      required OnResponse<dynamic> onResponse}) {
    Map<String, dynamic> context = {};
    context["params"] = {
      "action": 289,
      "cids": 1,
      "id": id,
      "menu_id": 170,
      "model": "sale.order",
      "view_type": "form"
    };
    context["create"] = false;
    context["active_model"] = "sale.order";
    context["active_id"] = id;
    context["active_ids"] = [id];
    context["open_invoices"] = true;

    Api.callKW(
        model: "sale.advance.payment.inv",
        method: "create_invoices",
        args: [args],
        context: context,
        onResponse: (response) {
          print(response);
          onResponse(response);
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static createInvoiceSales(
      {required Map<String, dynamic>? maps,
      Map<String, dynamic>? kwargs,
      required OnResponse onResponse,
      required List<int> args}) {
    Api.callKW(
      model: "sale.advance.payment.inv",
      method: "create",
      args: [maps],
      kwargs: {"context": kwargs},
      onResponse: (response) {
        onResponse(response);
      },
      onError: (String error, Map<String, dynamic> data) {
        print('error');
      },
    );
  }

  static comptabliseInvoiceSales(
      {required List<int> args, required OnResponse<bool> onResponse}) {
    Api.callKW(
        model: "account.move",
        method: "action_post",
        args: [args],
        onResponse: (response) {
          onResponse(response);
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static createInvoicePurchase(
      {Map<String, dynamic>? kwargs,
      required OnResponse onResponse,
      required List<int> args}) {
    Api.callKW(
      model: "purchase.order",
      method: "action_view_invoice",
      args: [args],
      kwargs: {
        "context": {
          "lang": "fr_FR",
          "tz": "Africa/Casablanca",
          "uid": 2,
          "allowed_company_ids": [1]
        },
      },
      onResponse: (response) {
        onResponse(response);
      },
      onError: (String error, Map<String, dynamic> data) {
        print('error');
      },
    );
  }

  static confirmInvoicePurchase(
      {Map<String, dynamic>? kwargs,
      required OnResponse onResponse,
      required String method,
      required List<int> args}) {
    var model = "purchase.order";
    var params = {
      "model": model,
      "method": method,
      "args": args,
      "kwargs": kwargs ?? {},
    };
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.getCallKWEndPoint(model, method),
      params: Api.createPayload(params),
      onResponse: (response) {
        try {
          onResponse(response);
        } catch (e) {
          print(e);
        }
      },
      onError: (error, data) {
        print('error');
      },
    );
  }

  static createInvoicePurchaseCall({
    required Map<String, dynamic> invoiceData,
    // required int id,
    required OnResponse<dynamic> onResponse,
  }) {
    List<dynamic> args = [invoiceData];

    Api.callKW(
        model: "account.move",
        method: "create",
        args: args,
        onResponse: (response) {
          onResponse(response);
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static webSaveInvoice({required int resId, required OnResponse onResponse}) {
    Api.webSave(
        model: "sale.advance.payment.inv",
        value: {
          "sale_order_ids": [
            [4, resId]
          ],
          "consolidated_billing": true,
          "advance_payment_method": "delivered",
          "fixed_amount": 0,
          "amount": 0
        },
        args: [],
        specification: {
          "display_draft_invoice_warning": {},
          "has_down_payments": {},
          "sale_order_ids": {},
          "count": {},
          "consolidated_billing": {},
          "advance_payment_method": {},
          "company_id": {"fields": {}},
          "currency_id": {"fields": {}},
          "fixed_amount": {},
          "amount": {},
          "amount_invoiced": {},
          "amount_to_invoice": {}
        },
        onResponse: (response) {
          print("Response: $response");

          if (response != null &&
              response is List<dynamic> &&
              response.isNotEmpty) {
            final value = response[0];
            onResponse(value);
          }
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static createInvoice(
      {required int id, required int saleId, required OnResponse onResponse}) {
    Api.callKW(
        model: "sale.advance.payment.inv",
        method: "create_invoices",
        args: [id],
        kwargs: {
          "context": {
            "params": {
              "debug": 1,
              "resId": saleId,
              "action": "sales",
              "actionStack": [
                {"action": "sales"},
                {"resId": saleId, "action": "sales"}
              ]
            },
            "lang": "fr_FR",
            "tz": "Africa/Casablanca",
            "uid": 2,
            "allowed_company_ids": [1],
            "active_model": "sale.order",
            "active_id": saleId,
            "active_ids": [saleId]
          }
        },
        onResponse: (response) {
          if (response != null) {
            if (response != null && response is Map<String, dynamic>) {
              final int invoiceId = response['res_id'];
              confirmPostInvoice(
                  id: invoiceId,
                  onResponse: (resConfirme) {
                    webReadAccountMove(
                        ids: [invoiceId],
                        onResponse: (resRead) {
                          onResponse(resRead);
                        });
                  });
            }
          }
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static confirmPostInvoice({required int id, required OnResponse onResponse}) {
    Api.callKW(
        model: "account.move",
        method: "action_post",
        args: [id],
        onResponse: (response) {
          onResponse(response);
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static webReadAccountMove(
      {required List<int> ids, required OnResponse onResponse}) {
    Api.webRead(
        model: "account.move",
        ids: ids,
        specification: {
          "authorized_transaction_ids": {},
          "state": {},
          "duplicated_ref_ids": {
            "fields": {"display_name": {}},
            "context": {"name_as_amount_total": true}
          },
          "tax_lock_date_message": {},
          "date": {},
          "auto_post": {},
          "auto_post_until": {},
          "partner_credit_warning": {},
          "abnormal_amount_warning": {},
          "abnormal_date_warning": {},
          "show_commercial_partner_warning": {},
          "payment_count": {},
          "transaction_count": {},
          "sale_order_count": {},
          "purchase_order_name": {},
          "purchase_order_count": {},
          "expense_sheet_id": {"fields": {}},
          "id": {},
          "company_id": {
            "fields": {"display_name": {}}
          },
          "journal_id": {"fields": {}},
          "show_name_warning": {},
          "posted_before": {},
          "move_type": {},
          "payment_state": {},
          "invoice_filter_type_domain": {},
          "suitable_journal_ids": {},
          "currency_id": {
            "fields": {"display_name": {}}
          },
          "company_currency_id": {
            "fields": {"display_name": {}}
          },
          "commercial_partner_id": {"fields": {}},
          "bank_partner_id": {"fields": {}},
          "display_qr_code": {},
          "show_reset_to_draft_button": {},
          "invoice_has_outstanding": {},
          "is_move_sent": {},
          "invoice_pdf_report_id": {"fields": {}},
          "need_cancel_request": {},
          "has_reconciled_entries": {},
          "restrict_mode_hash_table": {},
          "inalterable_hash": {},
          "country_code": {},
          "display_inactive_currency_warning": {},
          "statement_line_id": {"fields": {}},
          "statement_id": {"fields": {}},
          "origin_payment_id": {"fields": {}},
          "tax_country_id": {"fields": {}},
          "tax_calculation_rounding_method": {},
          "tax_cash_basis_created_move_ids": {},
          "quick_edit_mode": {},
          "hide_post_button": {},
          "quick_encoding_vals": {},
          "show_delivery_date": {},
          "is_being_sent": {},
          "show_update_fpos": {},
          "highest_name": {},
          "name": {},
          "partner_id": {
            "fields": {"display_name": {}},
            "context": {
              "res_partner_search_mode": "customer",
              "show_address": 1,
              "default_is_company": true,
              "show_vat": true
            }
          },
          "quick_edit_total_amount": {},
          "ref": {},
          "tax_cash_basis_origin_move_id": {
            "fields": {"display_name": {}}
          },
          "purchase_id": {"fields": {}},
          "purchase_vendor_bill_id": {
            "fields": {"display_name": {}},
            "context": {"show_total_amount": true}
          },
          "invoice_date": {},
          "payment_reference": {},
          "partner_bank_id": {
            "fields": {"display_name": {}},
            "context": {"display_account_trust": true}
          },
          "invoice_date_due": {},
          "invoice_payment_term_id": {
            "fields": {"display_name": {}}
          },
          "delivery_date": {},
          "invoice_currency_rate": {},
          "invoice_line_ids": {
            "fields": {
              "sequence": {},
              "product_id": {
                "fields": {"display_name": {}}
              },
              "name": {},
              "quantity": {},
              "product_uom_category_id": {"fields": {}},
              "product_uom_id": {"fields": {}},
              "price_unit": {},
              "discount": {},
              "tax_ids": {
                "fields": {"display_name": {}},
                "context": {"active_test": true}
              },
              "price_subtotal": {},
              "price_total": {},
              "partner_id": {"fields": {}},
              "currency_id": {"fields": {}},
              "company_id": {"fields": {}},
              "purchase_line_id": {"fields": {}},
              "purchase_order_id": {
                "fields": {"display_name": {}}
              },
              "company_currency_id": {"fields": {}},
              "display_type": {},
              "is_downpayment": {},
              "tax_calculation_rounding_method": {},
              "account_id": {"fields": {}}
            },
            "context": {
              "default_move_type": "out_invoice",
              "default_display_type": "product"
            },
            "limit": 40,
            "order": "sequence ASC, id ASC"
          },
          "narration": {},
          "tax_totals": {},
          "invoice_payments_widget": {},
          "amount_residual": {},
          "invoice_outstanding_credits_debits_widget": {},
          "user_id": {"fields": {}},
          "invoice_user_id": {
            "fields": {"display_name": {}}
          },
          "team_id": {
            "fields": {"display_name": {}},
            "context": {"kanban_view_ref": "sales_team.crm_team_view_kanban"}
          },
          "invoice_origin": {},
          "qr_code_method": {},
          "invoice_incoterm_id": {
            "fields": {"display_name": {}}
          },
          "incoterm_location": {},
          "fiscal_position_id": {
            "fields": {"display_name": {}}
          },
          "secured": {},
          "preferred_payment_method_line_id": {
            "fields": {"display_name": {}}
          },
          "invoice_source_email": {},
          "checked": {},
          "campaign_id": {
            "fields": {"display_name": {}}
          },
          "medium_id": {
            "fields": {"display_name": {}}
          },
          "source_id": {
            "fields": {"display_name": {}}
          },
          "reversed_entry_id": {
            "fields": {"display_name": {}}
          },
          "matched_payment_ids": {},
          "is_purchase_matched": {},
          "company_price_include": {},
          "display_name": {}
        },
        onResponse: (response) {
          List<AccountMoveModel> invoices = [];
          for (var element in response) {
            invoices.add(
                AccountMoveModel.fromJson(element as Map<String, dynamic>));
          }
          PrefUtils.accountMove.addAll(invoices);
          onResponse(invoices);
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static printAccountMovePdf(
      {required OnResponse onResponse, required int id}) async {
    await Api.printReportPdf(
        reportName: 'account.report_invoice',
        recordId: id,
        onResponse: (response) async {
          final directory = await getDownloadsDirectory();
          final savePath = '${directory!.path}/invoice_$id.pdf';
          final file = File(savePath);
          await file.writeAsBytes(response);
          onResponse(savePath);
        },
        onError: (e, d) {
          handleApiError(e);
        });
  }

  static printAccountMovePdfwithDue(
      {required OnResponse onResponse, required int id}) {
    Api.webSave(
        model: 'account.move.send.wizard',
        args: [],
        value: {"move_id": id},
        onResponse: (response) {
          if (response is List<dynamic>) {
            int idd = response[0]['id'];
            Api.callKW(
                model: "account.move.send.wizard",
                method: 'action_send_and_print',
                args: [idd],
                onResponse: (res) {
                  print(res.runtimeType);
                  if (res is Map<String, dynamic>) {
                    String cleanedUrl = res['url'];
                    String url = cleanedUrl.replaceFirst("/", "");
                    Api.downloadReportPdf(
                        url: url,
                        onResponse: (pdf) {
                          onResponse(pdf);
                        },
                        onError: (e, d) {
                          handleApiError(e);
                        });
                  }
                  ;
                },
                onError: (e, d) {
                  handleApiError(e);
                });
          }
        },
        onError: (e, d) {
          handleApiError(e);
        });
  }
}
