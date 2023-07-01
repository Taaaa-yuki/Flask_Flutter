import 'package:flutter/material.dart';
import 'package:lyrics_app/app/constants/color.dart';

class LyricsDrawer extends StatelessWidget {
  const LyricsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: const BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(height: 50),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/300?img=5'),
                ),
                SizedBox(height: 10),
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Favorite Albums'),
                  leading: const Icon(Icons.favorite),
                  onTap: () {
                    Navigator.pushNamed(context, '/favorite');
                  },
                ),
                ListTile(
                  title: const Text('Account'),
                  leading: const Icon(Icons.account_circle),
                  onTap: () {
                    Navigator.pushNamed(context, '/account');
                  },
                ),
                ListTile(
                  title: const Text('Logout'),
                  leading: const Icon(Icons.logout),
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
                ListTile(
                  title: const Text('About'),
                  leading: const Icon(Icons.info),
                  onTap: () {
                    Navigator.pushNamed(context, '/about');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
