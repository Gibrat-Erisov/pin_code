import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pin_code/services/pin_code_services.dart';
import 'package:pin_code/view/pin_code_page.dart';
import 'package:pin_code/view/widgets/keyboard_widget.dart';
import 'package:pin_code/view/widgets/pass_code_widget.dart';
import 'package:pin_code/view_model/pin_controller.dart';

class MockPinCodeSerivces extends Mock implements PinCodeSerivces {}

void main() {
  late ViewModelPincode viewModelPincode;
  late MockPinCodeSerivces mockPinCodeSerivces;

  setUp(() {
    mockPinCodeSerivces = MockPinCodeSerivces();
    viewModelPincode = ViewModelPincode(mockPinCodeSerivces);
  });

  void setUpMockPinCodeSerivcesSuccess() =>
      when(() => mockPinCodeSerivces.comparePinCode(any()))
          .thenAnswer((_) async {});
  void setUpMockPinCodeSerivcesError() =>
      when(() => mockPinCodeSerivces.comparePinCode(any()))
          .thenThrow(IncorrectPinCode());

  testWidgets("whent initialized then items are seen", (widgetTester) async {
    await widgetTester.pumpWidget(
        TestWidget(child: PinCodePage(viewModelPincode: viewModelPincode)));

    final passwordDigits = viewModelPincode.state.passwordDigits;

    final keyboardItemFinder = find.byWidgetPredicate((widget) =>
        widget.key != null &&
        widget.key is ValueKey<String> &&
        (widget.key as ValueKey<String>).value.contains('$KeyboardWidget'));

    final passcodeItemFinder = find.byWidgetPredicate((widget) =>
        widget.key != null &&
        widget.key is ValueKey<String> &&
        (widget.key as ValueKey<String>).value.contains('$PassCodeWidget'));

    await widgetTester.pump();
    expect(keyboardItemFinder, findsNWidgets(12));
    expect(passcodeItemFinder, findsNWidgets(passwordDigits));
  });

  testWidgets('onPressdNumber the pinCode widget is filled',
      (widgetTester) async {
    await widgetTester.pumpWidget(
        TestWidget(child: PinCodePage(viewModelPincode: viewModelPincode)));

    final keyboardItemFinder = find.byKey(ValueKey('${KeyboardWidget}1'));
    await widgetTester.tap(keyboardItemFinder);
    await widgetTester.pump();

    final passcodeItemFinder = find.byWidgetPredicate((widget) =>
        widget.key != null &&
        widget.key is ValueKey<String> &&
        (widget.key as ValueKey<String>)
            .value
            .contains('$PassCodeWidget${true}'));

    expect(passcodeItemFinder, findsNWidgets(1));
  });

  testWidgets('on pincode verified successfully', (widgetTester) async {
    await widgetTester.pumpWidget(
        TestWidget(child: PinCodePage(viewModelPincode: viewModelPincode)));
    setUpMockPinCodeSerivcesSuccess();
    final passwordDigits = viewModelPincode.state.passwordDigits;

    final keyboardItemFinder = find.byKey(ValueKey('${KeyboardWidget}1'));
    for (int i = 0; i < passwordDigits; i++) {
      await widgetTester.tap(keyboardItemFinder);
      await widgetTester.pumpAndSettle();
    }

    final passcodeItemFinder = find.byWidgetPredicate((widget) =>
        widget.key != null &&
        widget.key is ValueKey<String> &&
        (widget.key as ValueKey<String>)
            .value
            .contains('$PassCodeWidget${true}'));

    expect(passcodeItemFinder, findsNWidgets(passwordDigits));
    // final errorText = find.text('Incorrect PIN Code');
    expect(find.text('Incorrect PIN Code'), findsNothing);
  });

  testWidgets('on pincode verified with error', (widgetTester) async {
    await widgetTester.pumpWidget(
        TestWidget(child: PinCodePage(viewModelPincode: viewModelPincode)));
    setUpMockPinCodeSerivcesError();
    final passwordDigits = viewModelPincode.state.passwordDigits;

    final keyboardItemFinder = find.byKey(ValueKey('${KeyboardWidget}1'));
    for (int i = 0; i < passwordDigits; i++) {
      await widgetTester.tap(keyboardItemFinder);
      await widgetTester.pumpAndSettle();
    }

    final passcodeItemFinder = find.byWidgetPredicate((widget) =>
        widget.key != null &&
        widget.key is ValueKey<String> &&
        (widget.key as ValueKey<String>)
            .value
            .contains('$PassCodeWidget${true}'));

    expect(passcodeItemFinder, findsNWidgets(passwordDigits));
    expect(find.text('Incorrect PIN Code'), findsOneWidget);
  });

  testWidgets('on pressed delete button', (widgetTester) async {
    await widgetTester.pumpWidget(
        TestWidget(child: PinCodePage(viewModelPincode: viewModelPincode)));

    setUpMockPinCodeSerivcesError();
    final passwordDigits = viewModelPincode.state.passwordDigits;

    final keyboardItemFinder = find.byKey(ValueKey('${KeyboardWidget}1'));
    for (int i = 0; i < passwordDigits; i++) {
      await widgetTester.tap(keyboardItemFinder);
      await widgetTester.pumpAndSettle();
    }

    final keyboardDeleteFinder =
        find.byKey(ValueKey('${KeyboardWidget}delete'));
    await widgetTester.tap(keyboardDeleteFinder);
    await widgetTester.pump();

    final passcodeItemFinder = find.byWidgetPredicate((widget) =>
        widget.key != null &&
        widget.key is ValueKey<String> &&
        (widget.key as ValueKey<String>)
            .value
            .contains('$PassCodeWidget${true}'));

    expect(passcodeItemFinder, findsNWidgets(passwordDigits - 1));
  });
}

class TestWidget extends StatelessWidget {
  final Widget child;
  const TestWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: child,
    );
  }
}
