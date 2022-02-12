import 'package:flutter/material.dart';
import 'package:pin_code/view_model/pin_controller.dart';
import 'package:provider/provider.dart';

import 'widgets/app_bar_widget.dart';
import 'widgets/keyboard_widget.dart';
import 'widgets/pass_code_widget.dart';

const colorInfo = Color.fromRGBO(0, 0, 0, 0.6);

class PinCodePage extends StatelessWidget {
  final ViewModelPincode viewModelPincode;
  const PinCodePage({Key? key, required this.viewModelPincode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => viewModelPincode,
      child: Scaffold(
          appBar: const CustomAppBarWidget(),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                PassCodeWidget(),
                KeyboardWidget(),
              ],
            ),
          )),
    );
  }
}
