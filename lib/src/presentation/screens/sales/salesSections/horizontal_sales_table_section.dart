import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/src/presentation/screens/sales/saleorder/view/sale_order_view_detaille.dart';

class HorizontalSalesTableSection extends StatelessWidget {
  final List<dynamic> sales;
  const HorizontalSalesTableSection({super.key, required this.sales});

  @override
  Widget build(BuildContext context) {
    if (sales.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: sales.length,
      itemBuilder: (context, index) {
        final data = sales[index];
        return _buildCard(data, context);
      },
    );
  }
}

Widget _buildCard(dynamic data, BuildContext context) {
  Color getStateColor(String state) {
    switch (state) {
      case 'draft':
        return Colors.blue;
      case 'sent':
        return Colors.purple;
      case 'sale':
        return Colors.green;
      case 'cancel':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  String getStateLabel(String state) {
    switch (state) {
      case 'draft':
        return 'Devis';
      case 'sent':
        return 'Envoyé';
      case 'sale':
        return 'Bon de Commande';
      case 'cancel':
        return 'Annulé';
      default:
        return state;
    }
  }

  IconData getStateIcon(String state) {
    switch (state) {
      case 'draft':
        return FontAwesomeIcons.fileAlt;
      case 'sent':
        return FontAwesomeIcons.paperPlane;
      case 'sale':
        return FontAwesomeIcons.check;
      case 'cancel':
        return FontAwesomeIcons.timesCircle;
      default:
        return FontAwesomeIcons.questionCircle;
    }
  }

  return InkWell(
    onTap: () {
      Get.to(() => SaleOrderViewDetaille(salesOrder: data));
    },
    child: Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.partnerId[1],
                  style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "${data.amountTotal} DH",
                  style: GoogleFonts.averiaLibre(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${data.name}: ${data.dateOrder}",
                  style: GoogleFonts.nunito(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: getStateColor(data.state), // اللون حسب الحالة
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        getStateIcon(data.state),
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        getStateLabel(data.state), // النص حسب الحالة
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
