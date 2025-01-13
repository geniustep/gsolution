import 'package:gsolution/common/api_factory/models/invoice/account_payment/account_payment_module.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:intl/intl.dart';

class CreateAcountPayment extends StatefulWidget {
  const CreateAcountPayment({Key? key}) : super(key: key);

  @override
  State<CreateAcountPayment> createState() => _CreateAcountPaymentState();
}

class _CreateAcountPaymentState extends State<CreateAcountPayment> {
  var accountJournal = <AccountJournalModel>[].obs;
  // var hrExpense = <HrExpenseModel>[].obs;
  var product = <ProductModel>[].obs;
  // var employee = <EmployeeModel>[].obs;
  int size = 0;
  @override
  void initState() {
    List domain = [];
    // AccountJournalModule.searchReadAccountJournal(
    //     domain: domain,
    //     onResponse: ((response) {
    //       size = response.keys.toList()[0];
    //       accountJournal.addAll(response[size]!);
    //     }));
    // HrExpenseModule.searchReadHrExpense(
    //     domain: [],
    //     onResponse: ((response) {
    //       setState(() {
    //         size = response.keys.toList()[0];
    //         hrExpense.addAll(response[size]!);
    //       });
    //     }));
    // EmployeeModule.searchReadEmployee(onResponse: ((response) {
    //   setState(() {
    //     size = response.keys.toList()[0];
    //     employee.addAll(response[size]!);
    //   });
    // }));
    // PrefUtils.Employee;
    super.initState();
  }

  final _formKey = GlobalKey<FormBuilderState>();
  bool _noteHasError = false;
  // final _controllerName = TextEditingController();
  void _onChanged(dynamic val) => debugPrint(val.toString());

  double totalP = 0;
  @override
  Widget build(BuildContext context) {
    // String total = GetTotal();
    var qt;
    var pU;

    return MainContainer(
      drawer: CustomDrawer(),
      appBarTitle: "Create Payment",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FormBuilder(
              key: _formKey,
              onChanged: () {
                _formKey.currentState!.save();
                debugPrint(_formKey.currentState!.value.toString());
              },
              autovalidateMode: AutovalidateMode.disabled,
              skipDisabled: true,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // amount
                    FormBuilderTextField(
                      name: 'amount',
                      decoration: const InputDecoration(
                        hintText: '0.00 Dhs',
                        labelText: 'Amount',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        setState(() {
                          _noteHasError = !(_formKey
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
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      // initialValue: DateTime.now(),
                      inputType: InputType.date,
                      decoration: InputDecoration(
                        labelText: 'Payment Date',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _formKey.currentState!.fields['payment_date']
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
                      onChanged: _onChanged,
                      items: accountJournal
                          .map((v) => DropdownMenuItem(
                                value: v.id,
                                child: Text(v.name.toString()),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 15),
                    // Destinaion
                    FormBuilderDropdown(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(
                            Icons.person_pin,
                          ),
                          labelText: 'Destinaion'),
                      name: "destination_journal_id",
                      onChanged: _onChanged,
                      items: accountJournal
                          .map((v) => DropdownMenuItem(
                                value: v.id,
                                child: Text(v.name.toString()),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 15),
                    // Memo
                    FormBuilderTextField(
                      name: 'communication',
                      decoration: const InputDecoration(
                        hintText: '',
                        labelText: 'Memo',
                      ),
                      onChanged: (val) {
                        setState(() {
                          _noteHasError = !(_formKey
                                  .currentState?.fields['communication']
                                  ?.validate() ??
                              false);
                          val = qt;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          )),
          Card(
            elevation: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: const EdgeInsets.all(20),
                    child: OutlinedButton(
                        onPressed: () {
                          double totalP = double.parse(qt) * double.parse(pU);
                          print(totalP);
                        },
                        child: Text(totalP.toString()))),
                Container(
                    margin: const EdgeInsets.all(20),
                    child: ElevatedButton(
                        child: Text('Create'),
                        onPressed: (() {
                          if (_formKey.currentState?.saveAndValidate() ??
                              false) {
                            debugPrint(_formKey.currentState?.value.toString());
                            Map<String, dynamic>? maps =
                                _formKey.currentState?.value;
                            Map<String, dynamic> newMap = Map.from(maps!);
                            if (_formKey.currentState?.fields['payment_date'] !=
                                null) {
                              var date = _formKey
                                  .currentState?.fields['payment_date']!.value;
                              if (date != null) {
                                final DateFormat formatter =
                                    DateFormat('yyyy-MM-dd');

                                final String item = formatter.format(date);

                                newMap['payment_date'] = item;
                              }
                            }
                            newMap["amount"] = int.parse(newMap["amount"]);
                            newMap["payment_type"] = "transfer";

                            if (newMap["communication"] == null) {
                              newMap["communication"] = false;
                            }

                            newMap["currency_id"] = 112;
                            newMap["payment_difference_handling"] = "open";
                            newMap["writeoff_label"] = "Write-Off";
                            newMap["partner_type"] = false;
                            newMap["partner_id"] = false;
                            newMap["payment_token_id"] = false;
                            newMap["partner_bank_account_id"] = false;
                            newMap["writeoff_account_id"] = false;
                            newMap["message_attachment_count"] = 0;
                            newMap["payment_method_id"] = 2;

                            AccountPaymentModule.createAccountPayments(
                              maps: newMap,
                              onResponse: ((response) {
                                print(response);
                              }),
                            );
                            debugPrint('validation OK');
                          } else {
                            debugPrint(_formKey.currentState?.value.toString());
                            debugPrint('validation failed');
                          }

                          // Map<int, int> sales = widget.sales;
                          Map<String, dynamic> maps = <String, dynamic>{};
                        })))
              ],
            ),
          )
        ],
      ),
    );
  }
}
