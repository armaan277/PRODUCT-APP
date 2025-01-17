import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/product_provider/product_provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  int? expandedIndex; // Tracks the currently expanded payment option
  // int? selectedPaymentOption; // Tracks the selected sub-option (radio button)
  String payment = 'Make Payment';
  int selectedPaymentMethod = 1;

  final Razorpay _razorpay = Razorpay();

  @override
  Widget build(BuildContext context) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    return Scaffold(
      backgroundColor: AppColor.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.appBackgroundColor,
        title: Text(
          'Payment Method',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16.0),
                child: Column(
                  children: [
                    buildCustomPaymentOption(
                      title: 'Credit/Debit Card/UPI',
                      index: 1,
                      selectedPaymentMethod: selectedPaymentMethod!,
                      onSelectOption: (int newValue) {
                        setState(() {
                          selectedPaymentMethod = newValue;
                          payment = 'Make Payment';

                          debugPrint(
                              'selectedPaymentMethod : $selectedPaymentMethod');
                        });
                      },
                      children: [
                        Text("Enter card details here..."),
                      ],
                    ),
                    buildCustomPaymentOption(
                      title: 'Cash On Delivery',
                      index: 2,
                      selectedPaymentMethod: selectedPaymentMethod!,
                      onSelectOption: (int newValue) {
                        setState(() {
                          selectedPaymentMethod = newValue;
                          payment = 'Place Order';
                          debugPrint(
                              'selectedPaymentMethod : $selectedPaymentMethod');
                        });
                      },
                      children: [
                        Text("Enter PayPal account details..."),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      '\$${context.read<ProductProvider>().totalPrice}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedPaymentMethod == 1) {
                      var options = {
                        'key': 'rzp_test_YghCO1so2pwPnx',
                        'amount': (context.read<ProductProvider>().totalPrice *
                                100)
                            .toInt(), // Amount in paise (e.g., 500.00 INR = 50000 paise)
                        'currency': 'USD', // Specify the currency
                        'name': 'AM Coders.',
                        'description': 'Flutter Developer',
                        'prefill': {
                          'contact': '8080773680',
                          'email': 'am@gmail.com',
                        }
                      };

                      _razorpay.open(options);
                    } else {
                      Navigator.of(context).pushNamed('order_success_screen');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(0.0, 52),
                    backgroundColor: AppColor.appColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    payment,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCustomPaymentOption({
    required String title,
    required int index,
    required int selectedPaymentMethod,
    required ValueChanged<int> onSelectOption, // Callback to handle selection
    required List<Widget> children,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Radio<int>(
                  value: index,
                  groupValue: selectedPaymentMethod,
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      onSelectOption(newValue); // Call the provided callback
                    }
                  },
                  activeColor: AppColor.appColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Navigator.of(context).pushNamed('order_success_screen');
    debugPrint('response : ${response.data}');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed'),
        duration: Duration(seconds: 1),
      ),
    );
    debugPrint('response : $response');
  }

  @override
  void dispose() {
    try {
      _razorpay.clear();
    } catch (e) {
      debugPrint('dispose() Catch Block : $e');
    }
    super.dispose();
  }
}
