import 'dart:collection';
import 'dart:io';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gsolution/common/api_factory/controllers/controller.dart';
import 'package:gsolution/common/config/app_colors.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';

class UpdatePartner extends StatefulWidget {
  final PartnerModel partner;
  const UpdatePartner(this.partner, {super.key});

  @override
  State<UpdatePartner> createState() {
    return _UpdatePartnerState();
  }
}

class _UpdatePartnerState extends State<UpdatePartner> {
  final Controller _Controller = Get.put(Controller());

  @override
  void initState() {
    getLatAndLong();
    super.initState();
    // _Controller.getSecteurController();
  }

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
    file = Image.file(
      File(image!.path),
    );
  }

  var file;
  // Fonction Get Current Position
  getLatAndLong() async {
    position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best)
        .then((value) => value);
    lat = position.latitude;
    long = position.longitude;
    if (mounted) {
      setState(() {
        _kGooglePlex = CameraPosition(
          target: LatLng(lat, long),
          zoom: 14.4746,
        );
      });
    }
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

  bool isUpdatePhoto = false;
  // Variable FormBuilder
  final _formKey = GlobalKey<FormBuilderState>();
  bool isVisible = true;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  bool _noteHasError = false;
  void _onChanged(dynamic val) => debugPrint(val.toString());
  // late List<DropdownMenuItem> selectedDropDownValue = _Controller.secteurs
  // .map((v) => DropdownMenuItem(
  //       value: v.id,
  //       child: Text(v.name_secteur!),
  //     ))
  // .toList();
  // list of Controller FormBuilder
  late final _controllerAddress =
      TextEditingController(text: widget.partner.street);
  late final _controllerName = TextEditingController(text: widget.partner.name);
  late final _controllerLat =
      TextEditingController(text: widget.partner.partnerLatitude.toString());
  late final _controllerLong =
      TextEditingController(text: widget.partner.partnerLongitude.toString());
  final _controllerCity = TextEditingController();
  final _controllerCountry = TextEditingController();
  late final _controllerPhone =
      TextEditingController(text: widget.partner.phone.toString());
  late final _controllerEmail =
      TextEditingController(text: widget.partner.email.toString());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create New Customer',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Update ${widget.partner.name}"),
        ),
        body: Builder(builder: (context) {
          var isCompany = widget.partner.companyType;
          var optionRadioB = ["True", "False"]
              .map((v) => FormBuilderFieldOption(
                    value: v.toLowerCase(),
                    child: Text(v.toString()),
                  ))
              .toList(growable: true);
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  SizedBox(
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
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                // primary:
                                //     const Color.fromARGB(92, 114, 136, 224),
                                // onPrimary: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 10),
                                textStyle: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            label: const Text('Get Address',
                                style: TextStyle(color: Colors.blue)),
                            icon: const Icon(
                              Icons.search,
                              color: Colors.blue,
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
                                        offset: position.latitude
                                            .toString()
                                            .length),
                                  ),
                                );
                                _controllerLong.value = TextEditingValue(
                                  text: position.longitude.toString(),
                                  selection: TextSelection.fromPosition(
                                    TextPosition(
                                        offset: position.longitude
                                            .toString()
                                            .length),
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
                        FormBuilderTextField(
                          name: 'street',
                          controller: _controllerAddress,
                          // initialValue: widget.partners!.street!,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.gps_fixed,
                              textDirection: TextDirection.ltr,
                              color: Color.fromARGB(255, 32, 125, 219),
                            ),
                            hintText: 'adresse ..',
                            // labelText: 'Adresse',
                          ),
                          onSaved: (val) {
                            this.widget.partner.street = val;
                          },
                          onChanged: (val) {
                            setState(() {
                              _noteHasError = !(_formKey
                                      .currentState?.fields['street']
                                      ?.validate() ??
                                  false);
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        Column(
                          children: [
                            Row(
                              children: <Widget>[
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    children: [
                                      // FormBuilderDropdown(
                                      //   initialValue: widget
                                      //               .partner.secteurToPartner !=
                                      //           false
                                      //       ? widget.partner.secteurToPartner[0]
                                      //       : 0,
                                      //   name: "secteur_to_partner",
                                      //   onChanged: _onChanged,
                                      //   items: selectedDropDownValue,
                                      // ),
                                      FormBuilderTextField(
                                        controller: _controllerName,
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                        name: 'name',
                                        decoration: InputDecoration(
                                          hintText: 'Nom De Client ..',
                                          labelText: 'Nom De Client',
                                          suffixIcon: _noteHasError
                                              ? const Icon(Icons.error,
                                                  color: Colors.red)
                                              : const Icon(Icons.check,
                                                  color: Colors.green),
                                        ),
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      FormBuilderRadioGroup(
                                        initialValue: isCompany == "company"
                                            ? "true"
                                            : "false",
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
                                        options: optionRadioB,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      FormBuilderTextField(
                                        controller: _controllerPhone,
                                        autovalidateMode:
                                            AutovalidateMode.always,
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
                                                    .currentState
                                                    ?.fields['phone']
                                                    ?.validate() ??
                                                false);
                                          });
                                        },
                                        keyboardType: TextInputType.phone,
                                        textInputAction: TextInputAction.next,
                                      ),
                                      FormBuilderTextField(
                                        controller: _controllerEmail,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        autovalidateMode:
                                            AutovalidateMode.always,
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
                                                    .currentState
                                                    ?.fields['email']
                                                    ?.validate() ??
                                                false);
                                          });
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      FormBuilderImagePicker(
                                        initialValue: [
                                          widget.partner.image_512 != null &&
                                                  widget.partner.image_512 !=
                                                      false
                                              ? Image.memory(
                                                  base64.decode(widget
                                                      .partner.image_512!),
                                                  height: 40,
                                                  width: 40,
                                                )
                                              : Icon(
                                                  Icons.person,
                                                  color: AppColors.grey,
                                                  size: 40,
                                                ),
                                        ],
                                        onSaved: (val) {
                                          val = _formKey.currentState
                                              ?.fields['image_1920']!.value;
                                          isUpdatePhoto = true;
                                        },
                                        onChanged: (val) {
                                          setState(() {
                                            _noteHasError = !(_formKey
                                                    .currentState
                                                    ?.fields['image_1920']
                                                    ?.validate() ??
                                                false);
                                          });
                                        },
                                        name: 'image_1920',
                                        onImage: takePhoto,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  29, 10, 10, 10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          labelText: 'Photo',
                                        ),
                                        fit: BoxFit.fitWidth,
                                        // maxHeight: 20,
                                        // imageQuality: 10,
                                        maxImages: 1,
                                        preferredCameraDevice:
                                            CameraDevice.rear,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Visibility(
                              visible: true,
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
                                          _noteHasError = !(_formKey
                                                  .currentState
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
                                          _noteHasError = !(_formKey
                                                  .currentState
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
                            Visibility(
                              visible: true,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: FormBuilderTextField(
                                      enabled: false,
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
                                      enabled: false,
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
                                          _noteHasError = !(_formKey
                                                  .currentState
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
                            )
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
                            if (_formKey.currentState?.saveAndValidate() ??
                                false) {
                              debugPrint(
                                  _formKey.currentState?.value.toString());

                              Map<String, dynamic> secondMaps = {};

                              // التحقق من الحقول المحدثة فقط
                              _formKey.currentState?.value
                                  .forEach((key, value) {
                                if (key == 'image_1920') {
                                  // معالجة الصورة
                                  if (isUpdatePhoto) {
                                    var images = _formKey.currentState
                                        ?.value['image_1920'] as List<dynamic>;
                                    if (images.isNotEmpty &&
                                        images[0] is File) {
                                      String imageString = base64Encode(
                                          File(images[0].path)
                                              .readAsBytesSync());
                                      secondMaps[key] = imageString;
                                    }
                                  }
                                } else {
                                  // إضافة الحقول التي تغيرت فقط
                                  var oldValue = widget.partner.toJson()[key];
                                  if (value != oldValue) {
                                    secondMaps[key] = value;
                                  }
                                }
                              });

                              PartnerModule.updateResPartner(
                                partner: widget.partner,
                                maps: secondMaps,
                                onResponse: (response) {
                                  print("Data sent to server: $secondMaps");
                                  print("Server response: $response");
                                },
                              );
                              debugPrint('validation OK');
                            } else {
                              debugPrint(
                                  _formKey.currentState?.value.toString());
                              debugPrint('validation failed');
                            }
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _formKey.currentState?.reset();
                          },
                          child: Text(
                            'Reset',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
