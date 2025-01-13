import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gsolution/common/api_factory/models/product/product_model.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:gsolution/common/widgets/BarcodeScannerPage.dart';
import 'package:gsolution/src/presentation/screens/products/products_sections/product-list_section.dart';
import 'package:gsolution/src/presentation/widgets/drawer/dashboard_drawer.dart';
import 'package:gsolution/src/presentation/widgets/floating_aciton_button/custom_floating_action_button.dart';
import 'package:gsolution/src/routes/app_routes.dart';
import 'package:sidebarx/sidebarx.dart';

class ProductsMainScreen extends StatefulWidget {
  const ProductsMainScreen({super.key});

  @override
  State<ProductsMainScreen> createState() => _ProductsMainScreenState();
}

class _ProductsMainScreenState extends State<ProductsMainScreen>
    with TickerProviderStateMixin {
  final controller = SidebarXController(selectedIndex: 1, extended: true);
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  final RxString filter = ''.obs; // النص المستخدم للبحث
  final TextEditingController searchController = TextEditingController();
  late TabController _tabController;
  final List<String> categories = <String>[];
  final RxList<ProductModel> products = PrefUtils.products; // المنتجات الأصلية
  final RxList<ProductModel> filteredProducts =
      <ProductModel>[].obs; // المنتجات المفلترة
  final RxBool isSearching = false.obs; // حالة البحث

  @override
  void initState() {
    super.initState();
    _loadProducts();
    filteredProducts.assignAll(products); // بدء القائمة بنفس المنتجات الأصلية

    // مستمع لتغيير التبويبة
    _tabController.addListener(() {
      if (!isSearching.value) {
        final selectedCategory = categories[_tabController.index];
        _filterByCategory(selectedCategory);
      }
    });
  }

  void _loadProducts() {
    // تجهيز التصنيفات من products.categId[1]
    categories.addAll(
      products
          .map((product) => (product.categId[1] ?? "Uncategorized").toString())
          .toSet()
          .cast<String>(),
    );

    // إعداد TabController بناءً على عدد التصنيفات
    _tabController = TabController(length: categories.length, vsync: this);
  }

  void _filterByCategory(String category) {
    filteredProducts.assignAll(
      products.where((product) {
        final productCategory = product.categId[1] ?? "Uncategorized";
        return productCategory == category;
      }).toList(),
    );
  }

  Future<void> scanBarcode() async {
    String? barcode = await Get.to(() => const BarcodeScannerPage());

    if (barcode != null && barcode.isNotEmpty) {
      searchController.text = barcode;
      filter.value = barcode; 
      isSearching.value = true; 
      _searchProducts(barcode); 
      Get.snackbar(
        "Scan Cancelled",
        "No barcode was scanned.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _searchProducts(String value) {
    if (value.isEmpty) {
      // عرض جميع المنتجات عند عدم وجود نص بحث
      filteredProducts.assignAll(products);
      isSearching.value = false;
    } else {
      filteredProducts.assignAll(
        products.where((product) {
          final nameMatch =
              product.name.toLowerCase().contains(value.toLowerCase());
          final barcodeMatch = product.barcode != null &&
              product.barcode is String &&
              (product.barcode as String)
                  .toLowerCase()
                  .contains(value.toLowerCase());
          return nameMatch || barcodeMatch;
        }).toList(),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      endDrawer: DashboardDrawer(routeName: "Products", controller: controller),
      appBar: AppBar(
        title: Text(
          "Product List",
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // مربع البحث
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // حقل البحث بالنص
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      filter.value = value; // تحديث النص المدخل للبحث
                      isSearching.value = value.isNotEmpty; // تفعيل حالة البحث
                      _searchProducts(value); // تحديث القائمة
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Search for products...",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // زر المسح باستخدام الكاميرا
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: scanBarcode,
                ),
              ],
            ),
          ),
          // التصنيفات (TabBar)
          if (!isSearching.value)
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: categories.map((category) => Tab(text: category)).toList(),
            ),
          // عرض المنتجات
          Expanded(
            child: Obx(() {
              if (filteredProducts.isEmpty) {
                return const Center(
                  child: Text("No products match your search."),
                );
              }
              // عرض المنتجات
              return ProductListSection(
                isSmallScreen: MediaQuery.of(context).size.width < 600,
                productList: filteredProducts,
              );
            }),
          ),
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        buttonName: "Add Product",
        routeName: AppRoutes.addProduct,
        onTap: () async {
          final newProduct = await Get.toNamed(AppRoutes.addProduct);
          if (newProduct != null && newProduct is ProductModel) {
            products.add(newProduct);
            filteredProducts.add(newProduct); // تحديث القائمة المفلترة
          }
        },
      ),
    );
  }
}
