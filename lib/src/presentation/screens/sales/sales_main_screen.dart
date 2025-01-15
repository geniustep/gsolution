import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gsolution/common/api_factory/models/order/sale_order_model.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:gsolution/src/presentation/screens/sales/saleorder/create/create_order_form.dart';
import 'package:gsolution/src/presentation/screens/sales/saleorder/view/sale_order_view_detaille.dart';
import 'package:gsolution/src/presentation/screens/sales/salesSections/horizontal_sales_table_section.dart';
import 'package:gsolution/src/presentation/widgets/date_picker_section/start_end_date_picker_section.dart';
import 'package:gsolution/src/presentation/widgets/drawer/dashboard_drawer.dart';
import 'package:sidebarx/sidebarx.dart';

class SalesMainScreen extends StatefulWidget {
  const SalesMainScreen({super.key});

  @override
  State<SalesMainScreen> createState() => _SalesMainScreenState();
}

class _SalesMainScreenState extends State<SalesMainScreen> {
  final controller = SidebarXController(selectedIndex: 1, extended: true);
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  static RxList<OrderModel> sales = <OrderModel>[].obs;
  static RxList<OrderModel> filteredSales = <OrderModel>[].obs;
  static RxList<OrderModel> baseFilteredSales = <OrderModel>[].obs;
  DateTime? _startSelectedDate;
  DateTime? _endSelectedDate;
  bool isSearch = false;
  String searchQuery = '';

  void _loadSales() {
    sales.assignAll(PrefUtils.sales);
    print(sales.length);
    final now = DateTime.now();
    _startSelectedDate = DateTime(now.year, now.month, 1);
    _endSelectedDate = DateTime(now.year, now.month + 1, 0);

    _filterSales(_startSelectedDate, _endSelectedDate);
  }

  void _filterSales(DateTime? startDate, DateTime? endDate) {
    setState(() {
      baseFilteredSales.assignAll(sales.where((sale) {
        final saleDate = DateTime.parse(sale.dateOrder);
        final saleDateWithoutTime =
            DateTime(saleDate.year, saleDate.month, saleDate.day);

        return (startDate == null ||
                saleDateWithoutTime
                    .isAfter(startDate.subtract(const Duration(days: 1)))) &&
            (endDate == null ||
                saleDateWithoutTime
                    .isBefore(endDate.add(const Duration(days: 1))));
      }).toList());

      filteredSales.assignAll(baseFilteredSales);
    });
  }

  @override
  void initState() {
    _loadSales();
    super.initState();
  }

  List<OrderModel> searchSales(String query) {
    return baseFilteredSales.where((sale) {
      final saleName = sale.name?.toLowerCase() ?? '';
      final customerName = sale.partnerId?[1]?.toLowerCase() ?? '';
      final sellerName = sale.userId?[1]?.toLowerCase() ?? '';
      final searchQuery = query.toLowerCase();

      return saleName.contains(searchQuery) ||
          customerName.contains(searchQuery) ||
          sellerName.contains(searchQuery);
    }).toList();
  }

  void _performSearch(String query) {
    setState(() {
      searchQuery = query;

      if (query.isEmpty) {
        filteredSales.assignAll(baseFilteredSales);
      } else {
        filteredSales.assignAll(searchSales(query));
      }
    });
  }

  void _openFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Filter Options",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StartEndDatePickerSection(
                onDateChanged: (startDate, endDate) {
                  _startSelectedDate = startDate;
                  _endSelectedDate = endDate;
                  _filterSales(startDate, endDate);
                  Navigator.pop(context);
                },
                initialStartDate: _startSelectedDate,
                initialEndDate: _endSelectedDate,
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      final now = DateTime.now();
                      _startSelectedDate = DateTime(now.year, now.month, 1);
                      _endSelectedDate = DateTime(now.year, now.month + 1, 0);
                      _filterSales(_startSelectedDate, _endSelectedDate);
                      Navigator.pop(context);
                    });
                  },
                  child: const Text(
                    "Reset Filter",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _navigateToDetail(dynamic sale) async {
    final navigationFunction =
        Get.currentRoute.contains('/CreateOrder') ? Get.off : Get.to;

    final result =
        await navigationFunction(() => SaleOrderViewDetaille(salesOrder: sale));

    if (result == true) {
      _loadSales();
    } else {
      _loadSales();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double totalSalesAmount = filteredSales
        .fold(0.0, (sum, sale) => sum + (sale.amountTotal ?? 0.0))
        .ceilToDouble();
    return Scaffold(
      key: _key,
      endDrawer: Drawer(
        child: DashboardDrawer(routeName: "Trading", controller: controller),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isSearch
              ? TextField(
                  key: const ValueKey('searchBar'),
                  onChanged: _performSearch,
                  decoration: InputDecoration(
                    hintText: 'Search by Sale Name, Customer, or Seller',
                    hintStyle: GoogleFonts.nunito(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                )
              : Column(
                  key: const ValueKey('dateAndStats'),
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _startSelectedDate != null
                        ? Text(
                            "Date: ${_startSelectedDate?.month}/${_startSelectedDate?.day}/${_startSelectedDate?.year} - ${_endSelectedDate?.month}/${_endSelectedDate?.day}/${_endSelectedDate?.year}",
                            style: GoogleFonts.raleway(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            'ALL YOUR SALES',
                            style: GoogleFonts.raleway(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                    Text(
                      'Sales: ${filteredSales.length} Total: $totalSalesAmount DH',
                      style: GoogleFonts.abyssinicaSil(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isSearch ? Icons.close : Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                isSearch = !isSearch;
                if (!isSearch) {
                  // Reset search results when closing the search bar
                  _performSearch('');
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: _openFilterDialog,
          ),
        ],
      ),
      body: Container(
        color: Colors.white70,
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                return HorizontalSalesTableSection(
                  sales: filteredSales.toList(),
                  onSaleTap: _navigateToDetail,
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Get.to(() => CreateOrder(
                onSaleTap: _navigateToDetail,
              ));
        },
        label: Text("Create Sale"),
        icon: Icon(Icons.shopping_cart),
      ),
    );
  }
}
