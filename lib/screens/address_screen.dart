import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/product_provider/product_provider.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  Position? currentPosition;

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      debugPrint("Location Denied");
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        debugPrint("Location permissions are still denied.");
        return;
      }
    }
    try {
      currentPosition = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ));
      debugPrint('Latitude: ${currentPosition?.latitude}');
      debugPrint('Longitude: ${currentPosition?.longitude}');
      checkPermission();
    } catch (e) {
      debugPrint('Error retrieving location: $e');
    }
  }

  Future<void> checkPermission() async {
    if (currentPosition != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            currentPosition!.latitude, currentPosition!.longitude);
        debugPrint('placemarks : $placemarks');
        if (placemarks.isNotEmpty) {
          context.read<ProductProvider>().addressController.text =
              placemarks[1].thoroughfare ?? '';
          context.read<ProductProvider>().cityController.text =
              placemarks[0].locality ?? '';
          context.read<ProductProvider>().stateController.text =
              placemarks[0].administrativeArea ?? '';
          context.read<ProductProvider>().zipcodeController.text =
              placemarks[0].postalCode ?? '';
          context.read<ProductProvider>().countryController.text =
              placemarks[0].country ?? '';
          setState(() {});
        }
      } catch (e) {
        debugPrint('Error getting placemarks: $e');
      }
    } else {
      debugPrint('Current position is null');
    }
    context.read<ProductProvider>().setSFProducts();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    context.read<ProductProvider>().getSFProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductProvider>();
    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
      appBar: AppBar(
        backgroundColor: Color(0xffF9F9F9),
        title: Text('Adding Shipping Address'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(1, 1.5),
                    ),
                  ],
                ),
                child: TextFormField(
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter your name';
                  //   }
                  //   return null;
                  // },
                  controller: providerRead.nameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 20.0,
                    ),
                    label: Text(
                      'Full name',
                      style: TextStyle(fontSize: 18.0, color: Colors.grey),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(1, 1.5),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: providerRead.addressController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 20.0,
                    ),
                    label: Text(
                      'Address',
                      style: TextStyle(fontSize: 18.0, color: Colors.grey),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(1, 1.5),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: providerRead.cityController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 20.0,
                    ),
                    label: Text(
                      'City',
                      style: TextStyle(fontSize: 18.0, color: Colors.grey),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(1, 1.5),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: providerRead.stateController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 20.0,
                    ),
                    label: Text(
                      'State/Province/Region',
                      style: TextStyle(fontSize: 18.0, color: Colors.grey),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(1, 1.5),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: providerRead.zipcodeController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 20.0,
                    ),
                    label: Text(
                      'Zip Code (Postal Code)',
                      style: TextStyle(fontSize: 18.0, color: Colors.grey),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(1, 1.5),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: providerRead.countryController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 20.0,
                    ),
                    label: Text(
                      'Country',
                      style: TextStyle(fontSize: 18.0, color: Colors.grey),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  providerRead.setSFProducts();
                  // if (_formKey.currentState?.validate() ?? false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(
                        child: Text('Your Address is Save'),
                      ),
                    ),
                  );
                  // }
                },
                child: Container(
                  margin: EdgeInsetsDirectional.only(bottom: 20.0),
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                    color: AppColor.appColor,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Center(
                    child: Text(
                      'SAVE ADDRESS',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  getCurrentLocation();
                },
                child: Container(
                  margin: EdgeInsetsDirectional.only(bottom: 20.0),
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(color: AppColor.appColor)),
                  child: Center(
                    child: Text(
                      'CURRENT LOCATION',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColor.appColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
