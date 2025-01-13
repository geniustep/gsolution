import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gsolution/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:gsolution/src/presentation/widgets/text_field/text_field_section.dart';
import 'package:gsolution/src/presentation/widgets/toast/success_toast.dart';

class ExpenseCategoryUpdateSection extends StatelessWidget {
  final dynamic category;

  const ExpenseCategoryUpdateSection({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "Update Category",
                  style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Color(0xFF444444),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 26,
                  color: Color(0xFF444444),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey.shade300,
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              TextFieldSection(
                  label: "Category",
                  hint: category["category-name"],
                  inputType: TextInputType.text),
              const SizedBox(
                height: 20,
              ),
              TextFieldSection(
                  label: "Sub Category",
                  hint: category["subCategory-name"],
                  inputType: TextInputType.text),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CustomElevatedButton(
                    buttonName: "Update",
                    showToast: () {
                      SuccessToast.showSuccessToast(context, "Update Complete",
                          "Expense Category Update Complete");
                    }),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        )
      ],
    );
  }
}
