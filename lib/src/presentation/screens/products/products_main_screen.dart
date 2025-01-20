import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gsolution/common/api_factory/models/product/product_model.dart';
import 'package:gsolution/common/widgets/BarcodeScannerPage.dart';
import 'package:gsolution/src/presentation/screens/products/products_sections/product-list_section.dart';
import 'package:gsolution/src/presentation/widgets/drawer/dashboard_drawer.dart';
import 'package:gsolution/src/presentation/widgets/floating_aciton_button/custom_floating_action_button.dart';
import 'package:gsolution/src/routes/app_routes.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  final RxList<ProductModel> products =
      <ProductModel>[].obs; // المنتجات الأصلية
  final RxList<ProductModel> filteredProducts =
      <ProductModel>[].obs; // المنتجات المفلترة
  final RxBool isSearching = false.obs; // حالة البحث
  final RxMap<String, List<ProductModel>> productIndex =
      <String, List<ProductModel>>{}.obs;

  @override
  void initState() {
    super.initState();
    products.assignAll(Hive.box<ProductModel>('productsBox').values.toList());
    if (products.isNotEmpty) {
      _loadProducts();
      filteredProducts.assignAll(products);
      _buildIndex(); // بناء الفهرس بعد تحميل البيانات
    }
  }

  void _buildIndex() {
    productIndex.clear();
    for (var product in products) {
      final key = product.name.toLowerCase();

      if (productIndex.containsKey(key)) {
        productIndex[key]!
            .add(product); // 🔹 إذا كان الاسم موجودًا، أضف المنتج إلى القائمة
      } else {
        productIndex[key] = [
          product
        ]; // 🔹 إذا لم يكن الاسم موجودًا، أنشئ قائمة جديدة
      }
    }
  }

  void _loadProducts() {
    categories.addAll(
      products
          .map((product) => (product.categId[1] ?? "Uncategorized").toString())
          .toSet()
          .cast<String>(),
    );

    _tabController = TabController(length: categories.length, vsync: this);

    _tabController.addListener(() {
      if (!isSearching.value && _tabController.index < categories.length) {
        final selectedCategory = categories[_tabController.index];
        _filterByCategory(selectedCategory);
      }
    });
  }

  void _filterByCategory(String category) {
    final filteredList = products.where((product) {
      final productCategory = product.categId[1] ?? "Uncategorized";
      return productCategory == category;
    }).toList();

    filteredProducts.clear(); // مسح القائمة المفلترة قبل التحديث
    filteredProducts.addAll(filteredList); // تحديث القائمة الجديدة
    filteredProducts.refresh(); // 🔥 إجبار GetX على تحديث الواجهة
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
      filteredProducts.assignAll(products);
      isSearching.value = false;
    } else {
      final searchKey = value.toLowerCase();

      // 🔥 البحث في الاسم والباركود
      final results = <ProductModel>[];

      // البحث في الفهرس
      productIndex.forEach((key, productList) {
        if (key.contains(searchKey)) {
          results.addAll(productList); // 🔹 إضافة كل المنتجات التي تطابق البحث
        }
      });

      // البحث في الباركود
      final barcodeResults = products.where((product) {
        return product.barcode != null &&
            product.barcode is String &&
            (product.barcode as String).toLowerCase().contains(searchKey);
      }).toList();

      results.addAll(barcodeResults);

      filteredProducts.assignAll(results);
      filteredProducts.refresh();
    }
  }

  void _addProduct(ProductModel product) {
    products.add(product);

    final key = product.name.toLowerCase();

    // 🔥 تحديث الفهرس لدعم المنتجات المتكررة
    if (productIndex.containsKey(key)) {
      productIndex[key]!
          .add(product); // 🔹 إذا كان الاسم موجودًا، أضف المنتج إلى القائمة
    } else {
      productIndex[key] = [product]; // 🔹 إذا لم يكن موجودًا، أنشئ قائمة جديدة
    }

    filteredProducts.add(product);
    Hive.box<ProductModel>('productsBox').put(product.name, product);
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
            _addProduct(newProduct);
          }
        },
      ),
    );
  }
}
