import 'package:flutter/material.dart';
import 'package:gsolution/src/data/models/expense_model/expense_list_model.dart';
import 'package:gsolution/src/presentation/screens/expense_list/expense_list_sections/expense_card_section.dart';
import 'package:gsolution/src/presentation/screens/expense_list/expense_list_sections/expense_list_section.dart';
import 'package:gsolution/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:gsolution/src/presentation/widgets/floating_aciton_button/custom_floating_action_button.dart';
import 'package:gsolution/src/presentation/widgets/search_field/custom_search_Field.dart';
import 'package:gsolution/src/routes/app_routes.dart';

class ExpenseListMainScreen extends StatelessWidget {
  const ExpenseListMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar(navigateName: "Expense List"),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white70,
          child: Column(
            children: [
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: CustomSearchField(hintText: "Search Expense List")),
              const SizedBox(height: 20),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ExpenseCardSection()),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                  shrinkWrap: true,
                  itemCount: expenseListModel.length,
                  itemBuilder: (context, index) {
                    final expenseList = expenseListModel[index];
                    return ExpenseListSection(expenseList: expenseList);
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: const CustomFloatingActionButton(
            buttonName: "Add Expense", routeName: AppRoutes.expense));
  }
}
