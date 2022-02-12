import 'package:flutter/material.dart';
import 'package:pin_code/services/pin_code_services.dart';

class ViewModelState {
  String errorTitle = '';
  String title = 'Please enter PIN code';
  String pinCode = '';
  int passwordDigits = 4;

  ViewModelState();
}

class ViewModelPincode extends ChangeNotifier {
  final _state = ViewModelState();
  final PinCodeSerivces service;

  ViewModelState get state => _state;
  ViewModelPincode(this.service);

  Future<void> enterPin(int number) async {}

  void onPressedDelete() {}
}
