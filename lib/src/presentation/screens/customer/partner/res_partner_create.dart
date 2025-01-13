import 'dart:collection';
import 'dart:io';

import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:gsolution/src/presentation/screens/customer/partner/partner.dart';
import 'package:image_picker/image_picker.dart';

class CreatePartner extends StatefulWidget {
  const CreatePartner({super.key});

  @override
  State<CreatePartner> createState() {
    return _CreatePartnerState();
  }
}

class _CreatePartnerState extends State<CreatePartner> {
  var partners = <PartnerModel>[].obs;
  @override
  void initState() {
    getLatAndLong();
    super.initState();
    // PrefUtils.Employee;
    partners = PrefUtils.partners;
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
  Future<void> getAddressFromLatLong() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark place = placemarks[3];
    _country = '${place.country}';
    _city = '${place.locality}';
    Address =
        '${place.name} ${place.street}, ${place.subThoroughfare} ${place.thoroughfare}, ${place.subLocality} ${place.locality}';
    // PrefUtils.theUser!.lang;
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
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
              child: Text(
                !isVisible ? 'Client' : 'Contact',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            IconButton(
              color: Colors.blue,
              icon: Icon(
                !isVisible
                    ? Icons.dashboard_customize
                    : Icons.spatial_tracking_outlined,
              ),
              onPressed: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
            ),
          ],
        )
      ],
      appBarTitle: isVisible ? 'Create Client' : 'Create Contact',
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
                                        // await getLatAndLong();

                                        location =
                                            'Lat: ${position.latitude} , Long: ${position.longitude}';

                                        await getAddressFromLatLong();
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
                            // await getLatAndLong();
                            await getAddressFromLatLong();
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
                        decoration:
                            const InputDecoration(hintText: 'Contact Name'),
                        name: "parent_id",
                        onChanged: _onChanged,
                        items: partners
                            .map((v) => DropdownMenuItem(
                                value: v.id, child: Text(v.name!)))
                            .toList(),
                      ),
                    ),
                    // name partner
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'name',
                      decoration: InputDecoration(
                        hintText: isVisible == true ? 'Client' : 'Nom Contact',
                        labelText: isVisible == true ? 'Client' : 'Nom Contact',
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
                          hintText: 'fonction Contact',
                          labelText: 'fonction Contact',
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
                              Expanded(
                                child: Column(
                                  children: [
                                    FormBuilderTextField(
                                      autovalidateMode: AutovalidateMode.always,
                                      name: 'street2',
                                      decoration: InputDecoration(
                                        hintText: isVisible == true
                                            ? 'Cartiers'
                                            : 'Nom Cartiers',
                                        labelText: isVisible == true
                                            ? 'Cartiers'
                                            : 'Nom Cartiers',
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

                              //is Company
                              Expanded(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    FormBuilderRadioGroup(
                                      name: 'is_company',
                                      initialValue: 'False',
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(32.0),
                                          ),
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
                          if (newMap['image_1920'] != null) {
                            var images = newMap['image_1920'] as List<dynamic>;

                            if (images.isNotEmpty) {
                              String imageString = base64Encode(
                                  File(images[0].path).readAsBytesSync());
                              newMap['image_1920'] = imageString;
                            }
                          }
                          newMap['customer_rank'] = isVisible == true ? 1 : 0;

                          PartnerModule.createPartners(
                            maps: newMap,
                            onResponse: (response) {
                              PartnerModule.readPartners(
                                  ids: [response],
                                  onResponse: (onResponse) {
                                    PrefUtils.partners.addAll(onResponse);
                                    Get.off(
                                        () => Partner(partner: onResponse[0]));
                                  });
                            },
                          );
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
