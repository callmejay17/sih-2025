import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/emergency_contacts_widget.dart';
import './widgets/notification_settings_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';

class UserProfileSettings extends StatefulWidget {
  const UserProfileSettings({super.key});

  @override
  State<UserProfileSettings> createState() => _UserProfileSettingsState();
}

class _UserProfileSettingsState extends State<UserProfileSettings>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isDarkMode = false;
  String _selectedLanguage = 'English';

  // Mock user data
  final Map<String, dynamic> _userData = {
    "id": 1,
    "name": "Priya Sharma",
    "email": "priya.sharma@email.com",
    "phone": "+91 98765 43210",
    "avatar":
        "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
    "location": "Mumbai, Maharashtra",
    "isVolunteer": true,
    "volunteerSince": "2023-01-15",
    "skills": ["First Aid", "Rescue Operations", "Communication"],
    "address": "Bandra West, Mumbai, Maharashtra 400050",
    "serviceRadius": 10,
    "emergencyContactsCount": 3,
  };

  // Mock notification settings
  Map<String, dynamic> _notificationSettings = {
    "push_notifications": true,
    "disaster_alerts": true,
    "volunteer_updates": true,
    "weather_alerts": false,
    "sms_backup": true,
    "email_digest": false,
  };

  // Mock emergency contacts
  final List<Map<String, dynamic>> _emergencyContacts = [
    {
      "id": 1,
      "name": "Rajesh Sharma",
      "phone": "+91 98765 43211",
      "relationship": "Father",
    },
    {
      "id": 2,
      "name": "Meera Sharma",
      "phone": "+91 98765 43212",
      "relationship": "Mother",
    },
    {
      "id": 3,
      "name": "Dr. Amit Kumar",
      "phone": "+91 98765 43213",
      "relationship": "Family Doctor",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onNotificationSettingChanged(String key, bool value) {
    setState(() {
      _notificationSettings[key] = value;
    });
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Language',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),
            ...['English', 'हिंदी (Hindi)'].map((language) {
              final bool isSelected = _selectedLanguage == language;
              return ListTile(
                title: Text(language),
                trailing: isSelected
                    ? CustomIconWidget(
                        iconName: 'check',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 5.w,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    _selectedLanguage = language;
                  });
                  Navigator.pop(context);
                  _showRestartDialog();
                },
              );
            }).toList(),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showRestartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Language Changed'),
        content: Text(
            'The app needs to restart to apply the new language settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // In a real app, this would restart the app
            },
            child: Text('Restart Now'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // In a real app, this would handle account deletion
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // In a real app, this would handle logout
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: CustomIconWidget(
                iconName: 'person',
                size: 5.w,
              ),
              text: 'Profile',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'settings',
                size: 5.w,
              ),
              text: 'Settings',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProfileTab(),
          _buildSettingsTab(),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Profile Header
          ProfileHeaderWidget(
            userData: _userData,
            onEditProfile: () {
              // Navigate to edit profile screen
            },
          ),
          SizedBox(height: 3.h),

          // Account Information Section
          SettingsSectionWidget(
            title: 'Account Information',
            children: [
              SettingsItemWidget(
                iconName: 'email',
                title: 'Email Address',
                subtitle: _userData['email'] as String,
                onTap: () {
                  // Navigate to email change screen
                },
              ),
              SettingsItemWidget(
                iconName: 'phone',
                title: 'Phone Number',
                subtitle: _userData['phone'] as String,
                onTap: () {
                  // Navigate to phone verification screen
                },
              ),
              SettingsItemWidget(
                iconName: 'lock',
                title: 'Change Password',
                subtitle: 'Update your password',
                onTap: () {
                  // Navigate to password change screen
                },
                showDivider: false,
              ),
            ],
          ),

          // Volunteer Information Section
          if (_userData['isVolunteer'] == true)
            SettingsSectionWidget(
              title: 'Volunteer Information',
              children: [
                SettingsItemWidget(
                  iconName: 'verified',
                  title: 'Volunteer Status',
                  subtitle: 'Active since ${_userData['volunteerSince']}',
                ),
                SettingsItemWidget(
                  iconName: 'build',
                  title: 'Skills & Certifications',
                  subtitle:
                      '${(_userData['skills'] as List).length} skills registered',
                  onTap: () {
                    // Navigate to skills management screen
                  },
                  showDivider: false,
                ),
              ],
            ),

          // Emergency Contacts Section
          SettingsSectionWidget(
            title: 'Emergency Contacts',
            children: [
              EmergencyContactsWidget(
                emergencyContacts: _emergencyContacts,
                onAddContact: () {
                  // Navigate to add contact screen
                },
                onEditContact: (index) {
                  // Navigate to edit contact screen
                },
                onDeleteContact: (index) {
                  setState(() {
                    _emergencyContacts.removeAt(index);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Notification Settings Section
          SettingsSectionWidget(
            title: 'Notification Settings',
            children: [
              NotificationSettingsWidget(
                notificationSettings: _notificationSettings,
                onSettingChanged: _onNotificationSettingChanged,
              ),
            ],
          ),

          // Location Settings Section
          SettingsSectionWidget(
            title: 'Location Settings',
            children: [
              SettingsItemWidget(
                iconName: 'location_on',
                title: 'Current Address',
                subtitle: _userData['address'] as String,
                onTap: () {
                  // Navigate to address update screen
                },
              ),
              SettingsItemWidget(
                iconName: 'my_location',
                title: 'Service Radius',
                subtitle: '${_userData['serviceRadius']} km radius',
                onTap: () {
                  // Navigate to radius setting screen
                },
              ),
              SettingsItemWidget(
                iconName: 'privacy_tip',
                title: 'Location Privacy',
                subtitle: 'Manage location sharing preferences',
                onTap: () {
                  // Navigate to privacy settings screen
                },
                showDivider: false,
              ),
            ],
          ),

          // App Preferences Section
          SettingsSectionWidget(
            title: 'App Preferences',
            children: [
              SettingsItemWidget(
                iconName: 'language',
                title: 'Language',
                value: _selectedLanguage,
                onTap: _showLanguageSelector,
              ),
              SettingsItemWidget(
                iconName: 'dark_mode',
                title: 'Dark Mode',
                subtitle: 'Switch between light and dark theme',
                trailing: Switch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                  },
                ),
              ),
              SettingsItemWidget(
                iconName: 'storage',
                title: 'Offline Storage',
                subtitle: 'Manage cached data and offline content',
                onTap: () {
                  // Navigate to storage management screen
                },
                showDivider: false,
              ),
            ],
          ),

          // Support & Legal Section
          SettingsSectionWidget(
            title: 'Support & Legal',
            children: [
              SettingsItemWidget(
                iconName: 'help',
                title: 'Help & Support',
                subtitle: 'Get help and contact support',
                onTap: () {
                  // Navigate to help screen
                },
              ),
              SettingsItemWidget(
                iconName: 'privacy_tip',
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                onTap: () {
                  // Navigate to privacy policy screen
                },
              ),
              SettingsItemWidget(
                iconName: 'description',
                title: 'Terms of Service',
                subtitle: 'Read terms and conditions',
                onTap: () {
                  // Navigate to terms screen
                },
              ),
              SettingsItemWidget(
                iconName: 'info',
                title: 'About IndraNet',
                subtitle: 'Version 1.0.0',
                onTap: () {
                  // Show about dialog
                },
                showDivider: false,
              ),
            ],
          ),

          // Account Actions Section
          SettingsSectionWidget(
            title: 'Account Actions',
            children: [
              SettingsItemWidget(
                iconName: 'logout',
                title: 'Logout',
                subtitle: 'Sign out of your account',
                onTap: _showLogoutDialog,
              ),
              SettingsItemWidget(
                iconName: 'delete_forever',
                title: 'Delete Account',
                subtitle: 'Permanently delete your account',
                onTap: _showDeleteAccountDialog,
                showDivider: false,
              ),
            ],
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
