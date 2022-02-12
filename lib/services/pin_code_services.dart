class PinCodeSerivces {
  Future<void> comparePinCode(String pinCode) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (pinCode != '1234') throw IncorrectPinCode();
  }
}

abstract class PinCodeErrors {}

class IncorrectPinCode extends PinCodeErrors {}
