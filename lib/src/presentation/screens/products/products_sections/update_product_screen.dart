import 'dart:io';
import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:gsolution/common/widgets/BarcodeScannerPage.dart';
import 'package:gsolution/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:gsolution/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:gsolution/src/presentation/widgets/toast/success_toast.dart';
import 'package:gsolution/src/utils/contstants.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProductScreen extends StatefulWidget {
  final ProductModel product;

  const UpdateProductScreen({super.key, required this.product});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  bool isImageTaken = false;
  XFile? _selectedImage;
  final Map<String, dynamic> _dataMap = {};

  @override
  void initState() {
    super.initState();
    // Initialize data map with existing product data
    _dataMap['name'] = widget.product.name;
    _dataMap['description'] = widget.product.description;
    _dataMap['categ_id'] =
        widget.product.categId.isNotEmpty ? widget.product.categId[0] : null;
    _dataMap['default_code'] = widget.product.defaultCode;
    _dataMap['barcode'] = widget.product.barcode;
    _dataMap['list_price'] = widget.product.lstPrice;
    _dataMap['standard_price'] = widget.product.standardPrice;
    _dataMap['image_1920'] = widget.product.image1920;
    _dataMap['active'] = widget.product.active ? "true" : "false";
  }

  void takePhoto({required ImageSource source}) async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        debugPrint("Image Path: ${pickedFile.path}");

        setState(() {
          _selectedImage = pickedFile;
          isImageTaken = true;
          _dataMap['image_1920'] = pickedFile.path;
        });
      } else {
        debugPrint("No image selected.");
      }
    } catch (e) {
      debugPrint("Error while picking image: $e");
    }
  }

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

  Widget sizeBoxWidth() {
    return const SizedBox(
      width: 10,
    );
  }

  Widget sizeBoxHeight() {
    return const SizedBox(
      height: 20,
    );
  }

  final _formKey = GlobalKey<FormBuilderState>();
  bool noteHasError = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar(
            navigateName: "Edit Product",
          )),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.white70,
        child: FormBuilder(
            key: _formKey,
            onChanged: () {
              _formKey.currentState!.save();
              debugPrint(_formKey.currentState!.value.toString());
            },
            autovalidateMode: AutovalidateMode.disabled,
            skipDisabled: true,
            child: ListView(
              children: [
                sizeBoxHeight(),
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade50.withOpacity(0.3),
                        radius: 60,
                        backgroundImage: _selectedImage != null
                            ? FileImage(File(_selectedImage!.path))
                            : widget.product.image512 != null
                                ? NetworkImage(widget.product.image512!)
                                : const AssetImage(
                                        "assets/images/products/apple_device.png")
                                    as ImageProvider,
                      ),
                      Positioned(
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Wrap(
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.camera_alt),
                                      title: Text('Camera'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        takePhoto(source: ImageSource.camera);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.photo_library),
                                      title: Text('Gallery'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        takePhoto(source: ImageSource.gallery);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundColor: ColorSchema.primaryColor,
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                sizeBoxHeight(),
                sizeBoxHeight(),
                FormBuilderTextField(
                  name: 'name',
                  initialValue: _dataMap['name'],
                  decoration: inputDecoration('Product', null),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                sizeBoxHeight(),
                FormBuilderTextField(
                  name: 'description',
                  initialValue: _dataMap['description'].toString(),
                  decoration: inputDecoration('Description', null),
                  keyboardType: TextInputType.text,
                  maxLines: 2,
                ),
                sizeBoxHeight(),
                FormBuilderDropdown(
                  name: "categ_id",
                  decoration: inputDecoration('Category', suffixIcon()),
                  onChanged: _onChanged,
                  items: PrefUtils.categoryProduct
                      .map((v) =>
                          DropdownMenuItem(value: v.id, child: Text(v.name!)))
                      .toList(),
                  initialValue: widget.product.categId[0],
                ),
                sizeBoxHeight(),
                Row(
                  children: [
                    Expanded(
                      child: FormBuilderTextField(
                        name: 'default_code',
                        initialValue: _dataMap['default_code'],
                        decoration: inputDecoration('Reference Product', null),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    sizeBoxWidth(),
                    Expanded(
                      child: FormBuilderRadioGroup(
                        initialValue: _dataMap['active'],
                        name: 'active',
                        decoration: inputDecoration('Active', null),
                        options: ["true", "false"]
                            .map((v) => FormBuilderFieldOption(
                                  value: v,
                                  child: Text(v.toUpperCase()),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
                sizeBoxHeight(),
                Row(
                  children: [
                    Expanded(
                      child: FormBuilderTextField(
                        autovalidateMode: AutovalidateMode.always,
                        name: 'barcode',
                        decoration: inputDecoration('Barcode', suffixIcon()),
                        onChanged: _onChanged,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.qr_code_scanner, color: Colors.blue),
                      onPressed: () async {
                        // الانتقال إلى صفحة الماسح الضوئي وانتظار النتيجة
                        final scannedBarcode =
                            await Get.to(() => const BarcodeScannerPage());
                        if (scannedBarcode != null) {
                          setState(() {
                            // تحديث حقل الباركود في النموذج
                            _formKey.currentState?.fields['barcode']
                                ?.didChange(scannedBarcode);
                          });
                        }
                      },
                    ),
                  ],
                ),
                sizeBoxHeight(),
                Row(
                  children: [
                    Expanded(
                      child: FormBuilderTextField(
                        name: 'list_price',
                        initialValue: _dataMap['list_price'].toString(),
                        decoration: inputDecoration('Price', null),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    sizeBoxWidth(),
                    Expanded(
                      child: FormBuilderTextField(
                        name: 'standard_price',
                        initialValue: _dataMap['standard_price'].toString(),
                        decoration: inputDecoration('Cout', null),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                sizeBoxHeight(),
                CustomElevatedButton(
                  buttonName: "Update",
                  showToast: () {
                    Map<String, dynamic>? formData =
                        _formKey.currentState?.value;

                    if (_selectedImage != null) {
                      String imageString = base64Encode(
                          File(_selectedImage!.path).readAsBytesSync());
                      _dataMap['image_1920'] = imageString;
                    }

                    if (formData != null) {
                      _dataMap.addAll(formData);
                    }
                    ProductModule.updateProduct(
                        maps: _dataMap,
                        id: widget.product.id,
                        onResponse: (response) {
                          if (response) {
                            SuccessToast.showSuccessToast(context,
                                "Update Complete", "Product Update Complete");
                          }
                        });

                    debugPrint('Updated Data Map: $_dataMap');
                  },
                ),
                sizeBoxHeight(),
              ],
            )),
      ),
    );
  }
}
