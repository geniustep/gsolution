import 'package:gsolution/common/api_factory/controllers/controller.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:gsolution/src/screen/homepage.dart';

class SplashScreenApp extends StatefulWidget {
  const SplashScreenApp({super.key});

  @override
  State<SplashScreenApp> createState() => _SplashScreenAppState();
}

class _SplashScreenAppState extends State<SplashScreenApp> {
  bool isReady = false;
  bool isAdmin = false;
  int progress = 0;
  final Controller _controller = Get.put(Controller());
  var products = <ProductModel>[].obs;
  var categoryProduct = <ProductCategoryModel>[].obs;
  var partners = <PartnerModel>[].obs;
  var sales = <OrderModel>[].obs;
  var orderLine = <OrderLineModel>[].obs;

  // var employees = <EmployeeModel>[].obs;
  // var secteurs = <Secteurs>[].obs;
  // var users = <UserModel>[].obs;
  // var user = UserModel().obs;
  // var employee = EmployeeModel().obs;
  // var salesOrder = <OrderModel>[].obs;
  // var purchaseOrder = <PurchaseModel>[].obs;
  // var accountMove = <AccountMoveModel>[].obs;
  // var accountJournalModel = <AccountJournalModel>[].obs;
  // var hrExpense = <HrExpenseModel>[].obs;
  @override
  initState() {
    super.initState();
    //logoutApi();
    loadFromFuture();
    if (PrefUtils.user.value.isAdmin == true) {
      setState(() {
        isAdmin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.categoryProduct.isNotEmpty) {
        return isReady ? Homepage() : const CircularProgressIndicator();
      } else {
        return Material(
          child: Center(
            child: Text("$progress %"),
          ),
        );
      }
    });
  }

  Future<void> loadFromFuture() async {
    try {
      await _controller.getProductsController(
        onResponse: (resProducts) async {
          if (resProducts != null && resProducts.isNotEmpty) {
            products.addAll(resProducts);
            await PrefUtils.setProducts(products);
            await _controller.getCategoryProductsController(
              onResponse: (resCatg) async {
                if (resCatg != null && resCatg.isNotEmpty) {
                  categoryProduct.addAll(resCatg);
                  await PrefUtils.setCatgProducts(categoryProduct);
                  await _controller.getSalesController(
                    onResponse: (resSales) async {
                      if (resSales != null && resSales.isNotEmpty) {
                        sales.addAll(resSales);
                        await PrefUtils.setSales(sales);
                        await _controller.getSalesLineController(
                          onResponse: (resSalesLine) async {
                            orderLine.addAll(resSalesLine);
                            await PrefUtils.setSalesLine(resSalesLine);
                            setState(() {
                              progress = 100;
                              isReady = true;
                            });
                          },
                        );
                      }
                    },
                  );
                }
              },
            );
          } else {
            print('Error: Invalid key or null data in resProducts');
          }
        },
      );
    } catch (e) {
      print('Error in loadFromFuture: $e');
      rethrow;
    }
  }
}
