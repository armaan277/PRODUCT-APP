import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/screens/address_screen.dart';

class AddNewCardScreenPayment extends StatelessWidget {
  const AddNewCardScreenPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.appBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add New Card',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Number Field
            buildInputField(
              label: "Card Number",
              hintText: "0000 0000 0000 0000",
              inputType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CardNumberInputFormatter(),
              ],
              maxLength: 19,
            ),
            SizedBox(height: 16.0),

            // Expiry Date and CVV Fields in Row
            Row(
              children: [
                Expanded(
                  child: buildInputField(
                    label: "Expiry Date",
                    hintText: "MM/YY",
                    inputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      ExpiryDateInputFormatter(),
                    ],
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: buildInputField(
                    label: "CVV",
                    hintText: "•••",
                    inputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 3,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),

            // Card Holder Name Field
            buildInputField(
              label: "Card Holder Name",
              hintText: "Card Holder Name",
              inputType: TextInputType.name,
            ),
            SizedBox(height: 32.0),

            // Add Card Button
            ElevatedButton(
              onPressed: () {
                // Handle Add Card Action
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AddressScreen();
                }));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.appColor,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 55.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Add Card',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField({
    required String label,
    required String hintText,
    TextInputType? inputType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          maxLength: maxLength,
          keyboardType: inputType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            counterText: '',
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 12.0,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey[50]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: AppColor.appColor),
            ),
          ),
        ),
      ],
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(' ', '');
    String formatted = '';
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += text[i];
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll('/', '');
    if (text.length > 4) text = text.substring(0, 4);
    String formatted = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 2) formatted += '/';
      formatted += text[i];
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
