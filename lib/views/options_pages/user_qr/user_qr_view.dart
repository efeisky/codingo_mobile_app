import 'package:codingo/product/constant/project_items.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/product/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserQrView extends StatefulWidget {
  const UserQrView({super.key});

  @override
  State<UserQrView> createState() => _UserQrViewState();
}

class _UserQrViewState extends State<UserQrView> {
  final _currentPage = NavigatorRoutesPaths.userProfile;
  @override
  Widget build(BuildContext context) {
    final username = context.read<UserNotifier>().currentUsername;
    final qrUrl = '${ProjectItems.clientUrl}$username/profile';
    final device = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        mainTitle: 'QR Kodum',
        hasArrow: true,
        backPage: NavigatorRoutesPaths.menu,
      ),
      body: Center(
        child: QrImageView(
          data: qrUrl,
          version: QrVersions.auto,
          size: device * .5,
          semanticsLabel: 'Codingo QR Kodu',
          eyeStyle: const QrEyeStyle(
            color: _QrViewTheme.qrColor,
            eyeShape: QrEyeShape.square
          ),
          dataModuleStyle: const QrDataModuleStyle(
            color: _QrViewTheme.qrColor,
            dataModuleShape: QrDataModuleShape.square
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(activePage: _currentPage,)
    );
  }
}

class _QrViewTheme {
  static const Color qrColor = Color.fromRGBO(56, 171, 109, 1);
}