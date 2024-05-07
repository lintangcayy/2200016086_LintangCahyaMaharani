import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'supplemental/asymmetric_view.dart';
import 'model/product.dart';
import 'model/products_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // TODO: Make a collection of cards (102)
  List<Card> _buildGridCards(BuildContext context) {
  List<Product> products = ProductsRepository.loadProducts(Category.all);

  if (products.isEmpty) {
    return const <Card>[];
  }

  final ThemeData theme = Theme.of(context);
  final NumberFormat formatter = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString());

  return products.map((product) {
    return Card(
      clipBehavior: Clip.antiAlias,
      // TODO: Adjust card heights (103)
      elevation: 0.0,
      child: Column(
        // TODO: Center items on the card (103)
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 18 / 11,
            child: Image.asset(
              product.assetName,
              package: product.assetPackage,
             // TODO: Adjust the box size (102)
             fit: BoxFit.fitWidth,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
              child: Column(
               // TODO: Align labels to the bottom and center (103)
               mainAxisAlignment: MainAxisAlignment.end,
               crossAxisAlignment: CrossAxisAlignment.center,
                // TODO: Change innermost Column (103)
                children: <Widget>[
                 // TODO: Handle overflowing labels (103)
                 Text(
                    product.name,
                    style: theme.textTheme.titleLarge,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    formatter.format(product.price),
                    style: theme.textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }).toList();
}
  // TODO: Add a variable for Category (104)
  @override
  Widget build(BuildContext context) {
    // TODO: Return an AsymmetricView (104)
    // TODO: Pass Category variable to AsymmetricView (104)
    return  Scaffold(
      // TODO: Add app bar (102)
      appBar: AppBar(
        title: Text(
          'ON-SHOP',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          color: Colors.white,
          onPressed: (){
            print('test');
          },
        icon: const Icon(
          Icons.menu,
          semanticLabel: 'menu button',
      ),
        ),
      actions: [
        IconButton(onPressed: (){

        }, icon: Icon(Icons.search)),
        IconButton(onPressed: ((){

        }), icon: Icon(Icons.tune, color: Colors.white,)),
      ],
      ),
      
      
      // TODO: Add a grid view (102)
      body: AsymmetricView(
        products: ProductsRepository.loadProducts(Category.all),
      ),
      // TODO: Set resizeToAvoidBottomInset (101)
      resizeToAvoidBottomInset: false,
    );
  }
}
