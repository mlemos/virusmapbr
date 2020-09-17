import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/models/session.dart';
import 'package:virusmapbr/providers/session_provider.dart';
import 'package:virusmapbr/themes/themes.dart';

class UserInfoBarDash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SessionProvider _sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    return Container(
      //height: 64.0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildUserAvatar(_sessionProvider.session),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Olá, ${_sessionProvider.session.displayName ?? "seja bem vindo!"}",
                    style: Theme.of(context).textTheme.headline3.merge(
                        TextStyle(color: VirusMapBRTheme.color(context, "white"))),
                  ),
                  // SizedBox(
                  //   height: 2,
                  // ),
                  // Row(
                  //   children: [
                  //     _buildStatusDot(context, "error"),
                  //     SizedBox(width: 4.0),
                  //     Text(
                  //       " Você está em uma área critica.",
                  //       style: Theme.of(context).textTheme.caption.merge(
                  //           TextStyle(
                  //               color: VirusMapBRTheme.color(context, "white"))),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            _buildShareButton(context),
          ],
        ),
      ),
    );
  }

  
  Widget _buildShareButton(BuildContext context) {
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
          icon: Icon(VirusMapBRIcons.share),
          onPressed: () {
            Share.share(
                "Vamos juntos acabar com o Coronavírus. Estou usando este app para monitorar o vírus. Baixe você também: http://github.com/mlemos/virusmapbr");
          },
        ),
      ),
    );
  }

  // Builds the user avatar.
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
      radius: 24,
      child: CircleAvatar(
        backgroundImage: image,
        radius: 22,
      ),
    );
  }

  // Builds the InfoBar status dot.
  // Widget _buildStatusDot(BuildContext context, String key) {
  //   return Container(
  //     height: 6.0,
  //     width: 6.0,
  //     decoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         color: VirusMapBRTheme.color(context, key),
  //         boxShadow: [
  //           BoxShadow(
  //             color: VirusMapBRTheme.color(context, key),
  //             offset: Offset(0, 2.0),
  //             blurRadius: 6,
  //             spreadRadius: 0,
  //           )
  //         ]),
  //   );
  // }

}