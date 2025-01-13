import 'package:gsolution/common/config/import.dart';

class AccountMoveLineViewBalanceWindows extends StatefulWidget {
  const AccountMoveLineViewBalanceWindows({super.key});

  @override
  State<AccountMoveLineViewBalanceWindows> createState() =>
      _AccountMoveLineViewBalanceWindowsState();
}

class _AccountMoveLineViewBalanceWindowsState
    extends State<AccountMoveLineViewBalanceWindows> {
  final Controller _controller = Get.put(Controller());
  var accountMoveLine = <AccountMoveLineModel>[].obs;
  late Future<void> _futureAccountMoveLine;

  @override
  void initState() {
    super.initState();
    // _futureAccountMoveLine = _controller.getAccuontMoveLineControllerBalance(
    //   domain: [],
    //   onResponse: (response) {
    //     if (response != null) {
    //       accountMoveLine = _controller.accountMoveLine;
    //       getTotal(accountMoveLine);
    //     }
    //   },
    // );
  }

  double? totalDebit;
  double? totalCredit;
  final ScrollController _scrollController = ScrollController();

  void getTotal(List<AccountMoveLineModel> accountMoveLine) {
    totalDebit = accountMoveLine.map((item) => item.debit ?? 0.0).fold(
        0.0, (previousValue, currentValue) => previousValue! + currentValue);

    totalCredit = accountMoveLine.map((item) => item.credit ?? 0.0).fold(
        0.0, (previousValue, currentValue) => previousValue! + currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      appBarTitle: 'Account Move Line',
      actions: [
        IconButton(
          icon: const Icon(
            Icons.paid,
          ),
          onPressed: () {
            // Get.find<Controller>().currentScreen.value =
            //     ScreenInfo(builder: () => const CreateAcountPayment());
            // Get.to(const CreateAcountPayment());
          },
        )
      ],
      child: Obx(() {
        // if (_controller.accountMoveLine.isNotEmpty) {
        if (true) {
          return Column(
            children: [
              Expanded(
                flex: 10,
                child: FutureBuilder(
                  future: _futureAccountMoveLine,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return Scrollbar(
                        thumbVisibility: true,
                        controller: _scrollController,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: accountMoveLine.length,
                          itemBuilder: (context, index) {
                            var account = accountMoveLine[index];
                            double restCredit = account.debit - account.credit;
                            return ListTile(
                              leading: Text(account.date.toString()),
                              title: Text(account.partnerId[1].toString()),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Debit: ${account.moveId.toString()}'),
                                  Text('Debit: ${account.debit.toString()}'),
                                  const SizedBox(width: 15),
                                  Text('Credit: ${account.credit.toString()}'),
                                ],
                              ),
                              trailing: Text(restCredit.toString()),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Text('No Data');
                    }
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        child: Text(totalDebit?.toString() ?? ''),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: Text(totalCredit?.toString() ?? ''),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      }),
    );
  }
}
