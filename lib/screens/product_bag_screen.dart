import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/product_provider/product_provider.dart';

class ProductBag extends StatelessWidget {
  ProductBag({
    super.key,
  });
  Product? product;

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        title: Text('Product'),
        centerTitle: true,
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 4.0),
        itemCount: providerWatch.bagProducts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 130,
                    child: Image.network(
                      providerWatch.bagProducts[index].thumbnail,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            overflow: TextOverflow.ellipsis,
                            providerWatch.bagProducts[index].title),
                        Text(
                            'Brand: ${providerWatch.bagProducts[index].brand}'),
                        SizedBox(width: 20),
                        Text('Size: S'),
                        Row(
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
                                    Icons.remove,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            Text('${product?.productInfoIncValue}'),
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
                                    Icons.add,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.more_vert),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
