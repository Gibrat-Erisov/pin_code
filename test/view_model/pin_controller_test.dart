import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pin_code/services/pin_code_services.dart';
import 'package:pin_code/view_model/pin_controller.dart';

class MockPinCodeSerivces extends Mock implements PinCodeSerivces {}

void main() {
  late ViewModelPincode viewModelPincode;
  late MockPinCodeSerivces mockPinCodeSerivces;
  setUp(() {
    mockPinCodeSerivces = MockPinCodeSerivces();
    viewModelPincode = ViewModelPincode(mockPinCodeSerivces);
  });

  test('initial pincode are correct', () async {
    expect(viewModelPincode.state.errorTitle, '');
    expect(viewModelPincode.state.title, 'Please enter PIN code');
    expect(viewModelPincode.state.pinCode, '');
    expect(viewModelPincode.state.passwordDigits, 4);
  });
  void setUpMockPinCodeSerivcesSuccess() =>
      when(() => mockPinCodeSerivces.comparePinCode(any()))
          .thenAnswer((_) async {});
  void setUpMockPinCodeSerivcesError() =>
      when(() => mockPinCodeSerivces.comparePinCode(any()))
          .thenThrow(IncorrectPinCode());

  group('enter pin code testing', () {
    test(
        'pinCode variable hav to be a same as entered numbers and change the length',
        () async {
      setUpMockPinCodeSerivcesSuccess();
      var pinCode = '';
      for (int i = 1; i <= viewModelPincode.state.passwordDigits; i++) {
        pinCode += i.toString();
        viewModelPincode.enterPin(i);
        expect(viewModelPincode.state.pinCode, pinCode);
        expect(viewModelPincode.state.pinCode.length, i);
      }
    });

    test(
        'pinCode variable length have to be less or same as variable passwordDigits',
        () {
      setUpMockPinCodeSerivcesSuccess();
      for (int i = 0; i <= viewModelPincode.state.passwordDigits; i++) {
        viewModelPincode.enterPin(i);
        var isLessOrSame = viewModelPincode.state.pinCode.length <=
            viewModelPincode.state.passwordDigits;
        expect(isLessOrSame, true);
      }
    });

    test('when pinCode return success', () async {
      // arrange
      setUpMockPinCodeSerivcesSuccess();

      // act
      for (int i = 0; i < viewModelPincode.state.passwordDigits; i++) {
        viewModelPincode.enterPin(i);
      }

      // assert
      expect(viewModelPincode.state.errorTitle, '');
      verify(() => mockPinCodeSerivces.comparePinCode(any()));
    });

    test('when pinCode return error', () async {
      // arrange
      setUpMockPinCodeSerivcesError();

      // act
      for (int i = 0; i < viewModelPincode.state.passwordDigits; i++) {
        viewModelPincode.enterPin(i);
      }

      // assert
      expect(viewModelPincode.state.errorTitle, 'Incorrect PIN Code');
      verify(() => mockPinCodeSerivces.comparePinCode(any()));
    });
  });

  group('delete PIN Code testing', () {
    test(
        'when delete butten pressed when the variable pinCode is Empty, the variable should not change',
        () {
      viewModelPincode.onPressedDelete();
      viewModelPincode.onPressedDelete();
      viewModelPincode.onPressedDelete();
      expect(viewModelPincode.state.pinCode, '');
    });

    test(
        'when entered PIN was incorrect and pressed delete button, the length of var pinCode should decrease',
        () {
      setUpMockPinCodeSerivcesError();

      for (int i = 0; i < viewModelPincode.state.passwordDigits; i++) {
        viewModelPincode.enterPin(i);
      }

      final length = viewModelPincode.state.pinCode.length;
      viewModelPincode.onPressedDelete();

      expect(viewModelPincode.state.pinCode.length, length - 1);
    });
  });
}
