import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:shopping_app/widgets/container_button.dart';
import '../model/product.dart';
import '../widgets/show_modal_bottom_sheet.dart';

class ProductInfo extends StatefulWidget {
  final Product product;
  const ProductInfo({
    super.key,
    required this.product,
  });

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int currentIndex = 0;
  final CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
    final providerRead = context.read<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: Text(
          'Product Detail',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: Navigator.of(context).pop,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CarouselSlider(
              items: widget.product.images.map((image) {
                return Image.network(image);
              }).toList(),
              options: CarouselOptions(
                height: 300,
                autoPlay: widget.product.images.length > 1 ? true : false,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
              carouselController: carouselController,
            ),
          ),
          if (widget.product.images.length > 1)
            DotsIndicator(
              dotsCount: widget.product.images.length,
              position: currentIndex,
              decorator: DotsDecorator(
                color: Colors.grey,
                activeColor: AppColor.appColor,
                size: const Size.square(9.0),
                activeSize: const Size(12.0, 12.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onTap: (index) {
                carouselController.animateToPage(index);
              },
            ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$ ${widget.product.price}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColor.appColor,
                          ),
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 7,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 22,
                                  child: Icon(
                                    Icons.favorite_border_outlined,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              widget.product.availabilityStatus,
                              style: TextStyle(
                                  color: widget.product.availabilityStatus ==
                                          'Low Stock'
                                      ? Colors.red
                                      : Colors.green),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      textAlign: TextAlign.justify,
                      widget.product.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Brand: ${widget.product.brand}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Discount: ${widget.product.discountPercentage}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColor.appColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Choose amount:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 16,
                                  child: IconButton(
                                    onPressed: () {
                                      providerRead
                                          .productInfoDec(widget.product);
                                    },
                                    icon: Icon(
                                      Icons.remove,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    '${widget.product.productInfoIncValue}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 16,
                                  child: IconButton(
                                    onPressed: () {
                                      providerRead
                                          .productInfoInc(widget.product);
                                    },
                                    icon: Icon(
                                      color: Colors.white,
                                      Icons.add,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '⭐ ${widget.product.rating}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ShowModalBottomSheet(product: widget.product),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        margin: EdgeInsets.only(bottom: 10),
        height: 60,
        color: Colors.white,
        child: ContainerButton(product: widget.product),
      ),
    );
  }
}
