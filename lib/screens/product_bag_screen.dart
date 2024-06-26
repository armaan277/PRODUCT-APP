import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/product_provider/product_provider.dart';

class ProductBag extends StatelessWidget {
  const ProductBag({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Product'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: providerWatch.bagProducts.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(providerWatch.bagProducts[index].title),
            ),
          );
        },
      ),
    );
  }
}
