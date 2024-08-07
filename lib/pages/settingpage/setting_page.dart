import 'package:flutter/material.dart';
import 'package:routepayapp/pages/logout_page.dart';
import 'package:routepayapp/pages/settingpage/feedback.dart';
import 'package:routepayapp/pages/settingpage/forgotpassword.dart';
import 'package:routepayapp/pages/settingpage/usertransiction.dart';
import 'package:routepayapp/pages/settingpage/userupdata.dart';

import 'package:settings_ui/settings_ui.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Account Setting'),
            tiles: [
              SettingsTile(
                title: Text(
                  'Update User Profile',
                  style: TextStyle(
                    letterSpacing: 2,
                  ),
                ),
                // Subtitle: Text('English'),
                leading: Icon(Icons.language),
                onPressed: (BuildContext context) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyAppuserup()));
                },
              ),
              SettingsTile(
                title: Text(
                  'Transaction histroy',
                  style: TextStyle(
                    letterSpacing: 2,
                  ),
                ),
                //   subtitle: Text('Production'),
                leading: Icon(Icons.cloud_queue),
                onPressed: (BuildContext context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserTransactionHistoryPage()));
                },
              ),
              SettingsTile(
                title: Text(
                  'Forgot Password',
                  style: TextStyle(
                    letterSpacing: 2,
                  ),
                ),
                //   subtitle: Text('Production'),
                leading: Icon(Icons.cloud_queue),
                onPressed: (BuildContext context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgetPasswordScreen()));
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text(
              'Privacy Policy',
              style: TextStyle(
                letterSpacing: 2,
              ),
            ),
            tiles: [
              SettingsTile(
                title: Text(
                  'Terms of Service',
                  style: TextStyle(
                    letterSpacing: 2,
                  ),
                ),
                leading: Icon(Icons.description),
                onPressed: (BuildContext context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TermsPrivacyPolicyPage()));
                },
              ),
              SettingsTile(
                title: Text(
                  'Logout',
                  style: TextStyle(
                    letterSpacing: 2,
                  ),
                ),
                leading: Icon(Icons.exit_to_app),
                onPressed: (BuildContext context) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogoutScreen()));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
