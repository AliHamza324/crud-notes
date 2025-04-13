import 'dart:async';
import 'package:ali_hassan/screens/home_screen.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Timer(Duration(seconds: 4), () {
      Get.offAll(() => HomeScreen());
    });
  }
}
