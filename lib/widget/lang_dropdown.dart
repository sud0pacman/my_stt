import 'package:flutter/material.dart';

class LangDropdown extends StatelessWidget {
  final Function(String value) onTap;
  final List<String> languages;
  const LangDropdown({super.key, required this.onTap, required this.languages});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (ctx) {
        return languages.map((e) {
          return PopupMenuItem(
            child: Text(
              e
            ),
            onTap: () {
              onTap(e);
            },
          );
        }).toList();
      }
    );
  }
}
