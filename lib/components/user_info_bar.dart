import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/helpers/logger.dart';
import 'package:virusmapbr/models/session.dart';
import 'package:virusmapbr/providers/session_provider.dart';
import 'package:virusmapbr/screens/edit_avatar.dart';
import 'package:virusmapbr/themes/themes.dart';

class UserInfoBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SessionProvider sessionProvider = Provider.of<SessionProvider>(context);
    Logger.red("3 : ${sessionProvider.session.displayName}");
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildUserAvatar(sessionProvider.session),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sessionProvider.session.displayName ?? "seja bem vindo!",
                    style: Theme.of(context).textTheme.headline2.merge(
                        TextStyle(color: VirusMapBRTheme.color(context, "white"))),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      Text(
                        sessionProvider.session.email ??
                            sessionProvider.session.phoneNumber,
                        style: Theme.of(context).textTheme.bodyText2.merge(
                            TextStyle(
                                color: VirusMapBRTheme.color(context, "white"))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildEditAvatarButton(context)
          ],
        ),
      ),
    );
  }

  Widget _buildEditAvatarButton(context) {
    return Container(
      height: 32.0,
      width: 32.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: VirusMapBRTheme.color(context, "white").withOpacity(0.2),
      ),
      child: Center(
        child: IconButton(
            padding: EdgeInsets.all(0),
            color: VirusMapBRTheme.color(context, "white"),
            icon: Icon(VirusMapBRIcons.camera_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditAvatar()),
              );
            }),
      ),
    );
  }

  Widget _buildUserAvatar(Session session) {
    ImageProvider image;
    String photoUrl = session.photoUrl;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      image = NetworkImage(session.photoUrl);
    } else {
      image = AssetImage("assets/unknown-user.png");
    }
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: 32,
      child: CircleAvatar(
        backgroundImage: image,
        radius: 29,
      ),
    );
  }
}
