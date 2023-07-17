import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScannerView extends StatefulWidget {
  const QrCodeScannerView({super.key});

  @override
  State<QrCodeScannerView> createState() => _QrCodeScannerViewState();
}

class _QrCodeScannerViewState extends State<QrCodeScannerView> with NavigatorMixin {

  bool _isScanned = false;

  late final MobileScannerController _cameraController;

  @override
  void initState() {
    super.initState();
    _cameraController = MobileScannerController();
    _cameraController.start();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    const Color bgColor = Colors.black;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: _toggleableBar(),
      body: _scanner(),
    );
  }

  AppBar _toggleableBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          router.pushReplacementToPage(NavigatorRoutesPaths.userDiscover);
        },
        icon: const Icon(Icons.chevron_left_sharp)
      ),
      foregroundColor: Colors.white,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        'Qr Code Taraması',
        style: TextStyle(
          fontFamily: FontTheme.fontFamily,
          fontWeight: FontTheme.xfontWeight,
          fontSize: FontTheme.xlfontSize
        ),
      ),
      actions: [
        IconButton(
          color: Colors.white,
          onPressed: () => _cameraController.toggleTorch(),
          icon: ValueListenableBuilder(
            valueListenable: _cameraController.torchState,
            builder: (context, value, child) {
              switch (value){
                case TorchState.off:
                  return const Icon(Icons.flash_off_sharp);
                case TorchState.on:
                  return const Icon(Icons.flash_on_sharp);
              }
            },
          ),
        ),
        IconButton(
          color: Colors.white,
          onPressed: () => _cameraController.switchCamera(),
          icon: Icon(Platform.isAndroid ? Icons.flip_camera_android_rounded : Icons.flip_camera_ios_rounded)
        ),
      ],
    );
  }

  Transform _scanner() {
    return Transform.rotate(
      angle: 3 * pi / 2,
      child: MobileScanner(
        controller: _cameraController,
        fit: BoxFit.cover,
        onDetect: (barcodes) {
          inspect(barcodes);
          if (!_isScanned) {
            String code = barcodes.raw;
            _isScanned = true;
            inspect(code);
          }
        },
      ),
    );
  }
}