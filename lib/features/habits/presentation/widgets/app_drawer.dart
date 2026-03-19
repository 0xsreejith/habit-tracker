import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoSwitch(
              value: Provider.of<ThemeProvider>(context).isDarkMode,
              onChanged: (value) => Provider.of<ThemeProvider>(
                context,
                listen: false,
              ).toggleTheme(),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
