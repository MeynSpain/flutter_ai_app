import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;

  MainAppBar({
    super.key,
    required this.title,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      centerTitle: centerTitle,
      title: centerTitle
          ? Text(title)
          : Padding(
              padding: const EdgeInsets.only(
                left: 8,
              ),
              child: Text(title),
            ),
      actions: [
        Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(
              right: 15,
            ),
            child: IconButton(
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              icon: Icon(Icons.menu),
            ),
          );
        }),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(4),
        child: Container(
          color: theme.primaryColor,
          height: 2,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
