import 'package:dropdown_search/dropdown_search.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gsolution/common/api_factory/models/stock/stock_picking/stock_picking_module.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:gsolution/common/widgets/BarcodeScannerPage.dart';
import 'package:gsolution/src/presentation/screens/stock/dialog_return_product.dart';
import 'package:gsolution/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:gsolution/src/presentation/widgets/viewer/pdfviewer.dart';

class DeliveryAction {
  DeliveryAction._();

  static void showDeliveryBottomSheet({
    required bool isDone,
    required BuildContext context,
    required StockPickingModel data,
    required int saleId,
    required OnResponse onResponse,
  }) {
    final TextEditingController searchController = TextEditingController();
    final List<GlobalKey<DropdownSearchState<ProductModel>>> dropdownKeys = [];

    Future<void> scanBarcode() async {
      String? barcode = await Get.to(() => const BarcodeScannerPage());
      if (barcode != null && barcode.isNotEmpty) {
        searchController.text = barcode;
      } else {
        Get.snackbar(
          "Scan Cancelled",
          "No barcode was scanned.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          bool localIsDone = isDone;
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader("Stock Picking Details is ${data.state}",
                        context, data),
                    const SizedBox(height: 20),
                    _buildStockDetails(data, localIsDone, searchController,
                        dropdownKeys, scanBarcode),
                    const SizedBox(height: 20),
                    localIsDone
                        ? Center(
                            child: MylevatedButton(
                              label: "Delivery",
                              icon: Icons.local_shipping,
                              onPressed: () {
                                final rootContexts =
                                    Navigator.of(context, rootNavigator: true)
                                        .context;
                                StockPickingModule.validateStockPicking(
                                  args: [data.id!],
                                  onResponse: (res) async {
                                    if (res) {
                                      Get.back();
                                      Get.dialog(
                                        AlertDialog(
                                          title: Text(
                                            'Delivery Note',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: Text(
                                            'Do you want to print this delivery note?',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Center(
                                                  child: MylevatedButton(
                                                    label: 'No',
                                                    onPressed: () {
                                                      onResponse(true);
                                                    },
                                                    icon: Icons.close,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                  ),
                                                ),
                                                Center(
                                                  child: MylevatedButton(
                                                    label: 'Print',
                                                    onPressed: () {
                                                      StockPickingModule
                                                          .prinStockPickingPdf(
                                                        id: data.id!,
                                                        onResponse: (response) {
                                                          onResponse(true);
                                                          Future.delayed(
                                                              Duration(
                                                                  milliseconds:
                                                                      300),
                                                              () => fetchAndShowPdfDialog(
                                                                  rootContexts,
                                                                  response));
                                                        },
                                                      );
                                                    },
                                                    icon: Icons.print,
                                                    backgroundColor:
                                                        Colors.green,
                                                    textColor: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      Get.snackbar(
                                        "Error",
                                        "Failed to validate stock picking.",
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          )
                        : Center(
                            child: MylevatedButton(
                              label: "Return Item",
                              backgroundColor: Colors.red,
                              icon: Icons.undo,
                              onPressed: () {
                                Get.back();
                                Future.delayed(
                                  const Duration(milliseconds: 300),
                                  () {
                                    StockPickingModule.onChangeReturnStock(
                                      id: data.id!,
                                      onResponse: (responseData) {
                                        if (responseData.isNotEmpty) {
                                          showReturnDialog(
                                              data: responseData,
                                              saleId: saleId);
                                        } else {
                                          Get.snackbar(
                                            "Error",
                                            "No data found for return!",
                                          );
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  static Widget _menuPrint(
      {required BuildContext context, required StockPickingModel stock}) {
    return Visibility(
      // visible: ["Ready"].contains(stock.state),
      child: PopupMenuButton<int>(
        icon: const Icon(Icons.more_vert),
        onSelected: (value) {
          switch (value) {
            case 1:
              StockPickingModule.prinStockPickingPdf(
                id: stock.id!,
                onResponse: (response) {
                  Get.back();
                  fetchAndShowPdfDialog(context, response);
                  Get.snackbar(
                    "Printing",
                    "Wait for Printing!",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              );
              break;
            case 2:
              StockPickingModule.prinStockPickingPdfQR(
                id: stock.id!,
                onResponse: (response) {
                  fetchAndShowPdfDialog(context, response);
                  Get.snackbar(
                    "Printing",
                    "Wait for Printing!",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              );
              break;
          }
        },
        itemBuilder: (context) => [
          // if (!['sent', 'cancel'].contains(stock.state))
          PopupMenuItem(
            value: 1,
            child: Text("Bon de Livraison"),
          ),
          PopupMenuItem(
            value: 2,
            child: Text("Bon de Livraison QR"),
          ),
        ],
      ),
    );
  }

  static Widget _buildHeader(
      String title, BuildContext context, StockPickingModel stock) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        _menuPrint(context: context, stock: stock)
      ],
    );
  }

  static Widget _buildStockDetails(
      StockPickingModel data,
      bool isDone,
      TextEditingController searchController,
      List<GlobalKey<DropdownSearchState<ProductModel>>> dropdownKeys,
      Future<void> Function() scanBarcode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Name:", data.name ?? 'Unknown'),
          _buildInfoRow("Partner:",
              (data.partnerId as Map?)?['display_name'] ?? 'Unknown'),
          _buildInfoRow("Operation Type:",
              (data.pickingTypeId as Map?)?['display_name'] ?? 'Unknown'),
          _buildInfoRow("Scheduled Date:", data.scheduledDate ?? 'Unknown'),
          if (data.dateDone == false || data.dateDone == null)
            _buildInfoRow("Deadline:", data.dateDeadline.toString()),
          if (data.dateDone != false)
            _buildInfoRow("DATE DONE:", data.dateDone.toString()),
          const SizedBox(height: 10),
          const Divider(),
          const Text(
            "Moves:",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          ...?data.moveIdsWithoutPackage?.asMap().entries.map((entry) {
            int index = entry.key;
            final moveData = entry.value as Map<String, dynamic>;

            if (dropdownKeys.length <= index) {
              dropdownKeys.add(GlobalKey<DropdownSearchState<ProductModel>>());
            }

            ProductModel product = PrefUtils.products.firstWhere(
                (e) => e.id == moveData['product_id']['id'],
                orElse: () => PrefUtils.products.first);

            return _buildMoveRow(product, moveData, isDone, searchController,
                dropdownKeys[index], scanBarcode);
          }).toList(),
          const Divider(),
        ],
      ),
    );
  }

  static Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildMoveRow(
      ProductModel product,
      Map<String, dynamic> moveData,
      bool isDone,
      TextEditingController searchController,
      GlobalKey<DropdownSearchState<ProductModel>> dropdownSearchKey,
      Future<void> Function() scanBarcode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: DropdownSearch<ProductModel>(
              enabled: isDone,
              selectedItem: product,
              key: dropdownSearchKey, // مفتاح فريد
              items: (String? filter, LoadProps? props) async {
                return PrefUtils.products;
              },
              filterFn: (ProductModel product, String? filter) {
                final nameMatch = product.name
                    .toLowerCase()
                    .contains(filter?.toLowerCase() ?? '');
                final barcodeMatch = product.barcode != null &&
                    product.barcode is String &&
                    (product.barcode as String)
                        .toLowerCase()
                        .contains(filter?.toLowerCase() ?? '');
                return nameMatch || barcodeMatch;
              },
              itemAsString: (ProductModel product) => product.name,
              compareFn: (ProductModel a, ProductModel b) => a.id == b.id,
              decoratorProps: const DropDownDecoratorProps(
                decoration: InputDecoration(
                  labelText: "Select Product",
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: "Search",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.qr_code_scanner),
                      onPressed: () async {
                        await scanBarcode();
                      },
                    ),
                  ),
                ),
                itemBuilder:
                    (context, ProductModel item, isSelected, isHighlighted) {
                  return ListTile(
                    title: Text(item.name),
                  );
                },
              ),
              onChanged: (selectedProduct) {
                if (selectedProduct != null) {}
              },
              validator: FormBuilderValidators.required(
                  errorText: 'This field is required'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: FormBuilderTextField(
              name: 'product_uom_qty',
              enabled: isDone,
              initialValue: moveData['product_uom_qty'].toString(),
              decoration: const InputDecoration(
                labelText: 'Quantité en Devis',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: FormBuilderTextField(
              name: 'quantity',
              enabled: isDone,
              initialValue: moveData['quantity'].toString(),
              decoration: InputDecoration(
                labelText: isDone ? 'Quantité retournée' : "Quantité livrée",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildButtons({
    required String label,
    required VoidCallback onPressed,
    required IconData icon,
    Color backgroundColor = Colors.blue,
    Color textColor = Colors.white,
  }) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: textColor,
          size: 20,
        ),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shadowColor: Colors.blueAccent,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
