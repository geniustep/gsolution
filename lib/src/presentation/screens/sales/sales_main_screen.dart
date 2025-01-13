import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:gsolution/src/presentation/screens/sales/saleorder/create/create_order_form.dart';
import 'package:gsolution/src/presentation/screens/sales/salesSections/horizontal_sales_table_section.dart';
import 'package:gsolution/src/presentation/widgets/date_picker_section/start_end_date_picker_section.dart';
import 'package:gsolution/src/presentation/widgets/drawer/dashboard_drawer.dart';
import 'package:gsolution/src/utils/contstants.dart';
import 'package:sidebarx/sidebarx.dart';

class SalesMainScreen extends StatefulWidget {
  const SalesMainScreen({super.key});

  @override
  State<SalesMainScreen> createState() => _SalesMainScreenState();
}

class _SalesMainScreenState extends State<SalesMainScreen> {
  final controller = SidebarXController(selectedIndex: 1, extended: true);
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  List<dynamic> sales = [];
  List<dynamic> filteredSales = [];
  List<dynamic> baseFilteredSales = [];
  DateTime? _startSelectedDate;
  DateTime? _endSelectedDate;
  bool isSearch = false;
  String searchQuery = '';

  void _loadSales() {
    sales = PrefUtils.sales;

    final now = DateTime.now();
    _startSelectedDate = DateTime(now.year, now.month, 1);
    _endSelectedDate = DateTime(now.year, now.month + 1, 0);

    _filterSales(_startSelectedDate, _endSelectedDate);
  }

  void _filterSales(DateTime? startDate, DateTime? endDate) {
    setState(() {
      baseFilteredSales = sales.where((sale) {
        final saleDate = DateTime.parse(sale.dateOrder);
        final saleDateWithoutTime =
            DateTime(saleDate.year, saleDate.month, saleDate.day);

        return (startDate == null ||
                saleDateWithoutTime
                    .isAfter(startDate.subtract(const Duration(days: 1)))) &&
            (endDate == null ||
                saleDateWithoutTime
                    .isBefore(endDate.add(const Duration(days: 1))));
      }).toList();
      filteredSales = List.from(baseFilteredSales);
    });
  }

  @override
  void initState() {
    _loadSales();
    super.initState();
  }

  List<dynamic> searchSales(String query) {
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
      filteredSales =
          query.isEmpty ? List.from(baseFilteredSales) : searchSales(query);
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: HorizontalSalesTableSection(
                sales: filteredSales,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: () async {
            await Get.to(() => const CreateOrder());
          },
          label: Text(
            "Create Sale",
            style: GoogleFonts.raleway(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          icon: const Icon(
            Icons.shopping_cart,
            color: Colors.white70,
            size: 24,
          ),
          backgroundColor: ColorSchema.primaryColor,
        ),
      ),
    );
  }
}
