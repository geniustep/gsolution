import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gsolution/common/api_factory/models/partner/partner_model.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:gsolution/src/presentation/screens/customer/customer_sections/customer_list_section.dart';
import 'package:gsolution/src/presentation/widgets/drawer/dashboard_drawer.dart';
import 'package:gsolution/src/presentation/widgets/floating_aciton_button/custom_floating_action_button.dart';
import 'package:gsolution/src/routes/app_routes.dart';
import 'package:sidebarx/sidebarx.dart';

class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({super.key});

  @override
  State<CustomerMainScreen> createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  final controller = SidebarXController(selectedIndex: 1, extended: true);
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  final TextEditingController _searchController = TextEditingController();
  // var partners = <PartnerModel>[].obs;
  var partners = PrefUtils.partners.obs;
  List<PartnerModel> _filteredPartners = [];
  bool isSearch = false;
  @override
  void initState() {
    super.initState();
    _filteredPartners.addAll(PrefUtils.partners
        .where((partner) => partner.customerRank > 0)
        .toList());
  }

  void _filterCustomers(String query) {
    final filtered = PrefUtils.partners
        .where((partner) => partner.customerRank > 0)
        .toList()
        .where((partner) {
      final name = partner.name.toLowerCase();
      final input = query.toLowerCase();
      return name.contains(input);
    }).toList();

    setState(() {
      _filteredPartners = filtered;
    });

    if (query != '') {
      setState(() {
        isSearch = true;
      });
    } else {
      isSearch = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      key: _key,
      endDrawer: DashboardDrawer(routeName: "Customer", controller: controller),
      appBar: isSmallScreen
          ? AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: true,
              centerTitle: true,
              surfaceTintColor: Colors.white,
              title: Text(
                "Customer",
                style: GoogleFonts.raleway(
                  textStyle: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.keyboard_arrow_left,
                  size: 30,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Get.toNamed(
                      AppRoutes.partnerMaps,
                      arguments: {
                        'partners': _filteredPartners,
                        'isSearch': isSearch,
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.map_sharp,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_key.currentState != null) {
                      _key.currentState?.openEndDrawer();
                    }
                  },
                  icon: const Icon(
                    Icons.menu,
                    size: 30,
                  ),
                ),
              ],
            )
          : null,
      body: Container(
        color: Colors.white70,
        child: Column(
          children: [
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search Customer",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: _filterCustomers, // تصفية القائمة عند الكتابة
              ),
            ),
            const SizedBox(height: 20),
            // قائمة العملاء
            Expanded(
              child: CustomerListSection(_filteredPartners),
            ),
          ],
        ),
      ),
      floatingActionButton: const CustomFloatingActionButton(
        buttonName: "Create Customer",
        routeName: AppRoutes.createPartner,
      ),
    );
  }
}
