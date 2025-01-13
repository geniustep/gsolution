import 'package:flutter/foundation.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/src/presentation/screens/products/products_sections/update_product_screen.dart';

class ProductDetails extends StatelessWidget {
  final ProductModel product;
  final List<ProductModel> productList;
  final int currentIndex;

  const ProductDetails({
    super.key,
    required this.product,
    required this.productList,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.name.toUpperCase(),
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                buildModalBottomSheet(context, product);
              },
              icon: const Icon(Icons.edit)),
          if (currentIndex > 0)
            IconButton(
                onPressed: () {
                  final previousProduct = productList[currentIndex - 1];
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetails(
                        product: previousProduct,
                        productList: productList,
                        currentIndex: currentIndex - 1,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.chevron_left)),
          if (currentIndex < productList.length - 1)
            IconButton(
                onPressed: () {
                  final nextProduct = productList[currentIndex + 1];
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetails(
                        product: nextProduct,
                        productList: productList,
                        currentIndex: currentIndex + 1,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.chevron_right)),
        ],
      ),
      body: Column(
        children: [
          // عرض صورة المنتج
          _buildProductImage(context),
          // عرض تفاصيل المنتج
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم المنتج وسعره
                    _buildProductHeader(),
                    const SizedBox(height: 20),
                    // التصنيف والوصف
                    _buildProductDetails(),
                    const SizedBox(height: 20),
                    // معلومات إضافية (Pack, Sales Count)
                    _buildAdditionalInfo(),
                    const SizedBox(height: 20),
                    // زر لإضافة المنتج إلى السلة
                    _buildAddToCartButton(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showDialog(
          context: context,
          builder: (_) {
            final String imageToShow = kReleaseMode
                ? (product.image1920?.isNotEmpty ?? false
                    ? product.image1920
                    : "assets/images/other/empty_product.png")
                : "assets/images/other/empty_product.png";

            return ImageTap(imageToShow);
          },
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.35,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: product.image1920?.isNotEmpty ?? false
            ? buildImage(
                image: product.image1920,
              )
            // Image.memory(
            //     base64.decode(product.image_1920!),
            //     fit: BoxFit.cover,
            //   )
            : const Icon(
                Icons.no_photography,
                size: 100,
                color: Colors.grey,
              ),
      ),
    );
  }

  Widget _buildProductHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            product.name ?? "Unknown Product",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          "${product.lstPrice?.toStringAsFixed(2) ?? "0.00"} DH",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetails() {
    String removeHtmlTags(String input) {
      return input.replaceAll(RegExp(r'<[^>]*>'), '');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Catégorie: ${product.categId[1] ?? "N/A"}",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Description:",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          product.description != false && product.description != null
              ? removeHtmlTags(product.description)
              : "No description available.",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildInfoCard("Pack", product.volume?.toString() ?? "N/A"),
          _buildInfoCard(
              "Sales", "${product.sales_count?.toString() ?? "0"} sold"),
          _buildInfoCard("Unity", "${product.name ?? "N/A"}"),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.all(6),
      width: 120,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 2,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          // Logic لإضافة المنتج إلى السلة
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Product added to cart!")),
          );
        },
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text("Add to Cart"),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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
