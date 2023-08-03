import 'package:flutter/material.dart';
import 'package:lyrics_app/app/constants/app_color.dart';
import 'package:lyrics_app/app/views/account_view.dart';
import 'package:lyrics_app/app/views/favorite_view.dart';
import 'package:lyrics_app/app/views/home_view.dart';
import 'package:lyrics_app/app/views/search_view.dart';
import 'package:lyrics_app/app/states/navigation_state.dart';
import 'package:rounded_tabbar_widget/rounded_tabbar_widget.dart';

class CustomTabbarWidget extends StatefulWidget {
  const CustomTabbarWidget({Key? key}) : super(key: key);

  @override
  State<CustomTabbarWidget> createState() => _CustomTabbarState();
}

class _CustomTabbarState extends State<CustomTabbarWidget> {

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
      itemNormalColor: AppColor.primaryTextColor,
      itemSelectedColor: AppColor.buttonColor,
      tabBarBackgroundColor: AppColor.primaryColor,
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
