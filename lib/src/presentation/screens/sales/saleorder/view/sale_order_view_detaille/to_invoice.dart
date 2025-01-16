import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gsolution/src/presentation/screens/invoice/account_move_windows_view_detaille.dart';

class ToInvoice {
  // دالة لحساب الأيام المتبقية
  static String calculateRemainingDays(DateTime dateMaturity) {
    final now = DateTime.now();
    final difference = dateMaturity.difference(now).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference > 0) {
      return 'In $difference days';
    } else {
      return '${-difference} days ago';
    }
  }

  // دالة لتحديد اللون بناءً على الأيام المتبقية
  static Color getRemainingDaysColor(String remainingDays) {
    if (remainingDays.toLowerCase() == 'today') {
      return Colors.orange;
    } else if (remainingDays.toLowerCase().contains('in')) {
      return Colors.blue;
    } else if (remainingDays.toLowerCase().contains('ago')) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  // مكون عرض الحقول
  static Widget buildField({
    required String title,
    required String value,
    TextStyle? valueStyle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: valueStyle ??
                  TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // دالة عرض Dialog للفواتير
  static void showInvoiceDialog(
      BuildContext context, List<dynamic> accountMove) {
    Get.dialog(
      AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Container(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(accountMove.length, (i) {
                final account = accountMove[i];
                final status = account.statusInPayment.toString();
                final isPaid = status.toLowerCase() == 'paid';
                final remainingDays = account.invoiceDateDue != null
                    ? calculateRemainingDays(
                        DateTime.parse(account.invoiceDateDue))
                    : 'Unknown';

                return Card(
                  margin: EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: InkWell(
                    onTap: () {
                      Get.off(() => AccountMoveWindowsViewDetaille(
                            accountMove: account,
                          ));
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          buildField(
                            title: "Invoice Number:",
                            value: account.name.toString(),
                            valueStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          buildField(
                            title: "Customer Name:",
                            value: account.invoicePartnerDisplayName.toString(),
                          ),
                          buildField(
                            title: "Invoice Date:",
                            value: account.invoiceDate.toString(),
                          ),
                          if (!isPaid)
                            buildField(
                              title: "Remaining Days:",
                              value: remainingDays,
                              valueStyle: TextStyle(
                                fontSize: 14,
                                color: getRemainingDaysColor(remainingDays),
                              ),
                            ),
                          buildField(
                            title: "Total Amount:",
                            value: '${account.amountTotalInCurrencySigned}',
                            valueStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          buildField(
                            title: "Payment Status:",
                            value: isPaid ? 'Paid' : 'Not Paid',
                            valueStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isPaid ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
