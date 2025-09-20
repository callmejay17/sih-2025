import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationSettingsWidget extends StatefulWidget {
  final Map<String, dynamic> notificationSettings;
  final Function(String, bool) onSettingChanged;

  const NotificationSettingsWidget({
    super.key,
    required this.notificationSettings,
    required this.onSettingChanged,
  });

  @override
  State<NotificationSettingsWidget> createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends State<NotificationSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildNotificationItem(
          'push_notifications',
          'Push Notifications',
          'Receive alerts on your device',
          'notifications',
        ),
        _buildNotificationItem(
          'disaster_alerts',
          'Disaster Alerts',
          'Critical emergency notifications',
          'warning',
        ),
        _buildNotificationItem(
          'volunteer_updates',
          'Volunteer Updates',
          'Mission and coordination updates',
          'group',
        ),
        _buildNotificationItem(
          'weather_alerts',
          'Weather Alerts',
          'Severe weather warnings',
          'cloud',
        ),
        _buildNotificationItem(
          'sms_backup',
          'SMS Backup',
          'Receive alerts via SMS when offline',
          'sms',
        ),
        _buildNotificationItem(
          'email_digest',
          'Email Digest',
          'Daily summary of activities',
          'email',
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildNotificationItem(
    String key,
    String title,
    String subtitle,
    String iconName, {
    bool showDivider = true,
  }) {
    final bool isEnabled = widget.notificationSettings[key] as bool? ?? false;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: [
              // Icon
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: isEnabled
                      ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                      : Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: iconName,
                    color: isEnabled
                        ? AppTheme.lightTheme.primaryColor
                        : Theme.of(context).colorScheme.outline,
                    size: 5.w,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Switch
              Switch(
                value: isEnabled,
                onChanged: (value) {
                  setState(() {
                    widget.onSettingChanged(key, value);
                  });
                },
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.5,
            indent: 4.w,
            endIndent: 4.w,
            color: Theme.of(context).dividerColor,
          ),
      ],
    );
  }
}
