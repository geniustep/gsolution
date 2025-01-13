import 'dart:collection';
import 'dart:io';

import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gsolution/common/api_factory/controllers/controller.dart';
import 'package:gsolution/common/config/app_colors.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:image_picker/image_picker.dart';

class CreatePartnerSupplier extends StatefulWidget {
  const CreatePartnerSupplier({Key? key}) : super(key: key);

  @override
  State<CreatePartnerSupplier> createState() {
    return _CreatePartnerSupplierState();
  }
}

class _CreatePartnerSupplierState extends State<CreatePartnerSupplier> {
  final Controller _Controller = Get.put(Controller());
  var partners = <PartnerModel>[].obs;
  @override
  void initState() {
    // getLatAndLong();
    super.initState();
    // PrefUtils.Employee;
    // _Controller.getSecteurController();
    // getPartners(partners);
  }

  // Future<RxList<PartnerModel>> getPartners(
  //     RxList<PartnerModel> partners) async {
  //   List<dynamic> domain = [
  //     ['supplier_rank', '>', 0],
  //   ];
  //   if (PrefUtils.Employee != null && PrefUtils.Employee!.jobId != false) {
  //     if (PrefUtils.Employee!.jobTitle == "vendor") {
  //       domain.add(
  //         ['employee_to_partner', 'child_of', PrefUtils.theUser!.employeeIds],
  //       );
  //     } else if (PrefUtils.Employee!.jobTitle == "Super Visor") {
  //       domain.add(
  //         ['supervisor_to_partner', 'child_of', PrefUtils.theUser!.employeeIds],
  //       );
  //     } else if (PrefUtils.Employee!.jobTitle == "Delivery Man") {
  //       domain.add(
  //         [
  //           'delivery_man_to_partner',
  //           'child_of',
  //           PrefUtils.theUser!.employeeIds
  //         ],
  //       );
  //     }
  //   }
  //   await PartnerModule.searchReadPartners(
  //     domain: domain,
  //     onResponse: ((response) {
  //       setState(() {
  //         partners.addAll(response[response.keys.toList()[0]]!);
  //       });
  //     }),
  //   );
  //   return partners;
  // }

// Variable Google Maps
  var myMarkers = HashSet<Marker>();
  GoogleMapController? googleMapController;
  CameraPosition? _kGooglePlex;
  late Position position;
  var lat;
  var long;

// Variable Google Maps Adress
  var placemarks;
  var place;
  String location = 'Null, Press Button';
  var Address;
  var _city;
  var _country;

//function Non Terminer in form get just camera without Gallerie
  final ImagePicker _picker = ImagePicker();
  XFile? image;

  takePhoto(Image i) async {
    image = await _picker.pickImage(source: ImageSource.camera);

    // final File? file = File(image!.path);
    final file = Image.file(
      File(image!.path),
    );
  }

  // Fonction Get Current Position
  getLatAndLong() async {
    position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best)
        .then((value) => value);
    lat = position.latitude;
    long = position.longitude;

    setState(() {
      _kGooglePlex = CameraPosition(
        target: LatLng(lat, long),
        zoom: 14.4746,
      );
    });
  }

// Fonction Get Adress
  Future<void> GetAddressFromLatLong() async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    _country = '${place.country}';
    _city = '${place.locality}';
    Address =
        '${place.name} ${place.street}, ${place.subThoroughfare} ${place.thoroughfare}, ${place.subLocality} ${place.locality}';

    setState(() {});
  }

  // Variable FormBuilder
  final _formKey = GlobalKey<FormBuilderState>();
  bool isVisible = true;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  bool _noteHasError = false;
  void _onChanged(dynamic val) => debugPrint(val.toString());

  // list of Controller FormBuilder
  final _controllerAddress = TextEditingController();
  final _controllerLat = TextEditingController();
  final _controllerLong = TextEditingController();
  final _controllerCity = TextEditingController();
  final _controllerCountry = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MainContainer(
      actions: [
        IconButton(
          icon: const Icon(
            Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              isVisible = !isVisible;
            });
          },
        )
      ],
      appBarTitle: isVisible == true ? "Create Customer" : 'Create Supplier',
      drawer: CustomDrawer(),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              //google maps
              Visibility(
                visible: isVisible,
                child: SizedBox(
                  height: 300,
                  child: Stack(
                    children: [
                      _kGooglePlex == null
                          ? const CircularProgressIndicator()
                          : GoogleMap(
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              initialCameraPosition: _kGooglePlex!,
                              onMapCreated:
                                  (GoogleMapController googleMapController) {
                                setState(() {
                                  myMarkers.add(Marker(
                                    onTap: () async {},
                                    // draggable: true,
                                    markerId: const MarkerId('marker 1'),
                                    position: LatLng(lat, long),
                                    infoWindow: InfoWindow(
                                      title: 'TAP MAKE ADDRESS',
                                      onTap: () async {
                                        await getLatAndLong();

                                        location =
                                            'Lat: ${position.latitude} , Long: ${position.longitude}';

                                        await GetAddressFromLatLong();
                                        setState(() {
                                          print(Address);
                                          _controllerCountry.value =
                                              TextEditingValue(
                                                  text: _country.toString());
                                          _controllerCity.value =
                                              TextEditingValue(
                                                  text: _city.toString());
                                          _controllerAddress.value =
                                              TextEditingValue(
                                                  text: Address.toString());
                                        });
                                      },
                                    ),
                                  ));
                                });
                              },
                              markers: myMarkers,
                            ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton.icon(
                          label: const Text(
                            'Searching Address',
                          ),
                          icon: const Icon(
                            Icons.search,
                          ),
                          onPressed: () async {
                            await getLatAndLong();
                            await GetAddressFromLatLong();
                            setState(() {
                              location =
                                  'Lat: ${position.latitude} , Long: ${position.longitude}';

                              _controllerLat.value = TextEditingValue(
                                text: position.latitude.toString(),
                                selection: TextSelection.fromPosition(
                                  TextPosition(
                                      offset:
                                          position.latitude.toString().length),
                                ),
                              );
                              _controllerLong.value = TextEditingValue(
                                text: position.longitude.toString(),
                                selection: TextSelection.fromPosition(
                                  TextPosition(
                                      offset:
                                          position.longitude.toString().length),
                                ),
                              );

                              _controllerCountry.value =
                                  TextEditingValue(text: _country.toString());

                              _controllerCity.value =
                                  TextEditingValue(text: _city.toString());

                              _controllerAddress.value =
                                  TextEditingValue(text: Address.toString());
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),

              FormBuilder(
                key: _formKey,
                onChanged: () {
                  _formKey.currentState!.save();
                  debugPrint(_formKey.currentState!.value.toString());
                },
                autovalidateMode: AutovalidateMode.disabled,
                skipDisabled: true,
                child: Column(
                  children: <Widget>[
                    //adress
                    Visibility(
                      visible: isVisible,
                      child: FormBuilderTextField(
                        name: 'street',
                        controller: _controllerAddress,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.gps_fixed,
                            textDirection: TextDirection.ltr,
                          ),
                          hintText: 'adresse ..',
                          // labelText: 'Adresse',
                        ),
                        onChanged: (val) {
                          setState(() {
                            _noteHasError = !(_formKey
                                    .currentState?.fields['street']
                                    ?.validate() ??
                                false);
                          });
                        },
                      ),
                    ),
                    // partner id
                    Visibility(
                      visible: !isVisible,
                      child: FormBuilderDropdown(
                        decoration: const InputDecoration(hintText: 'PARENT ID'
                            // border: OutlineInputBorder(),
                            // icon: Icon(
                            //   Icons.person_pin,
                            //   color: Color.fromRGBO(255, 0, 0, 1),
                            // ),
                            // labelText: 'secteurs'
                            ),
                        name: "parent_id",
                        onChanged: _onChanged,
                        items: partners
                            .map((v) => DropdownMenuItem(
                                value: v.id, child: Text(v.displayName!)))
                            .toList(),
                      ),
                    ),
                    // name partner
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'name',
                      decoration: InputDecoration(
                        hintText: isVisible == true
                            ? 'name customers'
                            : 'Nom Contact',
                        labelText: isVisible == true
                            ? 'name customers'
                            : 'Nom Contact',
                        suffixIcon: _noteHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 15),
                    // Fonction
                    Visibility(
                      visible: !isVisible,
                      child: FormBuilderTextField(
                        autovalidateMode: AutovalidateMode.always,
                        name: 'function',
                        decoration: InputDecoration(
                          hintText: 'function Contact',
                          labelText: 'function Contact',
                          suffixIcon: _noteHasError
                              ? const Icon(Icons.error, color: Colors.red)
                              : const Icon(Icons.check, color: Colors.green),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Column(
                      children: [
                        Visibility(
                          visible: isVisible,
                          child: Row(
                            children: <Widget>[
                              // const SizedBox(width: 20),
                              //is Company
                              Expanded(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    FormBuilderRadioGroup(
                                      name: 'is_company',
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 40.0,
                                                  horizontal: 10.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(32.0),
                                          ),
                                          // icon: Icon(
                                          //   Icons.person_pin,
                                          //   color: Color.fromRGBO(255, 0, 0, 1),
                                          // ),
                                          labelText: 'Is Company?'),
                                      onChanged: _onChanged,
                                      options: ["True", "False"]
                                          .map((v) => FormBuilderFieldOption(
                                                value: v.toLowerCase(),
                                                child: Text(v.toString()),
                                              ))
                                          .toList(growable: true),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  FormBuilderTextField(
                                    autovalidateMode: AutovalidateMode.always,
                                    name: 'phone',
                                    decoration: InputDecoration(
                                      hintText: 'phone De Client ..',
                                      labelText: 'phone De Client',
                                      suffixIcon: _noteHasError
                                          ? const Icon(Icons.error,
                                              color: Colors.red)
                                          : const Icon(Icons.check,
                                              color: Colors.green),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        _noteHasError = !(_formKey
                                                .currentState?.fields['phone']
                                                ?.validate() ??
                                            false);
                                      });
                                    },
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.next,
                                  ),
                                  FormBuilderTextField(
                                    keyboardType: TextInputType.emailAddress,
                                    autovalidateMode: AutovalidateMode.always,
                                    name: 'email',
                                    decoration: InputDecoration(
                                      hintText: 'email De Client ..',
                                      labelText: 'email De Client',
                                      suffixIcon: _noteHasError
                                          ? const Icon(Icons.error,
                                              color: Colors.red)
                                          : const Icon(Icons.check,
                                              color: Colors.green),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        _noteHasError = !(_formKey
                                                .currentState?.fields['email']
                                                ?.validate() ??
                                            false);
                                      });
                                    },
                                    textInputAction: TextInputAction.next,
                                  ),
                                ],
                              ),
                            ),

                            // photo partner
                            Expanded(
                              child: FormBuilderImagePicker(
                                onSaved: (val) {
                                  val = _formKey.currentState
                                      ?.fields['image_1920']!.value;
                                },
                                onChanged: (val) {
                                  setState(() {
                                    _noteHasError = !(_formKey
                                            .currentState?.fields['image_1920']
                                            ?.validate() ??
                                        false);
                                  });
                                },
                                name: 'image_1920',
                                onImage: takePhoto,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(29, 10, 10, 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  labelText: 'Photo',
                                ),
                                fit: BoxFit.fitWidth,
                                // maxHeight: 20,
                                // imageQuality: 10,
                                maxImages: 1,
                                preferredCameraDevice: CameraDevice.rear,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        // City & Country
                        Visibility(
                          visible: isVisible,
                          child: Row(
                            children: [
                              Expanded(
                                child: FormBuilderTextField(
                                  autovalidateMode: AutovalidateMode.always,
                                  name: 'city',
                                  controller: _controllerCity,
                                  decoration: InputDecoration(
                                    hintText: 'City',
                                    suffixIcon: _noteHasError
                                        ? const Icon(Icons.error,
                                            color: Colors.red)
                                        : const Icon(Icons.check,
                                            color: Colors.green),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      _noteHasError = !(_formKey
                                              .currentState?.fields['city']
                                              ?.validate() ??
                                          false);
                                    });
                                  },
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              Expanded(
                                child: FormBuilderTextField(
                                  autovalidateMode: AutovalidateMode.always,
                                  name: 'country_id',
                                  controller: _controllerCountry,
                                  decoration: InputDecoration(
                                    hintText: 'Country',
                                    suffixIcon: _noteHasError
                                        ? const Icon(Icons.error,
                                            color: Colors.red)
                                        : const Icon(Icons.check,
                                            color: Colors.green),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      _noteHasError = !(_formKey.currentState
                                              ?.fields['country_id']
                                              ?.validate() ??
                                          false);
                                    });
                                  },
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                ),
                              )
                            ],
                          ),
                        ),
                        // Longitude & Latitude
                        Visibility(
                          visible: isVisible,
                          child: Row(
                            children: <Widget>[
                              const SizedBox(width: 20),
                              Expanded(
                                child: FormBuilderTextField(
                                  enabled: true,
                                  autovalidateMode: AutovalidateMode.always,
                                  name: 'partner_latitude',
                                  controller: _controllerLat,
                                  decoration: InputDecoration(
                                    hintText: 'Latitude',
                                    suffixIcon: _noteHasError
                                        ? const Icon(Icons.error,
                                            color: Colors.red)
                                        : const Icon(Icons.check,
                                            color: Colors.green),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      _noteHasError = !(_formKey.currentState
                                              ?.fields['partner_latitude']
                                              ?.validate() ??
                                          false);
                                    });
                                  },
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              Expanded(
                                child: FormBuilderTextField(
                                  enabled: true,
                                  autovalidateMode: AutovalidateMode.always,
                                  name: 'partner_longitude',
                                  controller: _controllerLong,
                                  decoration: InputDecoration(
                                    hintText: 'Longitude',
                                    suffixIcon: _noteHasError
                                        ? const Icon(Icons.error,
                                            color: Colors.red)
                                        : const Icon(Icons.check,
                                            color: Colors.green),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      _noteHasError = !(_formKey.currentState
                                              ?.fields['partner_longitude']
                                              ?.validate() ??
                                          false);
                                    });
                                  },
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          debugPrint(_formKey.currentState?.value.toString());
                          Map<String, dynamic>? secondMaps =
                              _formKey.currentState?.value;
                          Map<String, dynamic> newMap = Map.from(secondMaps!);
                          var images = newMap['image_1920'] as List<dynamic>;
                          if (images.isNotEmpty) {
                            String imageString = base64Encode(
                                File(images[0].path).readAsBytesSync());
                            newMap['image_1920'] = imageString;
                          }

                          newMap['supplier_rank'] = isVisible == true ? 1 : 0;
                          // _Controller.addPartner(
                          //   maps: newMap,
                          //   onResponse: (response) {
                          //     PartnerModule.readPartners(
                          //         ids: [response],
                          //         onResponse: (onResponse) {
                          //           Get.off(() => Partner(onResponse[0]));
                          //         });
                          // },
                          // );
                          debugPrint('validation OK');
                        } else {
                          debugPrint(_formKey.currentState?.value.toString());
                          debugPrint('validation failed');
                        }
                      },
                      child: const Text(
                        'Submit',
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _formKey.currentState?.reset();
                      },
                      child: const Text(
                        'Reset',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
