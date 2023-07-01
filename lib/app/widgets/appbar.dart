import 'package:flutter/material.dart';
import 'package:lyrics_app/app/constants/color.dart';
import 'package:lyrics_app/app/states/navigation_state.dart';
import 'package:lyrics_app/app/widgets/tabbar.dart';

class LyricsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LyricsAppBar({Key? key, required this.title}) : super(key: key);
  
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22.0,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.yellow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      elevation: 0.0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: const Icon(
            Icons.menu,
            color: AppColors.black,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            onPressed: () {
              if (NavigationState().currentIndex != 1) {
                NavigationState().currentIndex = 1;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LyricsTabBar(),
                  ),
                );
              }
            },
            icon: const Icon(
              Icons.search,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
