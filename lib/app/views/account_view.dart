import 'package:flutter/material.dart';
import 'package:lyrics_app/app/constants/app_text.dart';
import 'package:lyrics_app/app/widgets/custom_appbar_widget.dart';
import 'package:lyrics_app/app/widgets/custom_button_widget.dart';
import 'package:lyrics_app/app/widgets/custom_drawer_widget.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbarWidget(title: AppText.account),
      drawer: const CustomDrawerWidget(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://i.pravatar.cc/300?img=5'),
            ),
            const SizedBox(height: 16),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'johndoe@example.com',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              '+1 555-123-4567',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            CustomButtonWidget(
              onPressed: () {},
              text: 'Logout',
            ),
          ],
        ),
      ),
    );
  }
}
