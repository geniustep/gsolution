import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/src/utils/contstants.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final String buttonName;
  final dynamic routeName;
  final VoidCallback? onTap; // إضافة onTap كإجراء اختياري

  const CustomFloatingActionButton({
    super.key,
    required this.buttonName,
    required this.routeName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onPressed: () {
          if (onTap != null) {
            onTap!();
          } else {
            Get.toNamed(routeName);
          }
        },
        label: Text(
          buttonName,
          style: GoogleFonts.raleway(
              color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        icon: const Icon(
          Icons.add_circle_outline_rounded,
          color: Colors.white70,
          size: 24,
        ),
        backgroundColor: ColorSchema.primaryColor,
      ),
    );
  }
}
