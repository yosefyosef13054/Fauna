import 'package:fauna/supportingClass/sidebar/circular_image.dart';
import 'package:fauna/supportingClass/sidebar/zoom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  final String imageUrl =
      "https://celebritypets.net/wp-content/uploads/2016/12/Adriana-Lima.jpg";

  final List<MenuItem> options = [
    MenuItem("assets/explore.webp", 'Explore'),
    MenuItem("assets/.webp", 'Profile'),
    MenuItem("assets/sidebar/promo.webp", 'Promocodes'),
    MenuItem("assets/sidebar/invite.webp", 'Invite Friends'),
    MenuItem("assets/chats.webp", 'Chat History'),
    MenuItem("assets/sidebar/fav.webp", 'Favorites'),
    MenuItem("assets/sidebar/paymnt.webp", 'Payment Method'),
    MenuItem("assets/sidebar/share.webp", 'Share & Earn'),
    MenuItem("assets/sidebar/Disputes.webp", 'Disputes'),
    MenuItem("assets/sidebar/subscription.webp", 'Subscription'),
    MenuItem("assets/sidebar/support.webp", 'Support'),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanUpdate: (details) {
          //on swiping left
          if (details.delta.dx < -6) {
            Provider.of<MenuController>(context, listen: true).toggle();
          }
        },
        child: Container(
          padding: EdgeInsets.only(
              top: 62,
              left: 32,
              bottom: 20,
              right: MediaQuery.of(context).size.width / 2.9),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xFF9C27B0), Color(0xFFFF3D00)],
            ),
          ),
          child: SingleChildScrollView(
            child: ListView(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: CircularImage(
                        NetworkImage(imageUrl),
                      ),
                    ),
                    Text(
                      'Tatiana',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
                Column(
                  children: options.map((item) {
                    return ListTile(
                      leading: Image.asset(
                        item.icon,
                        width: 20,
                        height: 20,
                        color: Colors.white,
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
                ListTile(
                  onTap: () {},
                  leading: Image.asset(
                    "assets/sidebar/settings.webp",
                    width: 20,
                    height: 20,
                    color: Colors.white,
                  ),
                  title: Text('Settings',
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                ),
                VerticalDivider(),
                ListTile(
                  onTap: () {},
                  leading: Icon(
                    Icons.headset_mic,
                    color: Colors.white,
                    size: 20,
                  ),
                  title: Text('Logout',
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                )
              ],
            ),
          ),
        ));
  }
}

class MenuItem {
  String title;
  String icon;

  MenuItem(this.icon, this.title);
}
