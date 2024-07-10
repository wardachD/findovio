import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _checkConnection();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _checkConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(
          WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shadowColor: Colors.white,
              backgroundColor: Colors.black,
              surfaceTintColor: Colors.black,
              title: const Center(
                  child: Text(
                'Ups, brak internetu 😭',
                style: TextStyle(color: Colors.white),
              )),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    MdiIcons.wifiOff,
                    color: Colors.red,
                    size: 30,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Niestety do korzystania z aplikacji potrzebujesz połączenie z internetem.\n\nSwoje rezerwacje możesz również sprawdzić w mailu.',
                    style: TextStyle(color: Color.fromARGB(226, 250, 247, 243)),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Włącz internet by znów cieszyć się aplikacją.',
                    style: TextStyle(color: Color.fromARGB(226, 250, 247, 243)),
                  ),
                ],
              ),
              actions: const [],
            ),
          ),
          barrierColor: const Color.fromARGB(211, 255, 255, 255));
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.back();
      });

      // Close the dialog when connected
    }
  }
}
