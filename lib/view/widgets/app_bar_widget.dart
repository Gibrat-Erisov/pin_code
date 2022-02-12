import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const colorInfo = Color.fromRGBO(0, 0, 0, 0.6);

class CustomAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBarWidget({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  _CustomAppBarWidgetState createState() => _CustomAppBarWidgetState();
}

class _CustomAppBarWidgetState extends State<CustomAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.help_outline,
              color: colorInfo,
              size: 30,
            ))
      ],
    );
  }
}
