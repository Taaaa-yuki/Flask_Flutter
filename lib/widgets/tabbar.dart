import 'package:flutter/material.dart';
import 'package:lyrics_app/constants/color.dart';
import 'package:lyrics_app/views/account_view.dart';
import 'package:lyrics_app/views/favorite_view.dart';
import 'package:lyrics_app/views/home_view.dart';
import 'package:lyrics_app/views/search_view.dart';
import 'package:lyrics_app/states/navigation_state.dart';
import 'package:rounded_tabbar_widget/rounded_tabbar_widget.dart';

class LyricsTabBar extends StatefulWidget {
  const LyricsTabBar({Key? key}) : super(key: key);

  @override
  State<LyricsTabBar> createState() => _LyricsTabBarState();
}

class _LyricsTabBarState extends State<LyricsTabBar> {

  void onTabSelected(int index) {
    if (NavigationState().currentIndex != index) {
      setState(() {
        NavigationState().currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RoundedTabbarWidget(
      selectedIndex: NavigationState().currentIndex,
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
        SearchView(),
        FavoriteView(),
        AccountView(),
      ],
      onTabItemIndexChanged: onTabSelected,
    );
  }
}
