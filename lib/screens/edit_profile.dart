import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/providers/session_provider.dart';
import 'package:virusmapbr/themes/themes.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  SessionProvider _sessionProvider;
  String _displayName;
  TextEditingController _displayNameController;

  @override
  void initState() {
    super.initState();
    _sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    _displayNameController =
        TextEditingController(text: _sessionProvider.session.displayName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VirusMapBRTheme.color(context, "surface"),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildStatusPanel(),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPanel() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildBackButton(),
            _buildDisplayNameEditor(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Row(
      children: [
        Container(
          height: 32.0,
          width: 32.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: VirusMapBRTheme.color(context, "modal").withOpacity(0.2),
          ),
          child: Center(
            child: IconButton(
              padding: EdgeInsets.all(0),
              color: VirusMapBRTheme.color(context, "white"),
              icon: Icon(VirusMapBRIcons.return_icon),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        )
      ],
    );
  }

  Expanded _buildDisplayNameEditor() {
    return Expanded(
      child: Center(
          child: TextField(
        controller: _displayNameController,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.face),
          labelText: "Nome ou apelido",
        ),
        onChanged: (val) {
          _displayName = val;
        },
      )),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 32.0),
      decoration: BoxDecoration(
        color: VirusMapBRTheme.color(context, "modal"),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildConfirmButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      height: 56.0,
      child: Row(
        children: [
          Expanded(
            child: RaisedButton(
              elevation: 8.0,
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Center(
                  child: Text(
                "Confirmar",
                style: Theme.of(context).textTheme.headline3.merge(
                    TextStyle(color: VirusMapBRTheme.color(context, "white"))),
              )),
              onPressed: _changeDisplayName,
            ),
          ),
        ],
      ),
    );
  }

  void _changeDisplayName() async {
    await _sessionProvider.updateDisplayName(_displayName);
    Navigator.pop(context);
  }
}
