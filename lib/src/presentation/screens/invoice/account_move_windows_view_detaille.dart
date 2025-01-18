import 'package:gsolution/common/api_factory/models/invoice/account_journal/account_journal_module.dart';
import 'package:gsolution/common/api_factory/models/invoice/account_payment/account_payment_module.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:gsolution/src/presentation/widgets/viewer/pdfviewer.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AccountMoveWindowsViewDetaille extends StatefulWidget {
  AccountMoveModel accountMove;
  AccountMoveWindowsViewDetaille({super.key, required this.accountMove});

  @override
  State<AccountMoveWindowsViewDetaille> createState() =>
      _AccountMoveWindowsViewDetailleState();
}

class _AccountMoveWindowsViewDetailleState
    extends State<AccountMoveWindowsViewDetaille> {
  final GlobalKey<FormBuilderState> _formKeyOne = GlobalKey<FormBuilderState>();
  final Controller _controller = Get.put(Controller());
  PartnerModel partner = PartnerModel();
  var accountMoveLine = <AccountMoveLineModel>[].obs;
  bool isOrderLine = false;
  Map<String, dynamic> maps = <String, dynamic>{};
  List<AccountJournalModel> accountJournal = [];
  var accountMove = <AccountMoveModel>[].obs;
  double totalAmount = 0.0;
  int totalPai = 0;
  List<int> idsAccountMove = [];
  int defaultAccountId = 0;
  int idpaymentAccountIdInbound = 0;
  int idpaymentAccountIdOutbound = 0;
  @override
  void initState() {
    super.initState();

    initializeData();
  }

  void initializeData() async {
    await filterAccountJournals();
    await fetchPaymentAccountIds();
    await fetchAccountMoveLines();
    await calculatePayments();
  }

  fetchPaymentAccountIds() {
    if (idsAccountMove.isNotEmpty) {
      AccountJournalModule.webReadAccountJournal(
        ids: idsAccountMove,
        onResponse: (response) {
          for (var e in response) {
            if (e is Map<String, dynamic>) {
              defaultAccountId = e['default_account_id'];
              checkAndWriteIfNeeded(e, defaultAccountId);
            }
          }
        },
      );
    }
  }

  void checkAndWriteIfNeeded(
      Map<String, dynamic> journalData, int defaultAccount) {
    bool isAccountMissing = true;

    // التحقق في inbound_payment_method_line_ids
    final inbound = journalData['inbound_payment_method_line_ids'];
    if (inbound is List<dynamic>) {
      for (var item in inbound) {
        if (item is Map<String, dynamic>) {
          idpaymentAccountIdInbound = item['id'];
          if (item['payment_account_id'] != false) {
            final paymentAccountId = item['payment_account_id']?['id'];
            if (paymentAccountId == defaultAccount) {
              isAccountMissing = false;
              break;
            }
          }
        }
      }
    }

    // التحقق في outbound_payment_method_line_ids
    final outbound = journalData['outbound_payment_method_line_ids'];
    if (outbound is List<dynamic> && isAccountMissing) {
      for (var item in outbound) {
        if (item is Map<String, dynamic>) {
          if (item['payment_account_id'] == false && item['name'] != "Checks") {
            idpaymentAccountIdOutbound = item['id'];
          }
          if (item['payment_account_id'] != false) {
            final paymentAccountId = item['payment_account_id']?['id'];
            if (paymentAccountId == defaultAccount) {
              isAccountMissing = false;
              break;
            }
          }
        }
      }
    }

    if (isAccountMissing) {
      executeWriteFunction(
        journalId: journalData['id'],
        paymentAccountId: defaultAccount,
        idpaymentAccountIdInbound: idpaymentAccountIdInbound,
        idpaymentAccountIdOutbound: idpaymentAccountIdOutbound,
      );
    }
  }

  void executeWriteFunction({
    required int journalId,
    required int paymentAccountId,
    required int idpaymentAccountIdInbound,
    required int idpaymentAccountIdOutbound,
  }) {
    Map<String, dynamic> updates = {
      "inbound_payment_method_line_ids": [
        [
          1,
          idpaymentAccountIdInbound,
          {"payment_account_id": paymentAccountId}
        ]
      ],
      "outbound_payment_method_line_ids": [
        [
          1,
          idpaymentAccountIdOutbound,
          {"payment_account_id": paymentAccountId}
        ]
      ],
    };

    AccountJournalModule.writeAccount(
      journalId: journalId,
      updates: updates,
      onResponse: (response) {
        print("Write operation successful: $response");
      },
      onError: (error, details) {
        print("Error during write operation: $error");
      },
    );
  }

  filterAccountJournals() {
    for (var element in PrefUtils.accountJournal) {
      if (element.type.toString().toLowerCase().contains("bank") ||
          element.type.toString().toLowerCase().contains("cash")) {
        accountJournal.add(element);
        idsAccountMove.add(element.id);
      }
    }
  }

  fetchAccountMoveLines() {
    List<int> idsA = [];
    if (widget.accountMove.invoiceLineIds is List<dynamic>) {
      for (var element in widget.accountMove.invoiceLineIds) {
        if (element is Map<String, dynamic>) {
          idsA.add(element['id']);
        } else {
          idsA.add(element);
        }
      }
    } else {
      idsA.addAll(widget.accountMove.invoiceLineIds!.cast<int>());
    }
    _controller.getAccuontMoveLineController(
      ids: idsA,
      onResponse: (response) {
        if (response != null) {
          setState(() {
            accountMoveLine.assignAll(_controller.accountMoveLine);
          });
        }
      },
    );
  }

  calculatePayments() {
    if (widget.accountMove.invoicePaymentsWidget != false) {
      setState(() {
        var pai = widget.accountMove.invoicePaymentsWidget ?? {};
        if (pai != false && pai['content'] != null) {
          totalAmount = 0;
          for (var payment in pai['content']) {
            totalAmount += payment['amount'];
          }
          totalPai = pai['content'].length;
        }
      });
    }
  }

  bool noteHasError = false;

  void _onChanged(dynamic val) => debugPrint(val.toString());

  void updateAccountMoveList(
      AccountMoveModel updatedMove, String? message) async {
    int index =
        PrefUtils.sales.indexWhere((element) => element.id == updatedMove.id);
    // await PrefUpdate.updateItem<AccountMoveModel>(
    //     key: PrefKeys.accountMove,
    //     newItem: updatedMove,
    //     fromJson: (json) => AccountMoveModel.fromJson(json),
    //     toJson: (account) => account.toJson(),
    //     getListFunction: () => PrefUtils.accountMove);

    if (index != -1) {
      // List<AccountMoveModel> updatedList = List.from(_controller.accountMove);
      // updatedList[index] = updatedMove;
      // _controller.accountMove.assignAll(updatedList);
      PrefUtils.accountMove[index] = updatedMove;
      PrefUtils.accountMove.refresh();
      setState(() {
        widget.accountMove = updatedMove;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: message != null
                ? Text("Order successfully $message")
                : Text("Order successfully Updated")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facture: ${widget.accountMove.name}'),
        actions: <Widget>[
          if (widget.accountMove.statusInPayment != "paid")
            IconButton(
              icon: const Icon(Icons.add_task),
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    title: Text(
                      "Payment",
                      style: AppFont.Title_H4_Medium(),
                    ),
                    content: FormBuilder(
                      key: _formKeyOne,
                      onChanged: () {
                        _formKeyOne.currentState!.save();
                        debugPrint(_formKeyOne.currentState!.value.toString());
                      },
                      autovalidateMode: AutovalidateMode.disabled,
                      skipDisabled: true,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // amount
                            FormBuilderTextField(
                              name: 'amount',
                              initialValue:
                                  widget.accountMove.amountResidual.toString(),
                              decoration: const InputDecoration(
                                hintText: '0.00 Dhs',
                                labelText: 'Amount',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                setState(() {
                                  noteHasError = !(_formKeyOne
                                          .currentState?.fields['amount']
                                          ?.validate() ??
                                      false);
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            // Date
                            FormBuilderDateTimePicker(
                              validator: (value) {
                                if (value!.isAfter(DateTime.now())) {
                                  Get.snackbar(
                                    "Dates",
                                    'can\'t be before Date Now.',
                                    colorText: Colors.red,
                                  );
                                }
                                return null;
                              },
                              name: 'payment_date',
                              initialDate: DateTime.now(),
                              initialValue: DateTime.now(),
                              initialEntryMode:
                                  DatePickerEntryMode.calendarOnly,
                              // initialValue: DateTime.now(),
                              inputType: InputType.date,
                              decoration: InputDecoration(
                                labelText: 'Payment Date',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _formKeyOne
                                        .currentState!.fields['payment_date']
                                        ?.didChange(null);
                                  },
                                ),
                              ),
                              initialTime: const TimeOfDay(hour: 8, minute: 0),
                              // locale: const Locale.fromSubtags(languageCode: 'fr'),
                            ),
                            const SizedBox(height: 15),
                            // journal
                            FormBuilderDropdown(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  icon: Icon(
                                    Icons.person_pin,
                                  ),
                                  labelText: 'Journal'),
                              name: "journal_id",
                              initialValue: accountJournal[1].id,
                              onChanged: _onChanged,
                              items: accountJournal
                                  .map((v) => DropdownMenuItem(
                                        value: v.id,
                                        child: Text(
                                            "${v.displayName} ${v.companyId[1]}"),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          if (_formKeyOne.currentState?.saveAndValidate() ??
                              false) {
                            debugPrint(
                                _formKeyOne.currentState?.value.toString());
                            Map<String, dynamic>? maps =
                                _formKeyOne.currentState?.value;
                            Map<String, dynamic> context = {};
                            context["active_model"] = "account.move";
                            context["active_id"] = widget.accountMove.id;
                            context["active_ids"] = [widget.accountMove.id];
                            context["default_type"] = "out_invoice";

                            Map<String, dynamic> newMap = Map.from(maps!);
                            if (_formKeyOne
                                    .currentState?.fields['payment_date'] !=
                                null) {
                              var date = _formKeyOne
                                  .currentState?.fields['payment_date']!.value;
                              if (date != null) {
                                final DateFormat formatter =
                                    DateFormat('yyyy-MM-dd');

                                final String item = formatter.format(date);

                                newMap['payment_date'] = item;
                              }
                            }
                            newMap["amount"] = double.parse(newMap["amount"]);
                            newMap["payment_type"] = "inbound";
                            newMap["communication"] = widget.accountMove.name;
                            newMap["payment_difference_handling"] = "open";
                            newMap["writeoff_label"] = "";
                            newMap["partner_type"] = "customer";
                            newMap["partner_id"] =
                                widget.accountMove.partnerId[0];

                            AccountPaymentModule.actionRegisterPayment(
                                id: widget.accountMove.id,
                                onResponse: (resAction) {
                                  AccountPaymentModule
                                      .webSaveCreateAccountPayments(
                                          id: widget.accountMove.id,
                                          activeIds: resAction,
                                          maps: newMap,
                                          onResponse: (resPai) {
                                            AccountPaymentModule
                                                .actionCreatePayments(
                                                    id: [resPai],
                                                    activeIds: resAction,
                                                    onResponse:
                                                        (resActionCreate) {
                                                      Get.back();
                                                      updateAccount();
                                                    });
                                          });
                                });

                            debugPrint('validation OK');
                          } else {
                            debugPrint(
                                _formKeyOne.currentState?.value.toString());
                            debugPrint('validation failed');
                          }

                          // Map<int, int> sales = widget.sales;
                          // Map<String, dynamic> maps =
                          //     <String, dynamic>{};
                        },
                        child: Text(
                          "Create",
                          style: AppFont.Body2_Regular(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // AccountMoveModule.printAccountMovePdf(
              //     id: widget.accountMove.id,
              //     onResponse: (response) {
              //       fetchAndShowPdfDialog(context, response);
              //     });
              AccountMoveModule.printAccountMovePdfwithDue(
                  onResponse: (response) {
                    fetchAndShowPdfDialog(context, response);
                  },
                  id: widget.accountMove.id);
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          _buildButtonAction(),
          const Divider(),
          _bodyInfoOrder(),
          const Divider(),
          const Divider(),
          _buildItemsTable(),
        ],
      ),
      bottomNavigationBar: _buildTotalSection(),
    );
  }

  Widget _paymentInfo() {
    var pai = widget.accountMove.invoicePaymentsWidget ?? {};
    if (pai != false && pai['content'] != null) {
      totalAmount = 0;
      for (var payment in pai['content']) {
        totalAmount += payment['amount'];
      }
      totalPai = pai['content'].length;
      return ListView.builder(
        itemCount: pai['content'].length,
        itemBuilder: (context, index) {
          var payment = pai['content'][index];
          return ListTile(
            leading: const Icon(Icons.payment),
            title: Text(
                "Payé Le ${payment['date']}: ${payment['amount_company_currency']} => ${payment['journal_name']} "),
          );
        },
      );
    } else {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.warning),
          title: Text("Non Montant Dû"),
        ),
      );
    }
  }

  Widget _buildButtonAction() {
    setState(() {
      if (widget.accountMove.invoiceLineIds != null &&
          widget.accountMove.invoiceLineIds.isEmpty) {
        isOrderLine = true;
      }
    });
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Button
                Visibility(visible: !isOrderLine, child: _buildLeftButtons()),
                // Status
                _buildDevisStatusWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodyInfoOrder() {
    return Container(
      padding: const EdgeInsets.all(6),
      child: Column(children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Clients:'),
                      const VerticalDivider(
                        width: 20,
                        thickness: 5,
                        indent: 30,
                        endIndent: 20,
                        color: Colors.black,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.accountMove.partnerId[1].toString()),
                          // Text(partner.city.toString()),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Contact:'),
                      const VerticalDivider(
                        width: 20,
                        thickness: 5,
                        indent: 30,
                        endIndent: 20,
                        color: Colors.black,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(partner.phone.toString()),
                          // Text(partner.email.toString()),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const VerticalDivider(
              width: 20,
              thickness: 5,
              endIndent: 20,
              color: Colors.black,
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date Facture:'),
                            Divider(),
                            Text('Devis N°:'),
                            Divider(),
                            Text('Clients:'),
                            Divider(),
                            Text('Etaps de paiment:'),
                          ],
                        ),
                        const VerticalDivider(
                          width: 20, // The width of the divider
                          thickness:
                              5, // The thickness of the line in the divider
                          endIndent:
                              20, // The spacer from the bottom of the divider
                          color: Colors.black, // The color of the divider
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(widget.accountMove.date.toString()),
                            const Divider(),
                            Text(widget.accountMove.invoiceOrigin.toString()),
                            const Divider(),
                            Text(widget.accountMove.partnerId[1].toString()),
                            const Divider(),
                            Text(widget.accountMove.invoicePaymentState != false
                                ? widget.accountMove.invoicePaymentState
                                    .toString()
                                : "null"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  updateAccount() async {
    await AccountMoveModule.webReadAccountMove(
        ids: [widget.accountMove.id],
        onResponse: (resOrder) {
          if (resOrder.isNotEmpty) {
            AccountMoveModel updatedAccount = resOrder[0];
            updateAccountMoveList(updatedAccount, 'INVOICE');
          }
        });
  }

  Widget _buildLeftButtons() {
    return Row(
      children: <Widget>[
        ButtonOrder(
          state: widget.accountMove.state,
          account: widget.accountMove,
          onUpdate: updateAccount,
        ),
        const SizedBox(width: 8.0),
        ButtonOrder(
          state: "annuler",
          account: widget.accountMove,
          onUpdate: updateAccount,
        ),
      ],
    );
  }

  Widget _buildDevisStatusWidget() {
    bool isSale = false;
    bool isDraft = false;
    if (widget.accountMove.state == 'posted') {
      setState(() {
        isSale = true;
        isDraft = true;
      });
    }
    if (widget.accountMove.state == 'draft') {
      setState(() {
        isDraft = true;
      });
    }
    return Flexible(
        fit: FlexFit.loose,
        child: Container(
          width: 200,
          // padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              StepItem(title: 'Brouillon', isActive: isDraft),
              const Expanded(child: Divider(color: Colors.green, thickness: 2)),
              StepItem(title: 'Comptabilisé', isActive: isSale),
            ],
          ),
        ));
  }

  Widget _buildItemsTable() {
    return Expanded(
      child: ListView(
        children: <Widget>[
          Obx(() {
            // if (_controller.accountMoveLine.isNotEmpty) {
            if (true) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                        label: Text(
                      'Article',
                      // style: TextStyle(color: MyTheme.primaryTextLight),
                    )),
                    DataColumn(
                        label: Text(
                      'Description',
                      // style: TextStyle(color: MyTheme.primaryTextLight),
                    )),
                    DataColumn(
                        label: Text(
                      'Quantité',
                      // style: TextStyle(color: MyTheme.primaryTextLight),
                    )),
                    DataColumn(
                        label: Text(
                      'Udm',
                      // style: TextStyle(color: MyTheme.primaryTextLight),
                    )),
                    DataColumn(
                        label: Text(
                      'Prix Unitaire',
                      // style: TextStyle(color: MyTheme.primaryTextLight),
                    )),
                    DataColumn(
                        label: Text(
                      'Sous-Total',
                      // style: TextStyle(color: MyTheme.primaryTextLight),
                    )),
                  ],
                  rows: List<DataRow>.generate(
                    accountMoveLine.length,
                    (index) => DataRow(
                      cells: <DataCell>[
                        DataCell(Text(accountMoveLine[index].productId != false
                            ? accountMoveLine[index].productId[1].toString()
                            : 'false')),
                        DataCell(Text(accountMoveLine[index].name.toString())),
                        DataCell(
                            Text(accountMoveLine[index].quantity.toString())),
                        DataCell(Text(accountMoveLine[index].productUomId !=
                                false
                            ? accountMoveLine[index].productUomId[1].toString()
                            : "false")),
                        DataCell(
                            Text(accountMoveLine[index].priceUnit.toString())),
                        DataCell(
                            Text(accountMoveLine[index].priceTotal.toString())),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    return BottomAppBar(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (widget.accountMove.invoicePaymentsWidget != "false")
              ElevatedButton(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: Text("Total des avances est $totalPai"),
                      content: Container(
                        height: 200,
                        width: 400,
                        child: Center(child: _paymentInfo()),
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text("Total: $totalAmount DH"))
                      ],
                    ),
                  );
                },
                child: Text("Montant pai: $totalAmount DH"),
              ),
            Text("Montant dû: ${widget.accountMove.amountResidual} DH"),
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
      width: 200,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          StepItem(title: 'Brouillon', isActive: true),
          Expanded(child: Divider(color: Colors.green, thickness: 2)),
          StepItem(title: 'Comptabilisé', isActive: false),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ButtonOrder extends StatelessWidget {
  final String state;
  AccountMoveModel account;
  final VoidCallback onUpdate;
  ButtonOrder({
    super.key,
    required this.state,
    required this.account,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    String buttonText;
    void Function()? onPresseded;
    switch (state) {
      case 'draft':
        buttonText = 'Brouillon';
        onPresseded = () async {
          await AccountMoveModule.comptabliseInvoiceSales(
              args: [account.id],
              onResponse: (resCompta) async {
                onUpdate();
              });
        };
        break;
      case 'annuler':
        buttonText = 'Annuler';
        onPresseded = () {};
        break;
      case 'cancel':
        buttonText = 'Mettre en Devis';
        onPresseded = () async {};
        break;
      default:
        buttonText = "";
    }
    return Center(
      child: buttonText == ""
          ? Container()
          : ElevatedButton(
              onPressed: onPresseded,
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide.none,
                ),
                padding: EdgeInsets.zero,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: state == "annuler"
                        ? [Colors.grey.shade400, Colors.grey.shade600]
                        : [Colors.lightBlue.shade300, Colors.blue.shade600],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  constraints: const BoxConstraints(
                      maxWidth: 100.0, maxHeight: 30.0), // Button size
                  alignment: Alignment.center,
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      color: Colors.white, // Text color
                    ),
                  ),
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF000000),
          width: 1,
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    );
  }
}
