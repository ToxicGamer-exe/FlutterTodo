import 'package:flutter/material.dart';
import 'package:todo_app/settings.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title, this.props});

  final String title;
  final dynamic props;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings), // Replace with your desired icon
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Setting()),
            );
          },
        ),
      ],
      backgroundColor: props?.backgroundColor ?? Colors.green,
      centerTitle: props?.centerTitle ?? true,
      elevation: props?.elevation ?? 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}