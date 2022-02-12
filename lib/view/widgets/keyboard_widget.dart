import 'package:flutter/material.dart';
import 'package:pin_code/view_model/pin_controller.dart';
import 'package:provider/provider.dart';

class KeyboardWidget extends StatelessWidget {
  const KeyboardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        ..._keyboardButtons(context),
      ],
    );
  }

  Widget _buttonWrapper(BuildContext context,
      {required VoidCallback onPressed, int? number, Widget? child, Key? key}) {
    final childRender =
        child ?? Text(number.toString(), style: const TextStyle(fontSize: 34));
    return RawMaterialButton(
      key: key,
      onPressed: onPressed,
      shape: const CircleBorder(),
      constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 0.3, minHeight: 60),
      child: childRender,
    );
  }

  List<Widget> _keyboardButtons(BuildContext context) {
    var list = <Widget>[];

    final model = context.read<ViewModelPincode>();

    for (int i = 1; i <= 9; i++) {
      list.add(_buttonWrapper(context,
          onPressed: () async => await model.enterPin(i),
          number: i,
          key: ValueKey('$KeyboardWidget$i')));
    }
    list.add(_buttonWrapper(context,
        key: ValueKey('${KeyboardWidget}fingerprint'),
        onPressed: () {},
        child: const Icon(
          Icons.fingerprint,
          size: 40,
        )));

    list.add(
      _buttonWrapper(
        context,
        onPressed: () async => await model.enterPin(0),
        number: 0,
        key: ValueKey('${KeyboardWidget}0'),
      ),
    );
    list.add(_buttonWrapper(context,
        key: ValueKey('${KeyboardWidget}delete'),
        onPressed: () => model.onPressedDelete(),
        child: const Icon(
          Icons.backspace_outlined,
          size: 30,
        )));
    return list;
  }
}
