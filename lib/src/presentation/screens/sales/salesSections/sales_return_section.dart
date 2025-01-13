import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gsolution/src/data/models/sales_model/sales_return_model.dart';
import 'package:gsolution/src/presentation/screens/sales/salesSections/edit_sales_return_section.dart';
import 'package:gsolution/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:gsolution/src/presentation/widgets/search_field/custom_search_Field.dart';
import 'package:gsolution/src/presentation/widgets/toast/delete_toast.dart';

class SalesReturnSection extends StatefulWidget {
  const SalesReturnSection({super.key});

  @override
  State<SalesReturnSection> createState() => _SalesReturnSectionState();
}

class _SalesReturnSectionState extends State<SalesReturnSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(navigateName: "Sales Return"),
      ),
      body: Container(
        color: Colors.white70,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomSearchField(hintText: "Search Sales Return"),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: salesReturnModel.length,
                itemBuilder: (context, index) {
                  final purchase = salesReturnModel[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(purchase["customerName"],
                                    style: GoogleFonts.raleway(
                                      color: const Color(0xFF5D6571),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    )),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/icon_svg/remark_icon.svg",
                                        width: 18,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(purchase["remark"],
                                          style: GoogleFonts.nunito(
                                              color: const Color(0xFF5D6571),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.date_range_outlined,
                                  size: 20,
                                  color: Color(0xFFA0A0A3),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  purchase["date"],
                                  style: GoogleFonts.nunito(
                                    color: const Color(0xFFA0A0A3),
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: SvgPicture.asset(
                                    "assets/icons/icon_svg/warehouse.svg",
                                    color: const Color(0xFFA0A0A3),
                                    width: 16,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2.0),
                                  child: Text(
                                    purchase["warehouse"],
                                    style: GoogleFonts.nunito(
                                      color: const Color(0xFFA0A0A3),
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: SvgPicture.asset(
                                    "assets/icons/icon_svg/reference_icon.svg",
                                    color: const Color(0xFFA0A0A3),
                                    width: 16,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2.0),
                                  child: Text(
                                    purchase["reference"],
                                    style: GoogleFonts.nunito(
                                      color: const Color(0xFFA0A0A3),
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 7.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_svg/dollar_icon.svg",
                                      width: 28,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      purchase["grandTotal"],
                                      style: GoogleFonts.nunito(
                                          color: const Color(0xFF5D6571),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.blue.shade50
                                              .withOpacity(0.5),
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
                                            buildModalBottomSheet(
                                                context, purchase);
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.red.shade50
                                              .withOpacity(0.5),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            DeleteToast.showDeleteToast(context,
                                                purchase["customerName"]);
                                            setState(() {
                                              salesReturnModel.removeAt(index);
                                            });
                                          },
                                          icon: SvgPicture.asset(
                                            "assets/icons/icon_svg/delete_icon.svg",
                                            color: Colors.red,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  void buildModalBottomSheet(BuildContext context, purchase) {
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
          height: MediaQuery.of(context).size.height * 0.7,
          child: EditSalesReturnSection(purchase: purchase),
        );
      },
    );
  }
}
