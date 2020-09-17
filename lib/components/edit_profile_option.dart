import 'package:flutter/material.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/screens/edit_profile.dart';
import 'package:virusmapbr/themes/themes.dart';

class EditProfileOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: const EdgeInsets.all(0),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditProfile()),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              VirusMapBRIcons.profile_outline,
              color: VirusMapBRTheme.color(context, "text1"),
              size: 24.0,
            ),
          ),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text("Editar dados do perfil",
                style: Theme.of(context).textTheme.subtitle1.merge(
                    TextStyle(color: VirusMapBRTheme.color(context, "text1")))),
          ),
          Container(
            child: Icon(
              VirusMapBRIcons.arrow_right,
              color: VirusMapBRTheme.color(context, "text1"),
              size: 24.0,
            ),
          )
        ],
      ),
    );
  }
}
