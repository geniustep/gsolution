import 'package:dropdown_search/dropdown_search.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gsolution/common/api_factory/models/stock/stock_picking/stock_picking_module.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:gsolution/common/widgets/BarcodeScannerPage.dart';

void showReturnDialog({
  required Map<String, dynamic> data,
  required int saleId,
}) {
  final pickingId = data['pickingId'] ?? 'Unknown';
  final companyId = data['companyId'] ?? 'Unknown';
  final productReturnMoves =
      List<Map<String, dynamic>>.from(data['productReturnMoves'] ?? []);
  final TextEditingController searchController = TextEditingController();

  Get.dialog(StatefulBuilder(
    builder: (context, setState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Return Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Picking and Company IDs
              Text(
                "Picking ID: $pickingId",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Text(
                "Company ID: $companyId",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              const Text(
                "Product Return Moves:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Divider(),
              // Display the list
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: productReturnMoves.length,
                  itemBuilder: (context, index) {
                    final move = productReturnMoves[index];
                    int? productId = move['product_id'];
                    ProductModel product = PrefUtils.products.firstWhere(
                        (e) => e.id == productId,
                        orElse: () => ProductModel(
                            id: -1,
                            name: 'Select Product',
                            barcode: 'Unknown'));
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product and Move Quantity Row for the first row
                            if (index == 0)
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: DropdownSearch<ProductModel>(
                                      selectedItem: product,
                                      items: (String? filter,
                                          LoadProps? props) async {
                                        return PrefUtils.products;
                                      },
                                      enabled: index !=
                                          0, // Only enable for rows other than the first
                                      itemAsString: (ProductModel product) =>
                                          product.name,
                                      compareFn:
                                          (ProductModel a, ProductModel b) =>
                                              a.id == b.id,
                                      decoratorProps:
                                          const DropDownDecoratorProps(
                                        decoration: InputDecoration(
                                          labelText: "Select Product",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
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
                                              icon: const Icon(
                                                  Icons.qr_code_scanner),
                                              onPressed: () async {
                                                String? barcode = await Get.to(() =>
                                                    const BarcodeScannerPage());
                                                if (barcode != null &&
                                                    barcode.isNotEmpty) {
                                                  searchController.text =
                                                      barcode;
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      onChanged: (selectedProduct) {
                                        if (selectedProduct != null) {
                                          setState(() {
                                            productReturnMoves[index]
                                                    ['product_id'] =
                                                selectedProduct.id;
                                          });
                                        }
                                      },
                                      validator: FormBuilderValidators.required(
                                          errorText: 'This field is required'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 1,
                                    child: FormBuilderTextField(
                                      enabled: false,
                                      name: 'move_quantity_$index',
                                      initialValue:
                                          move['move_quantity'].toString(),
                                      decoration: const InputDecoration(
                                        labelText: "Quantity Delivered",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            // Dropdown for subsequent rows
                            if (index != 0)
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: DropdownSearch<ProductModel>(
                                      selectedItem: product,
                                      items: (String? filter,
                                          LoadProps? props) async {
                                        return PrefUtils.products;
                                      },
                                      enabled: index !=
                                          0, // Only enable for rows other than the first
                                      itemAsString: (ProductModel product) =>
                                          product.name,
                                      compareFn:
                                          (ProductModel a, ProductModel b) =>
                                              a.id == b.id,
                                      decoratorProps:
                                          const DropDownDecoratorProps(
                                        decoration: InputDecoration(
                                          labelText: "Select Product",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
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
                                              icon: const Icon(
                                                  Icons.qr_code_scanner),
                                              onPressed: () async {
                                                String? barcode = await Get.to(() =>
                                                    const BarcodeScannerPage());
                                                if (barcode != null &&
                                                    barcode.isNotEmpty) {
                                                  searchController.text =
                                                      barcode;
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      onChanged: (selectedProduct) {
                                        if (selectedProduct != null) {
                                          setState(() {
                                            productReturnMoves[index]
                                                    ['product_id'] =
                                                selectedProduct.id;
                                          });
                                        }
                                      },
                                      validator: FormBuilderValidators.required(
                                          errorText: 'This field is required'),
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 12),
                            // Quantity and To Refund Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: FormBuilderTextField(
                                    name: 'quantity_$index',
                                    initialValue: move['quantity'].toString(),
                                    decoration: const InputDecoration(
                                      labelText: "Quantity Return",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        move['quantity'] =
                                            double.tryParse(value ?? '0') ?? 0;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: FormBuilderCheckbox(
                                    name: 'to_refund_$index',
                                    title: const Text('To Refund'),
                                    initialValue: move['to_refund'] ?? true,
                                    onChanged: (value) {
                                      setState(() {
                                        move['to_refund'] = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Delete button for non-first rows
                            if (index != 0)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        productReturnMoves.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Add New Line Button
              TextButton.icon(
                onPressed: () {
                  bool hasEmptyFields = productReturnMoves.any((move) =>
                      move['product_id'] == null ||
                      move['quantity'] == null ||
                      move['quantity'] == 0);

                  if (!hasEmptyFields) {
                    setState(() {
                      productReturnMoves.add({
                        'product_id': null,
                        'quantity': 0,
                        'to_refund': true,
                        'move_id': false, // New rows have move_id as false
                      });
                    });
                  } else {
                    Get.snackbar(
                      "Error",
                      "Please fill in all fields before adding a new line.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                icon: const Icon(Icons.add, color: Colors.blue),
                label: const Text(
                  "Add New Line",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
        actions: [
          // Product Return Button
          TextButton(
            onPressed: () {
              bool hasEmptyFields = productReturnMoves.any((move) =>
                  move['product_id'] == null ||
                  move['quantity'] == null ||
                  move['quantity'] == 0);

              if (!hasEmptyFields) {
                Map<String, dynamic> result = {
                  "picking_id": pickingId,
                  "product_return_moves":
                      productReturnMoves.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> move = entry.value;

                    // Generate virtual name
                    String virtualName = index == 0
                        ? "virtual_${move['move_id'] ?? 'unknown'}"
                        : "virtual_${move['move_id'] ?? 'unknown'}_$index";

                    return [
                      0,
                      virtualName,
                      {
                        "product_id": move['product_id'],
                        "quantity": move['quantity'],
                        "move_id": index == 0 ? move['move_id'] : false,
                        "to_refund": move['to_refund'] ?? false,
                      }
                    ];
                  }).toList(),
                };

                print(result);
                StockPickingModule.webSave(
                    result: result,
                    onResponse: (response) {
                      StockPickingModule.returnStock(
                          args: [response],
                          onResponse: (resReturn) {
                            int resId = resReturn['res_id'];
                            StockPickingModule.validateStockPicking(
                              args: [resId],
                              context: {
                                "params": {
                                  "resId": saleId,
                                  "action": "sales",
                                  "actionStack": [
                                    {"action": "sales"},
                                    {"resId": saleId, "action": "sales"}
                                  ]
                                },
                                "active_model": "sale.order",
                                "active_id": saleId,
                                "active_ids": [saleId]
                              },
                              onResponse: (resValidate) {
                                if (resValidate) {
                                  AccountMoveModule.webSaveInvoice(
                                      resId: resId,
                                      onResponse: (resOnchange) {});
                                }
                              },
                            );
                            print(resReturn);
                          });
                    });
              } else {
                Get.snackbar(
                  "Error",
                  "Please fill in all fields before proceeding.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text("Product Return",
                style: TextStyle(
                    color: Colors.green, fontWeight: FontWeight.bold)),
          ),
          // Close Button
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Close",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      );
    },
  ));
}
