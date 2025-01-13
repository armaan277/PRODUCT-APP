import 'package:flutter/material.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/screens/add_new_card_payment_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen>
    with TickerProviderStateMixin {
  int? expandedIndex; // Tracks the currently expanded payment option
  int? selectedPaymentOption; // Tracks the selected sub-option (radio button)

  @override
  Widget build(BuildContext context) {
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
                      icon: Icons.credit_card,
                      title: 'Credit/Debit Card',
                      index: 0,
                      children: [
                        Divider(
                          color: Colors.grey,
                        ),
                        buildElevatedListTile(
                          trailingWidget: Padding(
                            padding: const EdgeInsets.only(right: 14.0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppColor.appColor,
                            ),
                          ),
                          leadingIcon: Icons.add_circle_outline,
                          title: 'Add New Card',
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return AddNewCardScreenPayment();
                            }));
                          },
                        ),
                        buildElevatedListTile(
                          leadingIcon: Icons.credit_card,
                          title: '**** **** **** 1234',
                          onTap: () {},
                          trailingWidget: Radio(
                            value: 1,
                            groupValue: selectedPaymentOption,
                            onChanged: (int? newValue) {
                              setState(() {
                                selectedPaymentOption = newValue!;
                              });
                            },
                            activeColor: AppColor.appColor,
                          ),
                        ),
                      ],
                    ),
                    buildCustomPaymentOption(
                      icon: Icons.money,
                      title: 'Cash On Delivery',
                      index: 1,
                      children: [
                        buildElevatedListTile(
                          leadingIcon: Icons.attach_money,
                          title: 'Pay on delivery',
                          onTap: () {
                            setState(() {
                              selectedPaymentOption = 2;
                            });
                          },
                          trailingWidget: Radio(
                            value: 2,
                            groupValue: selectedPaymentOption,
                            onChanged: (int? newValue) {
                              setState(() {
                                selectedPaymentOption = newValue!;
                              });
                            },
                            activeColor: AppColor.appColor,
                          ),
                        ),
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
                      '\$28.6',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Payment action
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(0.0, 52),
                    backgroundColor: AppColor.appColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Make Payment',
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
    required IconData icon,
    required String title,
    required int index,
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
          InkWell(
            onTap: () {
              setState(() {
                expandedIndex = (expandedIndex == index) ? null : index;
              });
            },
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Icon(icon, color: AppColor.appColor),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: Icon(
                      expandedIndex == index
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColor.appColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: expandedIndex == index
                ? Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(children: children),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget buildElevatedListTile({
    required IconData leadingIcon,
    required String title,
    Widget? trailingWidget,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: onTap,
        child: ListTile(
          leading: Icon(leadingIcon, color: AppColor.appColor),
          title: Text(title),
          trailing: trailingWidget,
        ),
      ),
    );
  }
}
