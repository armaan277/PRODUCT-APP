import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/contants/constant.dart';
import 'package:shopping_app/screens/product_bag_screen.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import '../model/product.dart';
import '../widgets/showbottomsheet_container.dart';

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
        backgroundColor: Color(0xffDB3022),
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
                activeColor: Theme.of(context).primaryColor,
                size: const Size.square(9.0),
                activeSize: const Size(18.0, 9.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
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
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$ ${widget.product.price}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffDB3022),
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Discount: ${widget.product.discountPercentage}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffDB3022),
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
                            fontWeight: FontWeight.bold,
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
                                      providerRead.productInfoDec();
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
                                      '${providerWatch.productInfoIncValue}'),
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 16,
                                  child: IconButton(
                                    onPressed: () {
                                      providerRead.productInfoInc();
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
                        Text('⭐ ${widget.product.rating}'),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  color: Color(0xffF9F9F9),
                                  width: double.infinity,
                                  height: 300,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 60,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Divider(
                                          height: 20,
                                          thickness: 5,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Select Size',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ShowbottomsheetContainer(size: 'S'),
                                          ShowbottomsheetContainer(size: 'M'),
                                          ShowbottomsheetContainer(size: 'L'),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ShowbottomsheetContainer(size: 'X'),
                                          ShowbottomsheetContainer(size: 'XL'),
                                          ShowbottomsheetContainer(size: 'XXL'),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      SizedBox(
                                        height: 60,
                                        width: double.infinity,
                                        child: FilledButton(
                                          style: FilledButton.styleFrom(
                                            backgroundColor: AppColor.appColor,
                                          ),
                                          onPressed: () {
                                            if (!providerWatch.bagProducts
                                                .contains(widget.product)) {
                                              providerWatch.bagProducts
                                                  .add(widget.product);
                                              providerRead.bagProductscounts();
                                            } else {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return ProductBag();
                                              }));
                                            }
                                            setState(() {});
                                          },
                                          child: Text(
                                            !providerWatch.bagProducts
                                                    .contains(widget.product)
                                                ? 'Add to Cart'
                                                : 'Go to Bag',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 40,
                            width: 74,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(color: AppColor.appColor),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Size'),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        )
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Color(0xffDB3022),
              ),
              onPressed: () {
                if (!providerWatch.bagProducts.contains(widget.product)) {
                  providerWatch.bagProducts.add(widget.product);
                  providerRead.bagProductscounts();
                } else {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ProductBag();
                  }));
                }
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined),
                  SizedBox(width: 10),
                  Text(
                    !providerWatch.bagProducts.contains(widget.product)
                        ? 'Add to Cart'
                        : 'Go to Bag',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
