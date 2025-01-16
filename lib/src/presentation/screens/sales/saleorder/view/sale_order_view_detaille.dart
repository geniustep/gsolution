// ignore: must_be_immutable
import 'package:gsolution/common/api_factory/models/stock/stock_picking/stock_picking_module.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/common/config/prefs/pref_keys.dart';
import 'package:gsolution/common/config/prefs/pref_update.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:gsolution/src/presentation/screens/sales/saleorder/update/update_order_form.dart';
import 'package:gsolution/src/presentation/screens/sales/saleorder/view/sale_order_view_detaille/to_invoice.dart';
import 'package:gsolution/src/presentation/screens/stock/available_stock_picking.dart';
import 'package:gsolution/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:gsolution/src/presentation/widgets/viewer/pdfviewer.dart';

// ignore: must_be_immutable
class SaleOrderViewDetaille extends StatefulWidget {
  OrderModel salesOrder;
  SaleOrderViewDetaille({super.key, required this.salesOrder});

  @override
  State<SaleOrderViewDetaille> createState() => _SaleOrderViewDetailleState();
}

class _SaleOrderViewDetailleState extends State<SaleOrderViewDetaille> {
  PartnerModel partner = PartnerModel();
  bool isOrderLine = false;
  Map<String, dynamic> maps = <String, dynamic>{};

  var orderLine = <OrderLineModel>[].obs;
  var accountMove = <AccountMoveModel>[].obs;
  var stockPicking = <StockPickingModel>[].obs;
  bool isLoading = false;
  @override
  void initState() {
    partner = PrefUtils.partners
        .firstWhere((element) => element.id == widget.salesOrder.partnerId[0]);

    if (PrefUtils.orderLine.isNotEmpty && orderLine.isNotEmpty) {
      orderLine.assignAll(
        PrefUtils.orderLine
            .where((e) => widget.salesOrder.orderLine.contains(e.id))
            .toList(),
      );
    } else {
      List<int> ids = widget.salesOrder.orderLine.cast<int>();
      OrderLineModule.readOrderLines(
          ids: ids,
          onResponse: (response) {
            PrefUtils.orderLine.addAll(response);
            orderLine.assignAll(response);
          });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Devis / ${widget.salesOrder.name}'),
        leading: IconButton(
            onPressed: () {
              Get.back(result: true);
            },
            icon: Icon(Icons.arrow_left)),
        actions: <Widget>[
          if (widget.salesOrder.state != "sale" &&
              widget.salesOrder.state != "cancel")
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Get.to(() => UpdateOrder(
                    salesOrder: widget.salesOrder, orderLine: orderLine));
              },
            ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              OrderModule.printDevisPdf(
                  onResponse: (response) {
                    fetchAndShowPdfDialog(
                      context,
                      response,
                    );
                  },
                  id: widget.salesOrder.id);
            },
          ),
          Visibility(
            visible: ['draft', 'cancel'].contains(widget.salesOrder.state),
            child: PopupMenuButton<int>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                switch (value) {
                  case 1:
                    // Cancel Order
                    Get.dialog(
                      AlertDialog(
                        title: const Text("Cancel Order"),
                        content: const Text("Do you want Cancel this Order?"),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              OrderModule.cancelOrderDraft(
                                  args: widget.salesOrder.id,
                                  onResponse: (response) async {
                                    await PrefUpdate.updateItem(
                                      key: "sales",
                                      newItem: widget.salesOrder,
                                      fromJson: (json) =>
                                          OrderModel.fromJson(json),
                                      toJson: (sale) => sale.toJson(),
                                      getListFunction: () => PrefUtils.sales,
                                    );
                                    updateSaleOrderList(message: "Canceled");
                                    Get.back();
                                  });
                            },
                            child: const Text("Yes.. Cancel!"),
                          ),
                        ],
                      ),
                    );

                    break;
                  case 2:
                    // Delete Order
                    Get.dialog(
                      AlertDialog(
                        title: const Text("Delete Order"),
                        content: const Text("Do you want delete this Order?"),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              OrderModule.deliteOrder(
                                  args: widget.salesOrder.id,
                                  onResponse: (response) {
                                    if (response) {
                                      PrefUpdate.deleteItem(
                                        key: PrefKeys.sales,
                                        id: widget.salesOrder.id,
                                        fromJson: (json) =>
                                            OrderModel.fromJson(json),
                                        toJson: (item) => item.toJson(),
                                        getListFunction: () => PrefUtils.sales,
                                      ).whenComplete(() {
                                        Get.back(
                                            result: true, closeOverlays: true);
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Order successfully Deleted")),
                                      );
                                    }
                                  });
                            },
                            child: const Text("Yes.. Delete!"),
                          ),
                        ],
                      ),
                    );
                    break;
                }
              },
              itemBuilder: (context) => [
                if (!['sent', 'cancel'].contains(widget.salesOrder.state))
                  PopupMenuItem(
                    value: 1,
                    child: Text("Annuler"),
                  ),
                PopupMenuItem(
                  value: 2,
                  child: Text("Suprimer"),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            color: Colors.grey.shade100,
            child: Column(
              children: [
                if (!['cancel'].contains(widget.salesOrder.state))
                  _buildButtonheader(),
                const Divider(),
                _buildButtonAction(),
                const Divider(),
              ],
            ),
          ),
          Flexible(flex: 1, child: _bodyInfoOrder()),
          Flexible(flex: 1, child: _buildItemsTableOrderLine()),
        ],
      ),
      bottomNavigationBar: _buildTotalSection(),
    );
  }

  _createInvoice() async {
    await AccountMoveModule.webSaveInvoice(
        resId: widget.salesOrder.id,
        onResponse: (response) {
          if (response != null && response is Map<String, dynamic>) {
            int id = response['id'];
            AccountMoveModule.createInvoice(
                id: id,
                saleId: widget.salesOrder.id,
                onResponse: (resCreateInvoice) async {
                  if (resCreateInvoice != null) {
                    await updateSaleOrderList();
                  }
                });
          }
        });
  }

  _createDellivery() async {
    await OrderModule.actionViewDelivery(
      args: [widget.salesOrder.id],
      onResponse: (resAction) {
        List<int> resId = resAction;
        bool isOneId = resId.length == 1 ? true : false;
        StockPickingModule.webRead(
          isOneId: isOneId,
          args: resId,
          onResponse: (resRead) {
            if (resRead.isNotEmpty) {
              stockPicking.assignAll(resRead);
              final allAvailable = stockPicking
                  .every((item) => item.productAvilabilityState == "available");
              final anyLate = stockPicking
                  .any((item) => item.productAvilabilityState == "late");
              if (resRead.length > 1) {
                Get.dialog(
                  AlertDialog(
                    content: SizedBox(
                      width: double.maxFinite,
                      child: _listStockPicking(stockPicking),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text("Close"),
                      ),
                    ],
                  ),
                );
              } else if (allAvailable) {
                DeliveryAction.showDeliveryBottomSheet(
                  isDone: true,
                  context: context,
                  data: stockPicking[0],
                  saleId: widget.salesOrder.id,
                  onResponse: (response) async {
                    if (response) {
                      await updateSaleOrderList().then((_) {
                        Get.back();
                      });
                    }
                  },
                );
              } else if (anyLate) {
                dialogLate();
              } else {
                DeliveryAction.showDeliveryBottomSheet(
                  isDone: false,
                  context: context,
                  data: stockPicking[0],
                  saleId: widget.salesOrder.id,
                  onResponse: (response) async {
                    if (response) {
                      await updateSaleOrderList().then((_) {
                        Get.back();
                      });
                    }
                  },
                );
              }
            } else {
              print('❌ Error: No response received.');
            }
          },
        );
      },
    );
  }

  Widget _buildButtonheader() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: widget.salesOrder.deliveryStatus == 'pending',
            child: MylevatedButton(
                label: "Delivery",
                icon: Icons.local_shipping,
                onPressed: () {
                  _createDellivery();
                }),
          ),
          Visibility(
            visible: widget.salesOrder.invoiceStatus == 'to invoice',
            child: MylevatedButton(
                label: "Create Invoice",
                icon: Icons.receipt,
                onPressed: () {
                  _createInvoice();
                }),
          ),
          Visibility(
            visible: widget.salesOrder.invoiceCount > 0,
            child: TextButton(
                onPressed: () {
                  if (widget.salesOrder.invoiceCount > 0) {
                    accountMove.assignAll(PrefUtils.accountMove
                        .where(
                            (p0) => p0.invoiceOrigin == widget.salesOrder.name)
                        .toList());
                    if (accountMove.isNotEmpty) {
                      if (accountMove.length == 1) {
                        ToInvoice.showInvoiceDialog(context, accountMove);
                      }
                    }
                  }
                },
                child: Row(
                  children: [
                    const Icon(Icons.feed),
                    const SizedBox(
                      width: 6,
                    ),
                    Text("${widget.salesOrder.invoiceCount} Factures")
                  ],
                )),
          ),
          Visibility(
            visible: widget.salesOrder.deliveryCount > 0 &&
                widget.salesOrder.deliveryStatus != 'pending',
            child: TextButton(
                onPressed: () {
                  OrderModule.actionViewDelivery(
                    args: [widget.salesOrder.id],
                    onResponse: (resAction) {
                      List<int> resId = resAction;
                      bool isOneId = resId.length == 1 ? true : false;
                      StockPickingModule.webRead(
                        isOneId: isOneId,
                        args: resId,
                        onResponse: (resRead) {
                          if (resRead.isNotEmpty) {
                            stockPicking.assignAll(resRead);
                            final allAvailable = stockPicking.every((item) =>
                                item.productAvilabilityState == "available");
                            final anyLate = stockPicking.any((item) =>
                                item.productAvilabilityState == "late");
                            if (resRead.length > 1) {
                              Get.dialog(
                                AlertDialog(
                                  content: SizedBox(
                                    width: double.maxFinite,
                                    child: _listStockPicking(stockPicking),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text("Close"),
                                    ),
                                  ],
                                ),
                              );
                            } else if (allAvailable) {
                              DeliveryAction.showDeliveryBottomSheet(
                                isDone: true,
                                context: context,
                                data: stockPicking[0],
                                saleId: widget.salesOrder.id,
                                onResponse: (response) async {
                                  if (response) {
                                    await updateSaleOrderList().then((_) {
                                      Get.back();
                                    });
                                  }
                                },
                              );
                            } else if (anyLate) {
                              dialogLate();
                            } else {
                              DeliveryAction.showDeliveryBottomSheet(
                                isDone: false,
                                context: context,
                                data: stockPicking[0],
                                saleId: widget.salesOrder.id,
                                onResponse: (response) async {
                                  if (response) {
                                    await updateSaleOrderList().then((_) {
                                      Get.back();
                                    });
                                  }
                                },
                              );
                            }
                          } else {
                            print('❌ Error: No response received.');
                          }
                        },
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    const Icon(Icons.delivery_dining_outlined),
                    const SizedBox(
                      width: 6,
                    ),
                    Text("${widget.salesOrder.deliveryCount} Livraisons")
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _listStockPicking(List<StockPickingModel> data) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return InkWell(
            onTap: () {
              // تحقق من الشروط الخاصة بالمنتجات داخل هذا العنصر فقط
              // final allAvailable = data
              //     .every((item) => item.productAvilabilityState == "available");
              // final anyLate =
              //     data.any((item) => item.productAvilabilityState == "late");

              final allAvailable = item.productAvilabilityState == "available";
              final anyLate = item.productAvilabilityState == "late";

              // تطبيق الشروط الخاصة بهذا العنصر
              if (allAvailable) {
                // جميع المنتجات متوفرة لهذا العنصر

                Future.delayed(Duration(milliseconds: 300), () {
                  if (mounted) {
                    final newContext =
                        Navigator.of(context, rootNavigator: true).context;
                    DeliveryAction.showDeliveryBottomSheet(
                      isDone: true,
                      context: newContext,
                      data: item,
                      saleId: widget.salesOrder.id,
                      onResponse: (response) async {
                        if (response['1'] == true) {
                          await updateSaleOrderList().then((_) {
                            Get.back();
                          });
                        }
                      },
                    );
                  }
                });
              } else if (anyLate) {
                // بعض المنتجات متأخرة لهذا العنصر
                Get.back();
                Future.delayed(Duration(milliseconds: 300), () {
                  if (mounted) {
                    dialogLate();
                  }
                });
              } else {
                final rootContext =
                    Navigator.of(context, rootNavigator: true).context;
                Get.back();
                Future.delayed(Duration.zero, () {
                  if (mounted) {
                    DeliveryAction.showDeliveryBottomSheet(
                      isDone: false,
                      context: rootContext,
                      data: item,
                      saleId: widget.salesOrder.id,
                      onResponse: (response) async {
                        if (response) {
                          await updateSaleOrderList().then((_) {
                            Get.back();
                          });
                        }
                      },
                    );
                  }
                });
                // حالات أخرى لهذا العنصر
              }
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text(
                              item.name.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStateColor(item.state),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.state ?? 'N/A',
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text(
                                item.partnerId?["display_name"] ?? 'Unknown',
                                overflow: TextOverflow.ellipsis)),
                        Expanded(
                            child: Text(item.productAvilability.toString())),
                        Expanded(
                            flex: 2,
                            child: Text(
                                item.dateDone != false
                                    ? item.dateDone.toString()
                                    : "Not delivered yet",
                                overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStateColor(String? state) {
    switch (state) {
      case 'done':
        return Colors.green;
      case 'assigned':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  dialogLate() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: Text('Créer un reliquat ?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vous avez traité moins de produits que la demande initiale.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 10.0),
              Text(
                'Créer un reliquat si vous attendez à traiter la quantité de produits restante. Ne créez pas de reliquat si vous ne voulez pas traiter la quantité de produits restante.',
                style: TextStyle(fontSize: 14.0, color: Colors.black87),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Add your action for "Créer un reliquat"
                Navigator.of(context).pop();
              },
              child: Text(
                'Créer un reliquat',
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF6A4BAF),
              ),
            ),
            TextButton(
              onPressed: () {
                // _listStockPicking(data);
              },
              child: Text(
                'AUCUN RELIQUAT',
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
            ),
            TextButton(
              onPressed: () {
                // StockPickingModule.validateStockPicking(
                //     args: args, onResponse: onResponse);
                // StockPickingModule.stockBackorderConfirmation(
                //     method: method, args: args, onResponse: onResponse);
              },
              child: Text('Ignorer'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildButtonAction() {
    bool isOrderLineEmpty = widget.salesOrder.orderLine.isEmpty;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Visibility(
                  visible: !isOrderLineEmpty &&
                      ['draft', 'cancel'].contains(widget.salesOrder.state),
                  child: AnimatedOpacity(
                    opacity: !isOrderLineEmpty ? 1.0 : 0.5,
                    duration: const Duration(milliseconds: 300),
                    child: _buildLeftButtons(),
                  ),
                ),
                Spacer(),
                Visibility(
                    visible: ['sent', 'sale', 'draft']
                        .contains(widget.salesOrder.state),
                    child: _buildDevisStatusWidget()),
              ],
            ),
          ),
          if (isOrderLineEmpty) ...[
            const Divider(),
            const Text(
              "No items in the order line!",
              style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }

  Widget _bodyInfoOrder() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClientSection(),
            const SizedBox(height: 10),
            const Divider(thickness: 5),
          ],
        ),
      ),
    );
  }

  Widget _buildClientSection() {
    return _buildSection("Client Information", [
      _buildRow(
        "Client Name",
        partner.name,
        "",
        partner.street?.toString() ?? "No Address",
      ),
      const Divider(thickness: 1),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: _buildRow(
              "Commandes",
              "Invoiced",
              "${partner.saleOrderCount ?? 0}",
              "${partner.totalInvoiced ?? 0.0} DH",
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 1,
            child: _buildRow(
              "Date Order",
              "Expected Date",
              widget.salesOrder.dateOrder?.toString() ?? "N/A",
              widget.salesOrder.expectedDate?.toString() ?? "N/A",
            ),
          ),
        ],
      ),
    ]);
  }

  Widget _buildRow(String label, String label2, String value, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // العمود الأول: Commandes و Invoiced
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  softWrap: false, // منع النص من الالتفاف
                  overflow:
                      TextOverflow.ellipsis, // إظهار "..." عند النصوص الطويلة
                  maxLines: 1, // بقاء النص في سطر واحد فقط
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  value,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10), // مسافة بين العمودين
          // العمود الثاني: Date Order و Expected Date
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label2,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  value2,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...content,
        ],
      ),
    );
  }

  Future<void> updateSaleOrderList({String? message}) async {
    await OrderModule.readOrders(
        ids: [widget.salesOrder.id],
        onResponse: (resOrder) {
          OrderModel order = resOrder.first;
          if (resOrder.isNotEmpty) {
            int index =
                PrefUtils.sales.indexWhere((element) => element.id == order.id);

            if (index != -1) {
              PrefUtils.sales[index] = order;
              PrefUtils.sales.refresh();
              setState(() {
                widget.salesOrder = order;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: message != null
                        ? Text("Order successfully $message")
                        : Text("Order successfully Updated")),
              );
            }
          }
        });
  }

  Widget _buildLeftButtons() {
    return Row(
      children: <Widget>[
        // زر Confirm: يظهر فقط إذا كانت الحالة 'draft'
        if (widget.salesOrder.state == 'draft')
          ButtonOrder(
            state: 'draft',
            order: widget.salesOrder,
            onUpdate: (idAccount) => updateSaleOrderList(message: "Confirmed"),
          ),
        const SizedBox(width: 8.0),
        // زر Revert to Draft: يظهر فقط إذا كانت الحالة 'cancel'
        if (widget.salesOrder.state == 'cancel')
          ButtonOrder(
            state: 'cancel',
            order: widget.salesOrder,
            onUpdate: (idAccount) => updateSaleOrderList(message: "Confirmed"),
          ),
      ],
    );
  }

  Widget _buildDevisStatusWidget() {
    bool isSale = widget.salesOrder.state == 'sale';
    bool isDraft = widget.salesOrder.state == 'draft';

    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            StepItem(title: 'Devis', isActive: isDraft),
            Expanded(
              child: Divider(
                color: Colors.green,
                thickness: 2,
                indent: 8,
                endIndent: 8,
              ),
            ),
            StepItem(title: 'Bon de Commande', isActive: isSale),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsTableOrderLine() {
    return Column(
      children: [
        // عنوان الجدول
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Order Line Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        // محتوى الجدول
        Expanded(
          child: Obx(() {
            if (orderLine.isNotEmpty) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20.0, // مسافة بين الأعمدة
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.grey.shade200),
                  dataRowColor: MaterialStateColor.resolveWith(
                    (states) => states.contains(MaterialState.selected)
                        ? Colors.grey.shade300
                        : Colors.white,
                  ),
                  headingTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  dataTextStyle:
                      const TextStyle(fontSize: 14, color: Colors.black87),
                  border: TableBorder.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Article'),
                    ),
                    DataColumn(
                      label: Text('Quantité'),
                    ),
                    DataColumn(
                      label: Text('Prix Unitaire'),
                    ),
                    DataColumn(
                      label: Text('Sous-Total'),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    orderLine.length,
                    (index) => DataRow(
                      color: MaterialStateColor.resolveWith((states) {
                        return index.isEven
                            ? Colors.grey.shade100
                            : Colors.white; // تظليل الصفوف بالتناوب
                      }),
                      cells: <DataCell>[
                        DataCell(Text(
                          orderLine[index].productId![1].toString(),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        )),
                        DataCell(Text(
                          orderLine[index].productUomQty.toString(),
                          textAlign: TextAlign.center,
                        )),
                        DataCell(Text(
                          "${orderLine[index].priceUnit.toStringAsFixed(2)} DH",
                          textAlign: TextAlign.right,
                        )),
                        DataCell(Text(
                          "${orderLine[index].priceTotal.toStringAsFixed(2)} DH",
                          textAlign: TextAlign.right,
                        )),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text(
                  "No products available for this order.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              );
            }
          }),
        ),
      ],
    );
  }

  Widget _buildTotalSection() {
    return BottomAppBar(
      shadowColor: Colors.blue,
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 10.0,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade100, // خلفية خفيفة للشريط
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade300, // خط علوي للشريط
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // توزيع المسافات بشكل متساوٍ
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // المبلغ قبل الضرائب
            Flexible(
              child: Text(
                'HT: ${widget.salesOrder.amountUntaxed.toStringAsFixed(2)} DH',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            // الضرائب
            Flexible(
              child: Text(
                'TVA: ${widget.salesOrder.amountTax.toStringAsFixed(2)} DH',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
            ),
            // الإجمالي
            Flexible(
              child: Text(
                'TTC: ${widget.salesOrder.amountTotal.toStringAsFixed(2)} DH',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StepperWidget extends StatelessWidget {
  const StepperWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          StepItem(title: 'Devis', isActive: true),
          const Expanded(
            child: Divider(
              color: Colors.green,
              thickness: 2,
              indent: 8,
              endIndent: 8,
            ),
          ),
          StepItem(title: 'Bon de Commande', isActive: false),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ButtonOrder extends StatefulWidget {
  final String state;
  OrderModel order;
  final Future<void> Function(int) onUpdate;

  ButtonOrder({
    super.key,
    required this.state,
    required this.order,
    required this.onUpdate,
  });

  @override
  State<ButtonOrder> createState() => _ButtonOrderState();
}

class _ButtonOrderState extends State<ButtonOrder> {
  @override
  Widget build(BuildContext context) {
    String buttonText;
    void Function()? onPresseded;

    switch (widget.state) {
      case 'draft':
        buttonText = 'Confirm';
        onPresseded = () async {
          await OrderModule.confirmOrder(
              args: [widget.order.id],
              onResponse: (resConfirm) async {
                if (widget.order.invoiceCount == 0) {
                  await widget.onUpdate(widget.order.id);
                }
              });
        };
        break;
      case 'cancel':
        buttonText = 'Revert to Draft';
        onPresseded = () async {
          await OrderModule.draftMethod(
              args: [widget.order.id],
              onResponse: (response) async {
                if (response) {
                  await widget.onUpdate(widget.order.id);
                }
              });
        };
        break;
      default:
        buttonText = '';
    }

    return Center(
      child: ElevatedButton(
        onPressed: onPresseded,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          elevation: 0,
          iconColor: Colors.blue,
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class StepItem extends StatelessWidget {
  final String title;
  final bool isActive;

  const StepItem({super.key, required this.title, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.circle_outlined,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
