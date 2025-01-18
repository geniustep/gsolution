import 'dart:async';
import 'package:gsolution/common/api_factory/models/resgroups/res_groups_model.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:gsolution/src/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final RxBool isReady = false.obs;
  int progress = 0;
  final Controller _apiController = Get.put(Controller());
  var products = <ProductModel>[].obs;
  var categoryProduct = <ProductCategoryModel>[].obs;
  var sales = <OrderModel>[].obs;
  var orderLine = <OrderLineModel>[].obs;
  var partners = <PartnerModel>[].obs;
  var accountMove = <AccountMoveModel>[].obs;
  var accountJournal = <AccountJournalModel>[].obs;
  var resGroups = <ResGroupsModel>[].obs;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();

    loadFromFuture();
  }

  Future<void> loadFromFuture() async {
    try {
      setState(() {});
      progress = 10;
      await _apiController.getResGroupsController(
          onResponse: (resGroupsOk) async {
        if (resGroupsOk) {
          await _apiController.getSettingsOdooController(
              onResponse: (resSettings) async {
            if (resSettings) {
              setState(() {});
              progress = 15;
              await _apiController.getProductsController(
                onResponse: (resProducts) async {
                  if (resProducts != null) {
                    products.addAll(resProducts);
                    await PrefUtils.setProducts(products);
                    setState(() {});
                    progress = 20;
                    await _apiController.getCategoryProductsController(
                      onResponse: (resCatg) async {
                        if (resCatg != null) {
                          categoryProduct.addAll(resCatg);
                          await PrefUtils.setCatgProducts(categoryProduct);
                          setState(() {});
                          progress = 25;
                          await _apiController.getSalesController(
                            onResponse: (resSales) async {
                              if (resSales != null) {
                                sales.addAll(resSales);
                                await PrefUtils.setSales(sales);
                                setState(() {});
                                progress = 30;
                                await _apiController.getSalesLineController(
                                  onResponse: (resSalesLine) async {
                                    orderLine.addAll(resSalesLine);
                                    await PrefUtils.setSalesLine(resSalesLine);
                                    setState(() {});
                                    progress = 35;
                                    await _apiController.getPartnersController(
                                      onResponse: (resPartners) async {
                                        if (resPartners != null) {
                                          partners.addAll(resPartners);
                                          await PrefUtils.setPartners(partners);
                                          setState(() {});
                                          progress = 40;
                                          await _apiController.getAccountMove(
                                            onResponse: (resAccountMove) async {
                                              if (resAccountMove != null) {
                                                accountMove
                                                    .addAll(resAccountMove);
                                                await PrefUtils.setAccountMove(
                                                    accountMove);
                                                setState(() {});
                                                progress = 45;
                                                await _apiController
                                                    .getAccountJournal(
                                                  onResponse:
                                                      (resAccountJournal) async {
                                                    if (resAccountJournal !=
                                                        null) {
                                                      accountJournal.addAll(
                                                          resAccountJournal);
                                                      await PrefUtils
                                                          .setAccountJournal(
                                                              accountJournal);
                                                      setState(() {});
                                                      progress = 100;
                                                      isReady.value = true;
                                                    }
                                                  },
                                                );
                                              }
                                            },
                                          );
                                        }
                                      },
                                    );
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
            }
          });
        }
      });
    } catch (e) {
      print('Error in loadFromFuture: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isReady.value) {
        Future.microtask(() => Get.offNamed(AppRoutes.dashboard));
        return const SizedBox();
      } else {
        return Scaffold(
          body: Container(
            width: double.maxFinite,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF005C97), Color(0xFF363795)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ScaleTransition(
                          scale: _animation,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: MediaQuery.of(context).size.width * 0.2,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/logo/login-logo.png",
                                    width: 60,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "G'SOLTUION",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // النصوص الإضافية
                      FadeTransition(
                        opacity: _animation,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              "$progress %",
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              "Powered By GENIUSTEP",
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "V 1.0.2",
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
