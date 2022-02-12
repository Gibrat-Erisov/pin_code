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

  Future<void> enterPin(int number) async {
    if (_state.pinCode.length >= _state.passwordDigits) return;
    _state.pinCode += number.toString();
    notifyListeners();
    if (_state.pinCode.length == _state.passwordDigits) {
      await _verifyPin();
    }
  }

  Future<void> _verifyPin() async {
    try {
      _state.errorTitle = '';
      notifyListeners();
      await service.comparePinCode(_state.pinCode);
      // TODO: do something
    } on IncorrectPinCode {
      _state.errorTitle = 'Incorrect PIN Code';
      notifyListeners();
    }
  }

  void onPressedDelete() {
    if (_state.pinCode.isNotEmpty) {
      _state.pinCode = _state.pinCode.substring(0, _state.pinCode.length - 1);
    }
    notifyListeners();
  }
}
