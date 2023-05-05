import 'package:flutter/material.dart';
import 'package:lyrics_app/constants/color.dart';
import 'package:lyrics_app/views/account_view.dart';
import 'package:lyrics_app/views/favorite_view.dart';
import 'package:lyrics_app/views/home_view.dart';
import 'package:lyrics_app/views/lyrics_view.dart';
import 'package:rounded_tabbar_widget/rounded_tabbar_widget.dart';


class LyricsTabBar extends StatelessWidget {
  const LyricsTabBar({this.currentIndex = 0, Key? key}) : super(key: key);

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return RoundedTabbarWidget(
      selectedIndex: currentIndex,
      itemNormalColor: AppColors.black,
      itemSelectedColor: AppColors.black,
      tabBarBackgroundColor: AppColors.yellow,
      tabIcons: const [
        Icons.home,
        Icons.search,
        Icons.favorite,
        Icons.person,
      ],
      pages: const [
        HomeView(),
        LyricsView(),
        FavoriteView(),
        AccountView(),
      ],
    );
  }
}
