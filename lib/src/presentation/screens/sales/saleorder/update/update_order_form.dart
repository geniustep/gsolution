import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gsolution/common/api_factory/controllers/controller.dart';
import 'package:gsolution/common/api_factory/models/order/sale_order_module.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:intl/intl.dart';

class UpdateOrder extends StatefulWidget {
  final OrderModel salesOrder;
  final RxList<OrderLineModel> orderLine;
  const UpdateOrder(
      {super.key, required this.salesOrder, required this.orderLine});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateOrderState createState() => _UpdateOrderState();
}

class _UpdateOrderState extends State<UpdateOrder> {
  final Controller _controller = Get.put(Controller());
  List<ProductLine> productsAdd = [];
  int? selectedModeleDevis;
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

  List<int> listOrderLine = [];
  @override
  void initState() {
    super.initState();
    if (widget.salesOrder.orderLine.isNotEmpty) {
      listOrderLine.addAll(widget.salesOrder.orderLine.cast<int>());
    }
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

    partners = PrefUtils.partners;
    products = PrefUtils.products;

    updateProductsAdd();
  }

  void addProductValidation(Function validate) {
    validationFunctions.add(validate);
  }

  void addProduct() {
    bool isListEmpty = productsAdd.isEmpty;
    bool allValid = validationFunctions.every((validate) => validate());

    if (isListEmpty || allValid) {
      setState(() {
        productsAdd.add(ProductLine());
        allValid = true;
      });
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Devis / ${widget.salesOrder.name}',
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          FormBuilderDropdown(
            enabled: false,
            initialValue: widget.salesOrder.partnerId[0],
            decoration: InputDecoration(
              hintText: 'customers',
              border: const OutlineInputBorder(),
              icon: const Icon(
                Icons.category,
              ),
            ),
            name: "partner_id",
            onChanged: ((value) {
              print(value);
            }),
            items: partners
                .map((v) => DropdownMenuItem(
                      value: v.id,
                      child: Text(v.name.toString()),
                    ))
                .toList(),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: FormBuilderDropdown(
                  name: "pricelist_id",
                  decoration: const InputDecoration(
                    labelText: 'Liste de prix',
                    contentPadding: EdgeInsets.all(8.0),
                  ),
                  initialValue: listesPrix.isNotEmpty
                      ? widget.salesOrder.pricelistId != false
                          ? widget.salesOrder.pricelistId[0] as int
                          : null
                      : null,
                  onChanged: (int? newValue) {
                    setState(() {
                      print(newValue);
                    });
                  },
                  items: listesPrix.map((entry) {
                    return DropdownMenuItem<int>(
                      value: entry[0],
                      child: Text(entry[1]),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FormBuilderDropdown(
                  name: 'payment_term_id',
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8.0),
                    labelText: 'Conditions de paiement',
                  ),
                  initialValue: conditionsPaiement.isNotEmpty
                      ? widget.salesOrder.paymentTermId != false
                          ? widget.salesOrder.paymentTermId[0] as int
                          : null
                      : null,
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
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: FormBuilderDateTimePicker(
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'This field is required'),
                ]),
                format: DateFormat('dd-MM-yyyy HH:mm:ss'),
                name: 'commitment_date',
                initialValue: widget.salesOrder.commitmentDate != false &&
                        widget.salesOrder.commitmentDate != null
                    ? DateTime.tryParse(widget.salesOrder.commitmentDate)
                    : DateTime.now(),
                // style: const TextStyle(color: MyTheme.primaryTextLight),
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
              )),
              const Icon(Icons.calendar_today, color: Colors.black54),
            ],
          ),
        ],
      ),
    );
  }

  void updateProductsAdd() {
    for (var orderLine in widget.orderLine) {
      String qty = orderLine.productUomQty.toString();
      double qtyDouble = double.parse(qty);
      int quantity = qtyDouble.toInt();
      List<int> litOrderLineList = [];

      if (orderLine.id != null) {
        litOrderLineList.add(orderLine.id!.toInt());
      }

      ProductLine productLine = ProductLine(
        productModel:
            products.firstWhere((p0) => p0.id == orderLine.productId![0]),
        quantity: quantity,
        descriptionController:
            TextEditingController(text: orderLine.name.toString()),
        priceController:
            TextEditingController(text: orderLine.priceUnit.toString()),
        litOrderLine: orderLine.id!.toInt(),
      );

      productsAdd.add(productLine);
    }
    setState(() {});
  }

  int orderLineAdd = 0;
  updateOrder() async {
    List<int> updateOrderLine = [];
    List<int> removedOrderLine = [];
    List<dynamic> mapsOrderLineUpdated = [];
    bool isListEmpty = productsAdd.isEmpty;
    bool allValid = validationFunctions.every((validate) => validate());
    if ((formKey.currentState?.saveAndValidate() ?? false) &&
        (isListEmpty || allValid)) {
      debugPrint(formKey.currentState?.value.toString());
      mapsOrder = formKey.currentState!.value;
      Map<String, dynamic> newMap = Map.from(mapsOrder);
      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      if (formKey.currentState?.fields['commitment_date']!.value != null) {
        var date = formKey.currentState?.fields['commitment_date']!.value;
        if (date != null) {
          final String item = formatter.format(date);
          newMap['commitment_date'] = item;
        }
      }

      if (listOrderLine.isNotEmpty) {
        for (var e in productsAdd) {
          if (e.litOrderLine != null) {
            updateOrderLine.add(e.litOrderLine!);
          }
          orderLineAdd++;
        }
        if (orderLineAdd == productsAdd.length) {
          removedOrderLine = listOrderLine
              .where((item) => !updateOrderLine.contains(item))
              .toList();
          if (removedOrderLine.isNotEmpty) {
            for (var element in removedOrderLine) {
              List<dynamic> newE = [2, element, false];
              mapsOrderLineUpdated.add(newE);
            }
          }
          if (updateOrderLine.isNotEmpty) {
            int str = 0;
            for (var e in productsAdd) {
              str++;
              Map<String, dynamic> newMap = <String, dynamic>{};
              List<dynamic> newE = [];
              String virtual = "virtual_$str";
              double? quantity = double.tryParse(e.quantity.toString());
              double? price =
                  double.tryParse(e.priceController!.text.toString());
              newMap["price_unit"] = price;
              newMap["product_uom_qty"] = quantity;
              newMap['name'] = e.descriptionController!.text;
              newMap["product_id"] = e.productModel!.id;
              if (e.litOrderLine != null) {
                newE = [1, e.litOrderLine, newMap];
              } else {
                newE = [0, virtual, newMap];
              }
              mapsOrderLineUpdated.add(newE);
            }

            newMap["order_line"] = mapsOrderLineUpdated;

            PrefUtils.sales.removeWhere((e) => e.id == widget.salesOrder.id);
            await OrderModule.updateSaleOrder(
                maps: newMap,
                ids: [widget.salesOrder.id],
                onResponse: (response) {
                  OrderModule.readOrders(
                      ids: [widget.salesOrder.id],
                      onResponse: (resOrder) {
                        PrefUtils.sales.addAll(resOrder);
                        // Get.find<Controller>().currentScreen.value = ScreenInfo(
                        //     builder: () => SaleOrderWindowsViewDetaille(
                        //           salesOrder: resOrder[0],
                        //         ));
                      });
                });
          }
        }
      }
    } else {
      Get.dialog(AlertDialog(
        title: const Text("Error"),
        content: Text(formKey.currentState!.value.toString()),
        actions: [
          ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("OK"))
        ],
      ));
      debugPrint('validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau Devis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.update),
            onPressed: () {
              updateOrder();
            },
          ),
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              Get.back();
            },
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
            }),
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

class ProductLine {
  ProductModel? productModel;
  int quantity;
  TextEditingController? descriptionController =
      TextEditingController(text: "");
  TextEditingController? priceController = TextEditingController(text: "0.0");
  int? litOrderLine;

  ProductLine({
    this.productModel,
    this.quantity = 1,
    this.descriptionController,
    this.priceController,
    this.litOrderLine,
  });
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
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
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
    widget.validateForm(validate);
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  String description = "description";
  double price = 0.0;

  onLoadDetaill(int productId) {
    ProductModel? productModel =
        widget.products.firstWhereOrNull((element) => element.id == productId);
    if (productModel != null) {
      try {
        setState(() {
          widget.productLine.productModel = productModel;
          descriptionController.text =
              productModel.description ?? productModel.name;
          priceController.text = productModel.lstPrice.toString();
        });
      } catch (e) {
        setState(() {
          descriptionController.text = description;
          priceController.text = price.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKeyOrderLine,
      onChanged: () {
        formKeyOrderLine.currentState!.save();
        debugPrint(formKeyOrderLine.currentState!.value.toString());
      },
      child: Row(
        children: [
          Expanded(
            child: FormBuilderDropdown(
              initialValue: widget.productLine.productModel?.id,
              decoration: InputDecoration(
                hintText: "product",
                border: const OutlineInputBorder(),
                icon: const Icon(Icons.production_quantity_limits),
              ),
              name: "product_id",
              onChanged: (value) {
                if (value != null) {
                  onLoadDetaill(value as int);
                }
              },
              items: widget.products
                  .map((v) => DropdownMenuItem(
                        value: v.id,
                        child: Text(v.name.toString()),
                      ))
                  .toList(),
            ),
          ),
          // Description Field
          Expanded(
            child: FormBuilderTextField(
              // initialValue: widget.productLine.descriptionController!.text,
              name: 'name',
              controller: widget.productLine.descriptionController ??
                  descriptionController,
              onChanged: (value) {
                if (value != null) {
                  descriptionController.text = value;
                  widget.productLine.descriptionController =
                      descriptionController;
                }
              },
              // style: const TextStyle(color: MyTheme.primaryTextLight),
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a description' : null,
            ),
          ),
          // Quantity Field
          Expanded(
            child: FormBuilderTextField(
              controller: qtyController.text.isNotEmpty ? qtyController : null,
              name: 'quantity',
              onChanged: (value) {
                int? parsedValue = int.tryParse(value!);
                if (parsedValue != null) {
                  widget.productLine.quantity = parsedValue;
                }
              },
              // style: const TextStyle(
              //   color: MyTheme.primaryTextLight,
              // ),
              textAlign: TextAlign.center,
              initialValue: widget.productLine.quantity.toString(),
              decoration: const InputDecoration(
                floatingLabelAlignment: FloatingLabelAlignment.center,
                labelText: 'Quantité',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                } else if (double.tryParse(value) == null) {
                  return 'Please enter a valid Quantity';
                }
                return null;
              },
            ),
          ),
          // Price Field
          Expanded(
            child: FormBuilderTextField(
              name: 'price',
              // style: const TextStyle(color: MyTheme.primaryTextLight),
              textAlign: TextAlign.center,
              controller: widget.productLine.priceController ?? priceController,
              onChanged: (value) {
                if (value != null) {
                  priceController.text = value;
                  widget.productLine.priceController = priceController;
                }
              },
              decoration: const InputDecoration(
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  labelText: 'Prix unitaire'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                } else if (double.tryParse(value) == null) {
                  return 'Please enter a valid price';
                }
                return null;
              },
            ),
          ),

          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: widget.onDelete,
          ),
        ],
      ),
    );
  }
}
