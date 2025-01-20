import 'package:flutter/foundation.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:gsolution/src/presentation/screens/products/products_sections/update_product_screen.dart';
import 'package:gsolution/src/presentation/widgets/toast/delete_toast.dart';

class ProductListSection extends StatefulWidget {
  final bool isSmallScreen;
  final RxList<ProductModel> productList;

  const ProductListSection({
    super.key,
    required this.isSmallScreen,
    required this.productList,
  });

  @override
  State<ProductListSection> createState() => _ProductListSectionState();
}

class _ProductListSectionState extends State<ProductListSection> {
  bool isChampsValid(dynamic champs) {
    return champs != null && champs != false && champs != "";
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.productList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/other/empty_product.png",
                width: 350,
              ),
              Text(
                "No Product Found",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  color: const Color(0xFF333333),
                ),
              )
            ],
          ),
        );
      } else {
        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: widget.productList.length,
          itemBuilder: (context, index) {
            final int id;
            final product = widget.productList[index];
            if (product.productTmplId != null) {
              id = product.productTmplId[0];
            } else {
              id = product.id;
            }

            return Card(
                elevation: 0,
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (_) {
                            final String imageToShow = kReleaseMode
                                ? (isChampsValid(product.image1920)
                                    ? product.image1920
                                    : "assets/images/other/empty_product.png")
                                : "assets/images/other/empty_product.png";

                            return ImageTap(imageToShow);
                          },
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: buildImage(
                          image: kReleaseMode
                              ? product.image512
                              : "assets/images/other/empty_product.png",
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => ProductDetails(
                                product: product,
                                productList: widget.productList,
                                currentIndex: index,
                              ));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: widget.isSmallScreen ? 16 : 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 8, top: 6),
                                child: Text(
                                  product.categId[1] ?? '',
                                  style: GoogleFonts.raleway(
                                    textStyle: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Stock: ${product.qtyAvailable}",
                                        style: GoogleFonts.nunito(),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Stock Virtual: ${product.virtualAvailable}",
                                        style: GoogleFonts.nunito(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Price: ${product.lstPrice} Dh",
                                    style: GoogleFonts.nunito(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blue.shade50.withOpacity(0.3),
                            ),
                            child: IconButton(
                              icon: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: SvgPicture.asset(
                                  "assets/icons/icon_svg/edit_icon.svg",
                                  color: Colors.blue,
                                ),
                              ),
                              onPressed: () {
                                buildModalBottomSheet(context, product);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.red.shade50.withOpacity(0.3),
                            ),
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: const Text("Delete!"),
                                      content: Text(
                                          'Do you want to delete "${product.name}"?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();
                                          },
                                          child: const Text(
                                            "Cancel",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            final validContext = context;

                                            // تنفيذ عملية الحذف
                                            ProductModule.deleteProduct(
                                                context: context,
                                                id: id,
                                                onResponse: (response) {
                                                  if (response) {
                                                    PrefUtils.products
                                                        .removeWhere((p) {
                                                      if (p.productTmplId !=
                                                              null &&
                                                          id ==
                                                              p.productTmplId[
                                                                  0]) {
                                                        return true;
                                                      } else if (id == p.id) {
                                                        return true;
                                                      }
                                                      return false;
                                                    });

                                                    PrefUtils.setProducts(
                                                        PrefUtils.products);
                                                    DeleteToast.showDeleteToast(
                                                        validContext,
                                                        product.name);

                                                    // تحديث قائمة المنتجات إذا كان العنصر لا يزال موجودًا
                                                    if (mounted) {
                                                      setState(() {
                                                        widget.productList
                                                            .removeAt(index);
                                                      });
                                                    }
                                                  }
                                                });
                                            // إغلاق نافذة التأكيد
                                            Navigator.of(dialogContext).pop();
                                          },
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: SvgPicture.asset(
                                "assets/icons/icon_svg/delete_icon.svg",
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ));
          },
        );
      }
    });
  }

  void buildModalBottomSheet(BuildContext context, dynamic product) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      elevation: 0,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      context: context,
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: UpdateProductScreen(product: product),
        );
      },
    );
  }
}
