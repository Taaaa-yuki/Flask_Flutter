import 'package:flutter/material.dart';
import 'package:lyrics_app/app/constants/app_text.dart';
import 'package:lyrics_app/app/constants/app_color.dart';
import 'package:lyrics_app/app/widgets/custom_tabbar_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppText.appName,
      theme: ThemeData(
        primarySwatch: AppColor.primaryColorMaterial
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const CustomTabbarWidget();
  }
}
