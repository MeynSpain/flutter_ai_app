import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:talker_flutter/talker_flutter.dart';

class SubScreen extends StatefulWidget {
  const SubScreen({super.key});

  @override
  State<SubScreen> createState() => _SubScreenState();
}

class _SubScreenState extends State<SubScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final String _productID = 'sub_test';

  bool _available = true;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _isSubcribe = false;

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;

    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        setState(() {
          _purchases.addAll(purchaseDetailsList);
          _listenToPurchaseUpdated(purchaseDetailsList);
          _isSubcribe = _purchases.any((purchase) => purchase.status == PurchaseStatus.purchased);
        });
      },
      onDone: () {
        getIt<Talker>().good('DONE');
        _subscription!.cancel();
      },
      onError: (error) {
        getIt<Talker>().error('Error');
        _subscription!.cancel();
      },
    );

    _initialize();
    super.initState();
  }

  Future<void> _initialize() async {
    try {
      _available = await _inAppPurchase.isAvailable();

      log('########## Доступ ################ $_available');

      List<ProductDetails> products = await _getProducts(
        productIds: Set<String>.from(
          [_productID],
        ),
      );

      setState(() {
        _products = products;
      });
    } catch (e, st) {
      log('################ AVAILABLE ERROR ################');
      getIt<Talker>().handle(e, st);
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          // _showPendingUI;
        getIt<Talker>().info('PENDING');
        // _isSubcribe = false;
          break;
        case PurchaseStatus.purchased:
          getIt<Talker>().info('PURCHASED');
          // _isSubcribe = true;
          break;
        case PurchaseStatus.restored:
          // bool valid = await _verifyPurcase(purcaseDetails);
          // if (!valid) {
          //   _handleInvalidPurchase(purcaseDetails);
          // }
          getIt<Talker>().info('RESTORED');
          break;
        case PurchaseStatus.error:
          getIt<Talker>().error(purchaseDetails.error!);
          break;
        default:
          break;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
        getIt<Talker>().good('COMPLETE PURCHASE');
      }
    });
  }

  Future<List<ProductDetails>> _getProducts(
      {required Set<String> productIds}) async {
    ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(productIds);

    log('###### PRODUCTS ######\n${response.toString()}');

    if (response.notFoundIDs.isNotEmpty) {
      getIt<Talker>()
          .error('Продукты не были найдены: ${response.notFoundIDs}');
    }

    // setState(() {
    //   _products = response.productDetails;
    // });

    return response.productDetails;
  }

  ListTile _buildProduct({required ProductDetails product}) {
    return ListTile(
      leading: Icon(Icons.attach_money),
      title: Text('${product.title} - ${product.price}'),
      subtitle: Text(product.description),
      trailing: ElevatedButton(
        onPressed: () {
          _subscribe(product: product);
        },
        child: Text(
          'Subscribe',
        ),
      ),
    );
  }

  ListTile _buildPurchase({required PurchaseDetails purchase}) {
    if (purchase.error != null) {
      return ListTile(
        title: Text('${purchase.error?.message}'),
        subtitle: Text(purchase.status.toString()),
      );
    }


    String? transactionDate;
    if (purchase.status == PurchaseStatus.purchased) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(purchase.transactionDate!),
      );
      // transactionDate = ' @ ' + DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
      transactionDate = date.toString();

    }

    return ListTile(
      title: Text('${purchase.productID} ${transactionDate ?? ''}'),
      subtitle: Text(purchase.status.toString()),
    );
  }

  void _subscribe({required ProductDetails product}) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _inAppPurchase.buyNonConsumable(
      purchaseParam: purchaseParam,
    );
  }

  String active = 'Active';
  String notActive = 'Not Active';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Подписка ${_isSubcribe ? active : notActive}'),
      ),
      body: _available
          ? Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Current Products ${_products.length}'),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          return _buildProduct(
                            product: _products[index],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Past Purchases: ${_purchases.length}'),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _purchases.length,
                          itemBuilder: (context, index) {
                            return _buildPurchase(
                              purchase: _purchases[index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Text('The Store Is Not Available'),
            ),
    );
  }

  _buy(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }
}
