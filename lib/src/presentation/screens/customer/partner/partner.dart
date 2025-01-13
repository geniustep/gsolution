import 'dart:collection';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:gsolution/src/presentation/screens/customer/partner/update/res_partner_update.dart';
import 'package:gsolution/src/presentation/screens/sales/saleorder/create/create_order_form.dart';

class Partner extends StatefulWidget {
  final PartnerModel partner;
  const Partner({super.key, required this.partner});

  @override
  State<Partner> createState() => _PartnerState();
}

class _PartnerState extends State<Partner> with SingleTickerProviderStateMixin {
  GoogleMapController? _googleMapController;
  CameraPosition? _kGooglePlex;
  Set<Circle> _circles = {};
  HashSet<Marker> _markers = HashSet<Marker>();
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _subTotal = 0;
  var childs = <PartnerModel>[].obs;

  @override
  void initState() {
    super.initState();
    _initializeGoogleMap();
    _setupAnimation();
    _calculateSubTotal();
    if (widget.partner.childIds != null && widget.partner.childIds.isNotEmpty) {
      childs.assignAll(
        PrefUtils.partners.where((partner) {
          return widget.partner.childIds.contains(partner.id);
        }).toList(),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _googleMapController?.dispose();
    super.dispose();
  }

  void _initializeGoogleMap() {
    // إعداد الكاميرا والمواقع
    setState(() {
      _kGooglePlex = CameraPosition(
        target: LatLng(
            widget.partner.partnerLatitude!, widget.partner.partnerLongitude!),
        zoom: 14,
      );
      _markers.add(Marker(
        markerId: const MarkerId('marker'),
        position: LatLng(
            widget.partner.partnerLatitude!, widget.partner.partnerLongitude!),
      ));
    });
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    final curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  void _calculateSubTotal() {
    // حساب المجموع الفرعي بناءً على الحسابات
    setState(() {
      // _subTotal = widget.partner.totalInvoiced - widget.partner.amountPaid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.partner.name!),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showContactOptions,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGoogleMap(),
            const SizedBox(height: 20),
            _buildPartnerDetails(),
            const SizedBox(height: 20),
            _buildFinancialInfo(),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Branches:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildPartnerChilds(),
              ],
            )
            // _buildSaleOrders(),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildGoogleMap() {
    return SizedBox(
      height: 200,
      child: _kGooglePlex == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: _kGooglePlex!,
              myLocationEnabled: true,
              circles: _circles,
              markers: _markers,
              onMapCreated: (controller) {
                _googleMapController = controller;
              },
            ),
    );
  }

  Widget _buildPartnerDetails() {
    return Row(
      children: [
        InkWell(
          onTap: () async {
            await showDialog(
              context: context,
              builder: (_) {
                final String? imageFromPartner = widget.partner.image1920;
                final String imageToShow =
                    (imageFromPartner != null && imageFromPartner.isNotEmpty)
                        ? imageFromPartner
                        : "assets/images/other/empty_product.png";

                return ImageTap(imageToShow);
              },
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.width * 0.2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey, width: 2),
            ),
            child: ClipOval(
              child: buildImage(
                image: kReleaseMode
                    ? widget.partner.image1920
                    : "assets/images/other/empty_product.png",
                width: MediaQuery.of(context).size.width * 0.2,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.partner.name!,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 5),
              Text("Ref: ${widget.partner.id}"),
              Text("Street: ${widget.partner.street ?? ''}"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPartnerChilds() {
    if (childs.isEmpty) {
      return const Center(
        child: Text(
          "No branches available",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true, // لتقليل الحجم حسب المحتوى
      physics:
          const NeverScrollableScrollPhysics(), // لتجنب التمرير داخل التمرير الرئيسي
      itemCount: childs.length,
      itemBuilder: (context, index) {
        final branch = childs[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: InkWell(
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (_) {
                    final String imageToShow = kReleaseMode
                        ? (branch.image1920?.isNotEmpty ?? false
                            ? branch.image1920
                            : "assets/images/other/empty_product.png")
                        : "assets/images/other/empty_product.png";

                    return ImageTap(imageToShow);
                  },
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: ClipOval(
                  child: buildImage(
                    image: kReleaseMode
                        ? branch.image1920
                        : "assets/images/other/empty_product.png",
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                ),
              ),
            ),
            title: Text(
              branch.name ?? "No Name",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Function: ${branch.function ?? 'No Function'}"),
                Text("Phone: ${branch.phone ?? 'No Phone'}"),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // حدث ينفذ عند النقر على العميل الفرعي
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Partner(partner: branch),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFinancialInfo() {
    return Column(
      children: [
        _buildInfoCard("Reste à payer", "$_subTotal Dhs"),
        _buildInfoCard("Total Facturé", "${widget.partner.totalInvoiced} Dhs"),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.125),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "$title: $value",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionBubble(
      iconColor: Colors.white,
      backGroundColor: Colors.blue,
      animation: _animation,
      iconData: Icons.add,
      onPress: () => _animationController.isCompleted
          ? _animationController.reverse()
          : _animationController.forward(),
      items: <Bubble>[
        Bubble(
          title: "Check In",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.checklist_sharp,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    children: [
                      // CreateMailPartner(widget.partner)
                    ],
                  ),
                );
              },
            );
            _animationController.reverse();
          },
        ),
        Bubble(
          title: "Update Customers",
          iconColor: Colors.white,
          bubbleColor: Colors.green,
          icon: Icons.people,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            Get.to(UpdatePartner(widget.partner));
            _animationController.reverse();
          },
        ),
        Bubble(
          title: "Create Sales Order",
          iconColor: Colors.white,
          bubbleColor: Colors.orange,
          icon: Icons.shop_two_outlined,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            Get.off(CreateOrder(partner: widget.partner));
            _animationController.reverse();
          },
        ),
      ],
    );
  }

  void _showContactOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListTile(
        leading: const Icon(Icons.phone),
        title: const Text("Call"),
        onTap: () {
          Navigator.pop(context);
          // Perform call
        },
      ),
    );
  }
}
