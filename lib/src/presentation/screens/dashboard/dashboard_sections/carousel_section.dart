import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselSection extends StatelessWidget {
  const CarouselSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 35),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 150.0,
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          viewportFraction: 0.92,
          autoPlayInterval: const Duration(seconds: 10),
          autoPlayAnimationDuration: const Duration(milliseconds: 1400),
          autoPlayCurve: Curves.fastOutSlowIn,
          scrollDirection: Axis.horizontal,
        ),
        items: [
          "assets/images/offer/banner.png",
          "assets/images/offer/banner.png",
          "assets/images/offer/banner.png",
          "assets/images/offer/banner.png",
          "assets/images/offer/banner.png",
        ].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    i,
                    fit: BoxFit.cover, // لتحسين ملء الصورة
                    errorBuilder: (context, error, stackTrace) {
                      // في حال كانت الصورة غير موجودة، يظهر عنصر فارغ
                      return const Center(
                        child: Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
