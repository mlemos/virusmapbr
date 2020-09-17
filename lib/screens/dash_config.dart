import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virusmapbr/components/debug_option.dart';
import 'package:virusmapbr/components/desviralize_option.dart';
import 'package:virusmapbr/components/edit_profile_option.dart';
import 'package:virusmapbr/components/location_option.dart';
import 'package:virusmapbr/components/logout_option.dart';
import 'package:virusmapbr/components/share_toast.dart';
import 'package:virusmapbr/components/user_info_bar.dart';
import 'package:virusmapbr/components/version_tag.dart';
import 'package:virusmapbr/providers/navigation_provider.dart';
import 'package:virusmapbr/providers/session_provider.dart';
import 'package:virusmapbr/themes/themes.dart';

class DashConfig extends StatefulWidget {
  @override
  _DashConfigState createState() => _DashConfigState();
}

class _DashConfigState extends State<DashConfig> {
  SessionProvider _sessionProvider;
  NavigationProvider _navigationProvider;

  @override
  Widget build(BuildContext context) {
    _sessionProvider = Provider.of<SessionProvider>(context);
    _navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: VirusMapBRTheme.color(context, "surface"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          UserInfoBar(),
          _buildBottomSheet(context),
        ],
      ),
    );
  }

  Widget _buildBottomSheet(context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
          color: Theme.of(context).backgroundColor,
          boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 10)],
        ),
        padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildConfigOptions(context),
            SizedBox(height: 16.0),
            ShareToast(),
            SizedBox(height: 16.0),
            buildBottomOptions(context),
          ],
        ),
      ),
    );
  }

  Widget buildConfigOptions(context) {
    return Expanded(
      child: ListView(
        children: [
          EditProfileOption(),
          _buildDivider(context),
          LocationOption(),
          _buildDivider(context),
          DesviralizeOption(),
          _buildDivider(context),
          if (!kReleaseMode) DebugOption(),
        ],
      ),
    );
  }

  Widget buildBottomOptions(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: LogoutOption(
            _sessionProvider.session,
            onConfirmed: () {
              _navigationProvider.reset();
              Navigator.pushNamedAndRemoveUntil(
                  context, "onboarding", (Route<dynamic> route) => false);
            },
          ),
        ),
        SizedBox(
          width: 32.0,
        ),
        VersionTag(),
      ],
    );
  }

  Widget _buildDivider(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        color: VirusMapBRTheme.color(context, "text3"),
      ),
    );
  }
}
