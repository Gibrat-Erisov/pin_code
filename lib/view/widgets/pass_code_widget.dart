import 'package:flutter/material.dart';
import 'package:pin_code/view_model/pin_controller.dart';
import 'package:provider/src/provider.dart';

class PassCodeWidget extends StatelessWidget {
  const PassCodeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = context.select((ViewModelPincode value) => value.state.title);
    final errorTitle =
        context.select((ViewModelPincode value) => value.state.errorTitle);
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 48),
          Text(
            title,
            style: const TextStyle(
                fontSize: 24, color: Color.fromRGBO(0, 0, 0, 0.87)),
          ),
          const SizedBox(height: 10),
          Text(
            errorTitle,
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
          const SizedBox(height: 20),
          Wrap(
            children: [..._buildCircles(context)],
          )
        ],
      ),
    );
  }

  List<Widget> _buildCircles(BuildContext context) {
    final enteredPasscode =
        context.select((ViewModelPincode value) => value.state.pinCode);
    final passwordDigits =
        context.select((ViewModelPincode value) => value.state.passwordDigits);

    var list = <Widget>[];
    const colorPin = Color.fromRGBO(0, 0, 0, 0.12);

    for (int i = 0; i < passwordDigits; i++) {
      list.add(
        Container(
          width: 28,
          height: 28,
          margin: const EdgeInsets.all(12),
          key: ValueKey('$PassCodeWidget${i < enteredPasscode.length}$i'),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < enteredPasscode.length ? colorPin : null,
              border: Border.all(color: colorPin)),
        ),
      );
    }
    return list;
  }
}
