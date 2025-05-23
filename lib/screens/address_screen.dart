import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/main.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:shopping_app/screens/payment_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  Position? currentPosition;
  bool isAddressLoad = false; // Initial state false, button action ke liye

  Future<void> getCurrentLocation() async {
    setState(() {
      isAddressLoad = true; // Loading start
    });

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      debugPrint("Location Denied");
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        setState(() {
          isAddressLoad = false; // Loading stop
        });
        debugPrint("Location permissions are still denied.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions denied.')),
        );
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
      await checkPermission(); // Address fetch ke baad
    } catch (e) {
      debugPrint('Error retrieving location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching location: $e')),
      );
    } finally {
      setState(() {
        isAddressLoad = false; // Loading stop (success ya fail dono case mein)
      });
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting address: $e')),
        );
      }
    } else {
      debugPrint('Current position is null');
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    context.read<ProductProvider>().getAddressData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductProvider>();
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text(
          'Adding Shipping Address',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              ListView(
                children: [
                  const SizedBox(height: 20.0),
                  _buildInputField(
                    controller: providerRead.nameController,
                    label: 'Full name',
                    validationMessage: 'Please enter your name',
                  ),
                  const SizedBox(height: 20.0),
                  _buildInputField(
                    controller: providerRead.addressController,
                    label: 'Address',
                    validationMessage: 'Please enter your address',
                  ),
                  const SizedBox(height: 20.0),
                  _buildInputField(
                    controller: providerRead.cityController,
                    label: 'City',
                    validationMessage: 'Please enter your city',
                  ),
                  const SizedBox(height: 20.0),
                  _buildInputField(
                    controller: providerRead.stateController,
                    label: 'State/Province/Region',
                    validationMessage: 'Please enter your state',
                  ),
                  const SizedBox(height: 20.0),
                  _buildInputField(
                    controller: providerRead.zipcodeController,
                    label: 'Zip Code (Postal Code)',
                    validationMessage: 'Please enter your zip code',
                  ),
                  const SizedBox(height: 20.0),
                  _buildInputField(
                    controller: providerRead.countryController,
                    label: 'Country',
                    validationMessage: 'Please enter your country',
                  ),
                  const SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (providerRead.isAddressStoreInDatabase) {
                          providerRead.addressUpdate(
                            userUniqueId,
                            providerRead.nameController.text,
                            providerRead.addressController.text,
                            providerRead.cityController.text,
                            providerRead.stateController.text,
                            int.parse(providerRead.zipcodeController.text),
                            providerRead.countryController.text,
                          );
                        } else {
                          providerRead.postAddressData();
                        }
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return PaymentScreen();
                        }));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Center(
                              child: Text('Please fill in all required fields'),
                            ),
                          ),
                        );
                      }
                    },
                    child: _buildSaveButton(
                      context.watch<ProductProvider>().isAddressStoreInDatabase
                          ? 'CONFIRM ADDRESS'
                          : 'SAVE ADDRESS',
                      AppColor.appColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: isAddressLoad ? null : getCurrentLocation,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _buildSaveButton(
                          'CURRENT LOCATION',
                          Colors.white,
                          borderColor: AppColor.appColor,
                          textColor: AppColor.appColor,
                          isAddressLoad: isAddressLoad,
                        ),
                      ],
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String validationMessage,
  }) {
    return Container(
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
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validationMessage;
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 20.0,
          ),
          label: Text(
            label,
            style: const TextStyle(fontSize: 18.0, color: Colors.grey),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSaveButton(
    String text,
    Color color, {
    Color? textColor = Colors.white,
    Color? borderColor,
    bool isAddressLoad = false,
  }) {
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 20.0),
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
        color: color,
        borderRadius: BorderRadius.circular(50.0),
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: Center(
        child: isAddressLoad
            ? const SizedBox(
                height: 26,
                width: 26,
                child: CircularProgressIndicator(
                  color: AppColor.appColor,
                  strokeWidth: 3,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  color: textColor,
                ),
              ),
      ),
    );
  }
}
