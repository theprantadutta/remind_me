import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/colors.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _soundEnabled = prefs.getBool('soundEnabled') ?? true;
      _vibrationEnabled = prefs.getBool('vibrationEnabled') ?? true;
      _selectedLanguage = prefs.getString('language') ?? 'English';
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  void _toggleTheme(bool value) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    if (value) {
      themeProvider.setTheme(true);
    } else {
      themeProvider.setTheme(false);
    }
  }

  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    _saveSetting('notificationsEnabled', value);
  }

  void _toggleSound(bool value) {
    setState(() {
      _soundEnabled = value;
    });
    _saveSetting('soundEnabled', value);
  }

  void _toggleVibration(bool value) {
    setState(() {
      _vibrationEnabled = value;
    });
    _saveSetting('vibrationEnabled', value);
  }

  void _changeLanguage(String? value) {
    if (value != null) {
      setState(() {
        _selectedLanguage = value;
      });
      _saveSetting('language', value);
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkTheme = themeProvider.isDarkMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkTheme ? kDarkBackgroundGradient : kBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: isDarkTheme ? Colors.white : kTextPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme ? Colors.white : kTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              // Settings List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildSectionTitle('Appearance', isDarkTheme),
                    _buildSettingCard(
                      isDarkTheme,
                      icon: Icons.dark_mode,
                      title: 'Dark Mode',
                      subtitle: 'Toggle between light and dark theme',
                      trailing: Switch(
                        value: themeProvider.isDarkMode,
                        onChanged: _toggleTheme,
                        activeThumbColor: kPrimaryColor,
                      ),
                    ),
                    _buildSectionTitle('Notifications', isDarkTheme),
                    _buildSettingCard(
                      isDarkTheme,
                      icon: Icons.notifications,
                      title: 'Push Notifications',
                      subtitle: 'Receive reminders and alerts',
                      trailing: Switch(
                        value: _notificationsEnabled,
                        onChanged: _toggleNotifications,
                        activeThumbColor: kPrimaryColor,
                      ),
                    ),
                    _buildSettingCard(
                      isDarkTheme,
                      icon: Icons.volume_up,
                      title: 'Sound',
                      subtitle: 'Play sound for notifications',
                      trailing: Switch(
                        value: _soundEnabled,
                        onChanged: _toggleSound,
                        activeThumbColor: kPrimaryColor,
                      ),
                    ),
                    _buildSettingCard(
                      isDarkTheme,
                      icon: Icons.vibration,
                      title: 'Vibration',
                      subtitle: 'Vibrate for notifications',
                      trailing: Switch(
                        value: _vibrationEnabled,
                        onChanged: _toggleVibration,
                        activeThumbColor: kPrimaryColor,
                      ),
                    ),
                    _buildSectionTitle('General', isDarkTheme),
                    _buildSettingCard(
                      isDarkTheme,
                      icon: Icons.language,
                      title: 'Language',
                      subtitle: 'Select your preferred language',
                      trailing: DropdownButton<String>(
                        value: _selectedLanguage,
                        dropdownColor:
                            isDarkTheme ? Colors.grey[800] : Colors.white,
                        style: TextStyle(
                          color: isDarkTheme ? Colors.white : kTextPrimary,
                        ),
                        underline: Container(),
                        items: ['English', 'Spanish', 'French', 'German']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: _changeLanguage,
                      ),
                    ),
                    _buildSectionTitle('About', isDarkTheme),
                    _buildSettingCard(
                      isDarkTheme,
                      icon: Icons.info,
                      title: 'App Version',
                      subtitle: 'Version 1.0.0',
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Show version info dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Remind Me'),
                            content: const Text(
                                'Version 1.0.0\n\nA simple and elegant reminder app to help you stay organized.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    _buildSectionTitle('Legal', isDarkTheme),
                    _buildSettingCard(
                      isDarkTheme,
                      icon: Icons.privacy_tip,
                      title: 'Privacy Policy',
                      subtitle: 'Learn how we protect your data',
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _launchUrl('https://example.com/privacy'),
                    ),
                    _buildSettingCard(
                      isDarkTheme,
                      icon: Icons.description,
                      title: 'Terms & Conditions',
                      subtitle: 'Read our terms of service',
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _launchUrl('https://example.com/terms'),
                    ),
                    _buildSettingCard(
                      isDarkTheme,
                      icon: Icons.contact_support,
                      title: 'Contact Us',
                      subtitle: 'Get help or send feedback',
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _launchUrl('mailto:support@remindme.com'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDarkTheme ? Colors.white : kTextPrimary,
        ),
      ),
    );
  }

  Widget _buildSettingCard(
    bool isDarkTheme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: isDarkTheme ? kDarkCardGradient : kCardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: kShadowColor,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kPrimaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: kPrimaryColor,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDarkTheme ? Colors.white : kTextPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: isDarkTheme ? Colors.white70 : kTextSecondary,
          ),
        ),
        trailing: trailing,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
