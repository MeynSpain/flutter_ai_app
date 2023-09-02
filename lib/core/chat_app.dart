import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/core/router/router.dart';
import 'package:flutter_ai/core/theme/theme.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_ai/features/settings/bloc/settings_bloc.dart';
import 'package:flutter_ai/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class ChatApp extends StatefulWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  // late StreamSubscription<List<PurchaseDetails>> _subscription;
  //
  // @override
  // void initState() {
  //   /// IN APP PURCHASE
  //   final Stream purchaseUpdate =
  //     InAppPurchase.instance.purchaseStream;
  //
  //   _subscription = purchaseUpdate.listen((purchaseDetailsList) {
  //     _listenToPurchaseUpdated(purchaseDetailsList);
  //   }, onDone: () {
  //     _subscription.cancel();
  //   },
  //   onError: (error) {
  //     log(error.toString());
  //   });
  //
  //   super.initState();
  // }
  //
  // @override
  // void dispose() {
  //   _subscription.cancel();
  //   super.dispose();
  // }
  //
  // void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
  //   purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
  //     if (purchaseDetails.status == PurchaseStatus.pending) {
  //       _showPendingUI();
  //     } else {
  //       if (purchaseDetails.status == PurchaseStatus.error) {
  //         _handleError(purchaseDetails.error!);
  //       } else if (purchaseDetails.status == PurchaseStatus.purchased ||
  //       purchaseDetails.status == PurchaseStatus.restored) {
  //         bool valid = await _verifyPurchase(purchaseDetails);
  //         if (valid) {
  //           _deliverProduct(purchaseDetails);
  //         } else {
  //           _handleInvalidPurchase(purchaseDetails);
  //         }
  //       }
  //       if (purchaseDetails.pendingCompletePurchase) {
  //         await InAppPurchase.instance.completePurchase(purchaseDetails);
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<ChatBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<SettingsBloc>(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        // locale: Locale('ru'),
        debugShowCheckedModeBanner: false,
        title: 'ChatGPT',
        theme: mainTheme,
        routes: routes,
      ),
    );
  }
}
