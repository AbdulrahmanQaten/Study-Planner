// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, library_private_types_in_public_api
// screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: themeProvider.isDarkMode
            ? Theme.of(context).appBarTheme.backgroundColor
            : Color(0xFF1A237E),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Language"),
            subtitle: Text("Select your preferred language"),
            leading: Icon(Icons.language),
            onTap: () {
              // Show language selection dialog
            },
          ),
          Divider(),
          ListTile(
            title: Text("Theme"),
            subtitle: Text("Dark mode / Light mode"),
            leading: Icon(Icons.brightness_6),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              activeColor: Colors.indigo, // لون الزر عند التفعيل
              activeTrackColor: Colors.indigoAccent, // لون المسار عند التفعيل
              inactiveThumbColor: Colors.grey, // لون الزر عند الإلغاء
              inactiveTrackColor: Colors.grey[400], // لون المسار عند الإلغاء
            ),
          ),
          Divider(),
          ListTile(
            title: Text("Notifications"),
            subtitle: Text("Manage notification settings"),
            leading: Icon(Icons.notifications),
            onTap: () {
              // Navigate to notification settings
            },
          ),
          Divider(),
          ListTile(
            title: Text("Account"),
            subtitle: Text("Manage your account"),
            leading: Icon(Icons.account_circle),
            onTap: () {
              // Navigate to account management
            },
          ),
          Divider(),
          ListTile(
            title: Text("Data Backup"),
            subtitle: Text("Backup & Restore your tasks"),
            leading: Icon(Icons.backup),
            onTap: () {
              // Navigate to backup settings
            },
          ),
          Divider(),
          ListTile(
            title: Text("About App"),
            subtitle: Text("Version, Privacy Policy, etc."),
            leading: Icon(Icons.info_outline),
            onTap: () {
              // Show about app dialog or navigate to about screen
            },
          ),
          Divider(),
          ListTile(
            title: Text("Reset Settings"),
            subtitle: Text("Restore default settings"),
            leading: Icon(Icons.restore),
            onTap: () {
              // Confirm and reset settings
            },
          ),
        ],
      ),
    );
  }
}
