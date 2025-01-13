import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:gsolution/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:gsolution/src/presentation/widgets/toast/success_toast.dart';

class CategoryMainScreen extends StatefulWidget {
  const CategoryMainScreen({Key? key}) : super(key: key);

  @override
  State<CategoryMainScreen> createState() => _CategoryMainScreenState();
}

class _CategoryMainScreenState extends State<CategoryMainScreen> {
  InputDecoration inputDecoration(String? name, Widget? suffixIcon) {
    return InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        suffixIcon: suffixIcon,
        labelText: name);
  }

  final _formKey = GlobalKey<FormBuilderState>();
  final Map<String, dynamic> _dataMap = {};
  bool noteHasError = false;

  bool isSelected = false;
  String? name;
  int? parentId;
  int? id;
  int? selectedIndex;

  void _onChanged(dynamic val) {
    debugPrint(val.toString());
    _formKey.currentState!.save();
    debugPrint(_formKey.currentState!.value.toString());
  }

  Widget? suffixIcon() {
    return noteHasError != false
        ? const Icon(Icons.error, color: Colors.red)
        : const Icon(Icons.check, color: Colors.green);
  }

  void _updateFormFields(
      String? newName, int? newParentId, int? newId, int index) {
    setState(() {
      name = newName;
      parentId = newParentId;
      id = newId;
      isSelected = true;
      selectedIndex = index;
      _formKey.currentState?.fields['name']?.didChange(newName);
      _formKey.currentState?.fields['parent_id']?.didChange(newParentId);
    });
  }

  void _resetForm() {
    setState(() {
      name = null;
      parentId = null;
      id = null;
      isSelected = false;
      selectedIndex = null;
      _formKey.currentState?.reset();
    });
  }

  void _deleteProductCategory(int categoryId) {
    ProductCategoryModule.deleteProductCategory(
        context: context,
        id: categoryId,
        onResponse: (response) {
          if (response != null) {
            setState(() {
              PrefUtils.categoryProduct
                  .removeWhere((cat) => cat.id == categoryId);
              PrefUtils.categoryProduct.refresh();
            });
            SuccessToast.showSuccessToast(
                context, "Delete Complete", "Category Deleted Successfully");
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _resetForm,
            tooltip: "Create New Category",
          ),
        ],
      ),
      body: FormBuilder(
        key: _formKey,
        onChanged: () {
          _formKey.currentState!.save();
          debugPrint(_formKey.currentState!.value.toString());
        },
        autovalidateMode: AutovalidateMode.disabled,
        skipDisabled: true,
        child: Container(
          color: Colors.white70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: FormBuilderTextField(
                  name: "name",
                  initialValue: isSelected ? name : null,
                  decoration: inputDecoration('Category Name', suffixIcon()),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: FormBuilderDropdown(
                  name: "parent_id",
                  decoration: inputDecoration('Category Parent', suffixIcon()),
                  onChanged: _onChanged,
                  items: PrefUtils.categoryProduct
                      .map((v) =>
                          DropdownMenuItem(value: v.id, child: Text(v.name!)))
                      .toList(),
                  initialValue: isSelected ? parentId : null,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomElevatedButton(
                    buttonName:
                        isSelected ? "Update Category" : 'Create Category',
                    showToast: () {
                      Map<String, dynamic>? formData =
                          _formKey.currentState?.value;
                      if (formData != null) {
                        _dataMap.addAll(formData);
                      }
                      if (!isSelected) {
                        ProductCategoryModule.createProductCategory(
                            maps: _dataMap,
                            onResponse: (response) {
                              if (response != null) {
                                setState(() {
                                  PrefUtils.categoryProduct.add(response);
                                  PrefUtils.categoryProduct.refresh();
                                });
                                SuccessToast.showSuccessToast(
                                    context,
                                    "Create Complete",
                                    "Category ${_dataMap['name']} Created");
                              }
                            });
                      } else {
                        ProductCategoryModule.updateProductCategory(
                            id: id!,
                            maps: _dataMap,
                            onResponse: (response) {
                              if (response != null) {
                                setState(() {
                                  final index = PrefUtils.categoryProduct
                                      .indexWhere((cat) => cat.id == id);
                                  if (index != -1) {
                                    PrefUtils.categoryProduct[index] = response;
                                  }
                                  PrefUtils.categoryProduct.refresh();
                                });
                                SuccessToast.showSuccessToast(
                                    context,
                                    "Update Complete",
                                    "Category ${_dataMap['name']} Updated");
                              }
                            });
                      }
                    }),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Products Category",
                  style: GoogleFonts.raleway(
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: PrefUtils.categoryProduct.length,
                  itemBuilder: (context, index) {
                    final cat = PrefUtils.categoryProduct[index];
                    return InkWell(
                      onTap: () {
                        _updateFormFields(
                            cat.name,
                            cat.parentId != false ? cat.parentId[0] : null,
                            cat.id,
                            index);
                        debugPrint('$name and $parentId');
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: selectedIndex == index
                              ? Colors.blue.shade50
                              : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            cat.name,
                            style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: const Color(0xFF444444),
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              cat.parentId != false
                                  ? cat.parentId[1].toString()
                                  : "",
                              style: GoogleFonts.nunito(),
                            ),
                          ),
                          trailing: selectedIndex == index
                              ? IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () =>
                                      _deleteProductCategory(cat.id!),
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
