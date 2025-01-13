import 'package:flutter/foundation.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/src/data/models/people_model/customer_list_model.dart';
import 'package:gsolution/src/presentation/screens/customer/partner/partner.dart';
import 'package:gsolution/src/presentation/screens/customer/partner/update/res_partner_update.dart';
import 'package:gsolution/src/presentation/widgets/toast/delete_toast.dart';

class CustomerListSection extends StatefulWidget {
  final List<PartnerModel> partners;
  const CustomerListSection(this.partners, {super.key});
  @override
  State<CustomerListSection> createState() => _CustomerListSectionState();
}

class _CustomerListSectionState extends State<CustomerListSection> {
  bool isChampsValid(dynamic champs) {
    return champs != null && champs != false && champs != "";
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.partners.length,
      itemBuilder: (context, index) {
        final customer = widget.partners[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                InkWell(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (_) {
                        final String imageToShow = kReleaseMode
                            ? (isChampsValid(customer.image1920)
                                ? customer.image1920
                                : "assets/images/other/empty_product.png")
                            : "assets/images/other/empty_product.png";

                        return ImageTap(imageToShow);
                      },
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: buildImage(
                      image: customer.image_512,
                    ),
                  ),
                ),
                const SizedBox(width: 12), // مسافة بين الصورة والتفاصيل
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.to(() => Partner(partner: customer));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Partner Name
                            Expanded(
                              child: Text(
                                customer.name,
                                style: GoogleFonts.raleway(
                                  color: const Color(0xFF5D6571),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            isChampsValid(customer.saleOrderCount)
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEB019)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/icon_svg/reward_icon.svg",
                                          width: 18,
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Text(customer.saleOrderCount.toString(),
                                            style: GoogleFonts.nunito(
                                              color: const Color(0xFF5D6571),
                                              fontWeight: FontWeight.w600,
                                            ))
                                      ],
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        isChampsValid(customer.email)
                            ? Row(
                                children: [
                                  const Icon(
                                    Icons.email_outlined,
                                    size: 20,
                                    color: Color(0xFFA0A0A3),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Text(
                                      customer.email.toString(),
                                      style: GoogleFonts.nunito(
                                        color: const Color(0xFFA0A0A3),
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  )
                                ],
                              )
                            : Container(),
                        const SizedBox(
                          height: 8,
                        ),
                        isChampsValid(customer.mobile)
                            ? Row(
                                children: [
                                  const Icon(
                                    Icons.phone_android_sharp,
                                    size: 20,
                                    color: Color(0xFFA0A0A3),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    customer.mobile.toString(),
                                    style: GoogleFonts.nunito(
                                      color: const Color(0xFFA0A0A3),
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              )
                            : Container(),
                        const SizedBox(
                          height: 8,
                        ),
                        isChampsValid(customer.street)
                            ? Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 20,
                                    color: Color(0xFFA0A0A3),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Text(
                                      customer.street.toString(),
                                      style: GoogleFonts.nunito(
                                        color: const Color(0xFFA0A0A3),
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  )
                                ],
                              )
                            : Container(),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_svg/group_icon.svg",
                                  width: 18,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  customer.active.toString(),
                                  style: GoogleFonts.nunito(
                                      color: const Color(0xFF5D6571),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.blue.shade50.withOpacity(0.5),
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
                                      buildModalBottomSheet(context, customer);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.red.shade50.withOpacity(0.5),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      DeleteToast.showDeleteToast(
                                          context, customer.name);
                                      setState(() {
                                        customerListModel.removeAt(index);
                                      });
                                    },
                                    icon: SvgPicture.asset(
                                      "assets/icons/icon_svg/delete_icon.svg",
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void buildModalBottomSheet(BuildContext context, customer) {
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
          child: UpdatePartner(customer),
        );
      },
    );
  }
}
