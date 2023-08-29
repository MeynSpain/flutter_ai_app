import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:talker_flutter/talker_flutter.dart';

class SubScreen extends StatefulWidget {
  const SubScreen({super.key});

  @override
  State<SubScreen> createState() => _SubScreenState();
}

class _SubScreenState extends State<SubScreen> {
  final InAppPurchase _iap = InAppPurchase.instance;
  bool _available = true;

  List<ProductDetails> _products = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _available = await _iap.isAvailable();

      log('########## Доступ ################ $_available');
      if (_available) {
        await _getProducts();
      }
    }  catch (e, st) {
      log('################ AVILABLE ERROR ################');
      getIt<Talker>().handle(e, st);
    }

  }

  Future<void> _getProducts() async {
    const Set<String> _ids = {
      // 'sub-1',
      'ai_subscribe',
      'test_product_1',
      'test_product_2',
    };

    final ProductDetailsResponse response =
        await _iap.queryProductDetails(_ids);

    log('###### PRODUCTS ######\n${response.toString()}');

    if (response.notFoundIDs.isNotEmpty) {
      getIt<Talker>()
          .error('Продукты не были найдены: ${response.notFoundIDs}');
    }

    setState(() {
      _products = response.productDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Подписка'),
      ),
      body: _available
          ? ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ListTile(
            title: Text(product.title),
            subtitle: Text(product.description),
            trailing: Text(product.price),
            onTap: ()async {
              final PurchaseParam purchaseParam =
                  PurchaseParam(productDetails: product);
              await _iap.buyNonConsumable(purchaseParam: purchaseParam);
            },
          );
        },)
          : Center(
              child: Text('Не получилось получить доступ к продуктам'),
            ),
    );
  }
}
