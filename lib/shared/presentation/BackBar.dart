import 'package:flutter/material.dart';

class BackBar extends StatelessWidget implements PreferredSizeWidget{
  const BackBar({
    super.key,
    required this.onPressed
  });

  final onPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColor),
        onPressed: onPressed,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
