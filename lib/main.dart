import 'package:flutter/material.dart';
import 'package:pin_code/services/pin_code_services.dart';
import 'package:pin_code/view/pin_code_page.dart';
import 'package:pin_code/view_model/pin_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pin code app',
      home: PinCodePage(viewModelPincode: ViewModelPincode(PinCodeSerivces())),
    );
  }
}
