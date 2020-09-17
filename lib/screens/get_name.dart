import 'package:flutter/material.dart';
import 'package:virusmapbr/models/session.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/themes/themes.dart';

class GetName extends StatefulWidget {
  @override
  _GetNameState createState() => _GetNameState();
}

class _GetNameState extends State<GetName> {
  TextEditingController _nameController;
  String _userName;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusPanel(),
                _buildControls(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusPanel() {
    return Container(
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 32.0,
                    width: 32.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color:
                          VirusMapBRTheme.color(context, "modal").withOpacity(0.2),
                    ),
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        color: VirusMapBRTheme.color(context, "white"),
                        icon: Icon(VirusMapBRIcons.return_icon),
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Que bom ter você aqui! 👍🏼",
                            style: Theme.of(context).textTheme.headline1.merge(
                                TextStyle(
                                    color:
                                        VirusMapBRTheme.color(context, "white"))),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            "Como podemos te chamar?",
                            style: Theme.of(context).textTheme.bodyText2.merge(
                                TextStyle(
                                    color:
                                        VirusMapBRTheme.color(context, "white"))),
                          )
                        ])
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 32.0),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -10),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [buildForm()],
            ),
          ),
        ],
      ),
    );
  }

  // Build the form for Phone/SMS authentication
  // The form will change according to the need to send the OTP code or not
  Widget buildForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            buildNameInput(),
            SizedBox(height: 32.0),
            buildFormSubmitButton()
          ],
        )
      ],
    );
  }

  // Build the phone number input field
  Widget buildNameInput() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.phone),
        labelText: "Nome ou apelido",
      ),
      onChanged: (val) {
        setState(() {
          _userName = val;
        });
      },
    );
  }

  // Build the form submit button
  Widget buildFormSubmitButton() {
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
                "Continuar",
                style: Theme.of(context).textTheme.headline3.merge(
                    TextStyle(color: VirusMapBRTheme.color(context, "white"))),
              )),
              onPressed: () async {
                Session session = Session();
                await session.resume();
                await session.updateDisplayName(_userName);
                Navigator.pushNamedAndRemoveUntil(
                    context, "welcome", (Route<dynamic> route) => false);
              },
            ),
          ),
        ],
      ),
    );
  }
}
