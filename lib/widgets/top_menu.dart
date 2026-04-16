import 'package:flutter/material.dart';
import '../views/about/about_page.dart';
import '../views/empty/empty_page.dart';
import '../views/note/note_page.dart';
import '../views/welcome/welcome_page.dart';

class TopMenu extends StatelessWidget {
  final int currentIndex;

  const TopMenu({
    super.key,
    required this.currentIndex,
  });

  void _go(BuildContext context, int index) {
    Widget page;

    switch (index) {
      case 0:
        page = const WelcomePage();
        break;
      case 1:
        page = const AboutPage();
        break;
      case 2:
        page = const EmptyPage();
        break;
      case 3:
        page = const NotePage();
        break;
      default:
        page = const WelcomePage();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = ['Welcome', 'About', 'Trống', 'CRUD'];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final selected = currentIndex == index;

          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _go(context, index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF5B8DEF) : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                items[index],
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF2E3A59),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}