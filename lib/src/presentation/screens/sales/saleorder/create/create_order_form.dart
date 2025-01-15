import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/common/config/prefs/pref_keys.dart';
import 'package:gsolution/common/config/prefs/pref_update.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gsolution/common/widgets/BarcodeScannerPage.dart';
import 'package:gsolution/src/presentation/screens/sales/saleorder/view/sale_order_view_detaille.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';

class CreateOrder extends StatefulWidget {
  final PartnerModel? partner;
  final Function(dynamic sale)? onSaleTap;
  const CreateOrder({super.key, this.partner, this.onSaleTap});

  @override
  _CreateOrderState createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  List<ProductLine> productsAdd = [];
  int? selectedModeleDevis;
  int? selectedListePrixId;
  int? selectedConditionsPaiement;
  List<dynamic> modelesDevis = [];
  List<dynamic> listesPrix = [];
  List<dynamic> conditionsPaiement = [];
  var products = <ProductModel>[].obs;
  var partners = <PartnerModel>[].obs;
  Set<int> selectedProductIds = {};
  List<Function> validationFunctions = [];
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> mapsOrder = <String, dynamic>{};
  Map<String, dynamic> mapsOrderLine = <String, dynamic>{};

  @override
  void initState() {
    super.initState();

    OrderModule.accountPaymentTerm(onResponse: (res) {
      setState(() {
        conditionsPaiement.addAll(res);
      });
    });

    OrderModule.pricelist(onResponse: (res) {
      setState(() {
        listesPrix.addAll(res);
      });
    });

    addProduct();
    if (widget.partner != null) {
      partners = [widget.partner!].obs;
    } else {
      partners = PrefUtils.partners;
    }
    products = PrefUtils.products;
  }

  void addProductValidation(Function validate) {
    validationFunctions.add(validate);
  }

  void addProduct() {
    bool allValid = validationFunctions.every((validate) => validate());

    if (allValid) {
      setState(() {
        productsAdd.add(ProductLine());
      });
    } else {
      debugPrint("Validation failed: Some product rows have invalid fields.");
      Get.snackbar(
        "Validation Error",
        "Please fill all required fields before adding a new product.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _handleProductDelete(ProductLine product) {
    setState(() {
      productsAdd.remove(product);
      if (product.productModel != null) {
        selectedProductIds.remove(product.productModel!.id);
      }
    });
  }

  Widget devisForm() {
    return FormBuilder(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Nouveau',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FormBuilderDropdown(
                decoration: const InputDecoration(
                  hintText: 'Customer',
                  border: OutlineInputBorder(),
                ),
                name: "partner_id",
                initialValue: widget.partner?.id,
                onChanged: ((value) {
                  debugPrint(value.toString());
                }),
                items: partners
                    .map((v) => DropdownMenuItem(
                          value: v.id,
                          child: Text(v.name.toString()),
                        ))
                    .toList(),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'This field is required'),
                ]),
              ),
            ),
            const SizedBox(height: 15),
            FormBuilderDropdown(
              name: 'payment_term_id',
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8.0),
                labelText: 'Conditions de paiement',
              ),
              onChanged: (int? newValue) {
                setState(() {
                  selectedConditionsPaiement = newValue;
                });
              },
              items: conditionsPaiement.map<DropdownMenuItem<int>>((value) {
                return DropdownMenuItem<int>(
                  value: value[0],
                  child: Text(value[1]),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            FormBuilderDateTimePicker(
              format: DateFormat('dd-MM-yyyy HH:mm:ss'),
              name: 'commitment_date',
              initialValue: DateTime.now(),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: 'This field is required'),
              ]),
              decoration: InputDecoration(
                labelText: 'Date Livraison',
                contentPadding: const EdgeInsets.all(8.0),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    formKey.currentState!.fields['commitment_date']
                        ?.didChange(null);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  createOrder() {
    int orderLineAdd = 0;
    bool isListEmpty = productsAdd.isEmpty;
    bool allValid = validationFunctions.every((validate) => validate());

    if ((formKey.currentState?.saveAndValidate() ?? false) &&
        (isListEmpty || allValid)) {
      debugPrint(formKey.currentState?.value.toString());

      // إنشاء نسخة قابلة للتعديل
      Map<String, dynamic> modifiableMap =
          Map.from(formKey.currentState!.value);

      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      modifiableMap['date_order'] = formatter.format(DateTime.now());

      if (modifiableMap['commitment_date'] != null) {
        modifiableMap['commitment_date'] =
            formatter.format(modifiableMap['commitment_date']);
      }
      OrderModule.createSaleOrder(
        maps: modifiableMap,
        onResponse: (resCreateSaleOrder) async {
          if (resCreateSaleOrder != null) {
            for (var e in productsAdd) {
              if (e.productModel != null) {
                mapsOrderLine = {
                  "order_id": resCreateSaleOrder,
                  "price_unit": double.tryParse(e.priceController.text),
                  "product_uom_qty": e.quantity,
                  "product_id": e.productModel!.id,
                };

                OrderLineModule.createSaleOrderLine(
                    maps: mapsOrderLine,
                    onResponse: (resSaleOrderLine) {
                      orderLineAdd++;
                      if (orderLineAdd == productsAdd.length) {
                        OrderModule.readOrders(
                            ids: [resCreateSaleOrder],
                            onResponse: (resOrder) async {
                              await PrefUpdate.addItem<OrderModel>(
                                item: resOrder[0],
                                key: PrefKeys.sales,
                                fromJson: (json) => OrderModel.fromJson(json),
                                toJson: (model) => model.toJson(),
                                getListFunction: () => PrefUtils.sales,
                              );
                              if (widget.onSaleTap != null) {
                                widget.onSaleTap!(resOrder[0]);
                              } else {
                                Get.off(() => SaleOrderViewDetaille(
                                      salesOrder: resOrder[0],
                                    ));
                              }
                            });
                      }
                    });
              }
            }
          }
        },
      );
    } else {
      debugPrint('Validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau Devis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: createOrder,
          ),
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            devisForm(),
            const Divider(),
            ...productsAdd.map((product) {
              return ProductRow(
                key: ValueKey(product),
                productLine: product,
                products: products
                    .where((p) => !selectedProductIds.contains(p.id))
                    .toList(),
                onDelete: () => _handleProductDelete(product),
                onProductSelected: (productId) {
                  setState(() {
                    selectedProductIds.add(productId);
                  });
                },
                validateForm: addProductValidation,
              );
            }).toList(),
            TextButton(
              onPressed: addProduct,
              child: const Text('Ajouter un produit'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductRow extends StatefulWidget {
  final ProductLine productLine;
  final VoidCallback onDelete;
  final List<ProductModel> products;
  final Function(int) onProductSelected;
  final Function validateForm;

  const ProductRow({
    super.key,
    required this.productLine,
    required this.products,
    required this.onDelete,
    required this.onProductSelected,
    required this.validateForm,
  });

  @override
  State<ProductRow> createState() => _ProductRowState();
}

class _ProductRowState extends State<ProductRow> {
  TextEditingController qtyController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final GlobalKey<FormBuilderState> formKeyOrderLine =
      GlobalKey<FormBuilderState>();

  bool validate() {
    if (formKeyOrderLine.currentState == null) {
      return true;
    } else {
      return formKeyOrderLine.currentState?.validate() ?? false;
    }
  }

  @override
  void initState() {
    qtyController.text = widget.productLine.quantity.toString();
    priceController.text = widget.productLine.priceController.text;

    widget.validateForm(validate);

    super.initState();
  }

  @override
  void dispose() {
    qtyController.dispose();
    priceController.dispose();
    super.dispose();
  }

  final TextEditingController searchController = TextEditingController();

  Future<void> scanBarcode() async {
    String? barcode = await Get.to(() => const BarcodeScannerPage());

    if (barcode != null && barcode.isNotEmpty) {
      // تحديث مربع البحث مباشرة باستخدام النص
      setState(() {
        searchController.text = barcode; // وضع النص في مربع البحث
      });
    } else {
      Get.snackbar(
        "Scan Cancelled",
        "No barcode was scanned.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  final GlobalKey<DropdownSearchState<ProductModel>> dropdownSearchKey =
      GlobalKey<DropdownSearchState<ProductModel>>();

  @override
  Widget build(BuildContext context) {
    double calculateTotalLinePrice() {
      final unitPrice = double.tryParse(priceController.text) ?? 0.0;
      final quantity = widget.productLine.quantity;
      return unitPrice * quantity;
    }

    return FormBuilder(
      key: formKeyOrderLine,
      onChanged: () {
        formKeyOrderLine.currentState!.save();
        debugPrint(formKeyOrderLine.currentState!.value.toString());
      },
      child: Card(
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 6,
        shadowColor: Colors.grey.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: buildImage(
                      image: widget.productLine.productModel?.image512,
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.productLine.productModel?.name ??
                              "Select Product",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.productLine.productModel?.barcode != null &&
                                  widget.productLine.productModel?.barcode !=
                                      false
                              ? widget.productLine.productModel?.barcode
                              : "Barcode unavailable",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Price: ${priceController.text} Dh",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Total Line",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${calculateTotalLinePrice().toStringAsFixed(2)} Dh",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 32, thickness: 1, color: Colors.grey),
              DropdownSearch<ProductModel>(
                key: dropdownSearchKey,
                items: (String? filter, LoadProps? props) async {
                  return widget.products;
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
                      leading: buildImage(
                        image: item.image512,
                        width: 50,
                        height: 50,
                      ),
                      title: Text(item.name),
                      subtitle: item.barcode != null
                          ? Text('Barcode: ${item.barcode}')
                          : null,
                    );
                  },
                ),
                onChanged: (selectedProduct) {
                  if (selectedProduct != null) {
                    setState(() {
                      priceController.text =
                          selectedProduct.lstPrice?.toString() ?? '0.0';
                      widget.productLine.productModel = widget.products
                          .firstWhere((p) => p.id == selectedProduct.id);
                    });
                  }
                },
                validator: FormBuilderValidators.required(
                    errorText: 'This field is required'),
              ),
              const SizedBox(height: 12),
              FormBuilderTextField(
                name: 'quantity',
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    widget.productLine.quantity =
                        int.tryParse(value ?? '0') ?? 0;
                  });
                },
                validator: (value) =>
                    value!.isEmpty || int.tryParse(value) == null
                        ? 'Please enter a valid quantity'
                        : null,
                // validator: FormBuilderValidators.compose([
                //   FormBuilderValidators.required(
                //       errorText: "Quantity is required"),
                //   FormBuilderValidators.min(1, errorText: "Minimum is 1"),
                // ]),
              ),
              const SizedBox(height: 12),
              FormBuilderTextField(
                name: 'price',
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    widget.productLine.priceController.text = value ?? '0';
                  });
                },
                validator: (value) =>
                    value!.isEmpty || double.tryParse(value) == null
                        ? 'Please enter a valid price'
                        : null,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: widget.onDelete,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductLine {
  ProductModel? productModel;
  int quantity = 1;
  TextEditingController priceController = TextEditingController();

  void dispose() {
    priceController.dispose();
  }
}
