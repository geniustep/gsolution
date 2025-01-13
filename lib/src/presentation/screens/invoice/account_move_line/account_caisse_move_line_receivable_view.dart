// import 'package:g_solution/import/import_file.dart';

// class AccountCaisseMoveLineReceivableView extends StatefulWidget {
//   const AccountCaisseMoveLineReceivableView({super.key});

//   @override
//   State<AccountCaisseMoveLineReceivableView> createState() =>
//       _AccountCaisseMoveLineReceivableViewState();
// }

// class _AccountCaisseMoveLineReceivableViewState
//     extends State<AccountCaisseMoveLineReceivableView> {
//   List<AccountMoveLineModel> accountMoveLine = [];
//   var newAccount = <AccountMoveLineModel>[].obs;
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     switch (index) {
//       case 0:
//         break;
//       case 1:
//         Get.find<Controller>().currentScreen.value =
//             ScreenInfo(builder: () => const AccountCaisseMoveLinePayableView());
//         // Navigator.push(
//         //     context, MaterialPageRoute(builder: (context) => NewPage()));
//         break;
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     setDomainAndFetchData('Total');
//   }

//   double totalCredit = 0.0;
//   String nameFilter = "Total";
//   void setDomainAndFetchData(filter) {
//     List<dynamic> domain = [];
//     if (filter == 'Espèces') {
//       nameFilter = "Espèces";
//       domain = [
//         [
//           "display_type",
//           "not in",
//           ["line_section", "line_note"]
//         ],
//         "&",
//         ["move_id.state", "=", "posted"],
//         ["account_id.internal_type", "=", "receivable"],
//         ["move_id.journal_id.type", "=", "cash"]
//       ];
//     } else if (filter == 'Banque') {
//       nameFilter = "Banque";
//       domain = [
//         [
//           "display_type",
//           "not in",
//           ["line_section", "line_note"]
//         ],
//         "&",
//         ["move_id.state", "=", "posted"],
//         ["account_id.internal_type", "=", "receivable"],
//         ["move_id.journal_id.type", "=", "bank"]
//       ];
//     } else {
//       nameFilter = "Total";
//       domain = [
//         "&",
//         ["account_id", "=", 620],
//         "&",
//         [
//           "display_type",
//           "not in",
//           ["line_section", "line_note"]
//         ],
//         ["move_id.state", "=", "posted"]
//       ];
//     }

//     getAccountMoveLine(domain).then((_) {
//       totalCredit = 0;
//       totalCredit = accountMoveLine.fold(0, (sum, item) => sum + item.credit);
//       setState(() {});
//     });
//   }

//   Future<void> getAccountMoveLine(List<dynamic> domain) async {
//     await AccountMoveLineModule.searchReadAccountMoveLine(
//       domain: domain,
//       onResponse: (response) {
//         setState(() {
//           accountMoveLine.clear();
//           newAccount.addAll(response[response.keys.toList()[0]]!);
//           accountMoveLine = newAccount.where((p0) => p0.credit != 0).toList();
//           totalCredit = 0;
//           totalCredit =
//               accountMoveLine.fold(0, (sum, item) => sum + item.credit);
//         });
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("La Caisse: $nameFilter"),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: setDomainAndFetchData,
//             itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//               const PopupMenuItem<String>(
//                 value: 'Total',
//                 child: Text('Total'),
//               ),
//               const PopupMenuItem<String>(
//                 value: 'Banque',
//                 child: Text('Banque'),
//               ),
//               const PopupMenuItem<String>(
//                 value: 'Espèces',
//                 child: Text('Espèces'),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 19,
//             child: ListView.builder(
//                 itemCount: accountMoveLine.length,
//                 itemBuilder: ((context, index) {
//                   var account = accountMoveLine[index];
//                   return ListTile(
//                     leading: Text(account.date.toString()),
//                     title: Text(
//                       account.partnerId != false
//                           ? account.partnerId[1].toString()
//                           : 'false',
//                     ),
//                     subtitle: Text(account.moveId[1].toString()),
//                     trailing: Text("${account.credit.toString()} DH"),
//                   );
//                 })),
//           ),
//           Expanded(
//             flex: 1,
//             child: Container(
//               child: Center(child: Text('$nameFilter: $totalCredit DH')),
//             ),
//           )
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Caisse Entrer',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.business),
//             label: 'Caisse Sortie',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
