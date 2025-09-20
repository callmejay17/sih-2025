import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AlertCard extends StatelessWidget {
  final Map<String, dynamic> alert;
  final VoidCallback onTap;
  final Function(String) onSwipeAction;

  const AlertCard({
    Key? key,
    required this.alert,
    required this.onTap,
    required this.onSwipeAction,
  }) : super(key: key);

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'severe':
        return AppTheme.lightTheme.colorScheme.error;
      case 'moderate':
        return Colors.orange;
      case 'local':
        return AppTheme.lightTheme.colorScheme.primary;
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  IconData _getDisasterIcon(String type) {
    switch (type.toLowerCase()) {
      case 'earthquake':
        return Icons.terrain;
      case 'flood':
        return Icons.water;
      case 'cyclone':
        return Icons.cyclone;
      case 'fire':
        return Icons.local_fire_department;
      case 'landslide':
        return Icons.landscape;
      default:
        return Icons.warning;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = alert['isUnread'] as bool? ?? false;
    final severity = alert['severity'] as String? ?? 'moderate';
    final disasterType = alert['type'] as String? ?? 'warning';
    final headline = alert['headline'] as String? ?? 'Alert';
    final location = alert['location'] as String? ?? 'Unknown Location';
    final timestamp = alert['timestamp'] as DateTime? ?? DateTime.now();
    final description = alert['description'] as String? ?? '';

    return Dismissible(
      key: Key(alert['id'].toString()),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 6.w),
        color: AppTheme.lightTheme.colorScheme.secondary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'check',
              color: AppTheme.lightTheme.colorScheme.onSecondary,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Mark as Read',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSecondary,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 6.w),
        color: AppTheme.lightTheme.colorScheme.tertiary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.onTertiary,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Share',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onTertiary,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onSwipeAction('mark_read');
        } else {
          onSwipeAction('share');
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        elevation: isUnread ? 4.0 : 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(
            color: _getSeverityColor(severity),
            width: isUnread ? 3.0 : 1.0,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color:
                            _getSeverityColor(severity).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: CustomIconWidget(
                        iconName:
                            _getDisasterIcon(disasterType).codePoint.toString(),
                        color: _getSeverityColor(severity),
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (isUnread)
                                Container(
                                  width: 2.w,
                                  height: 2.w,
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  margin: EdgeInsets.only(right: 2.w),
                                ),
                              Expanded(
                                child: Text(
                                  headline,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: isUnread
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'location_on',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 16,
                              ),
                              SizedBox(width: 1.w),
                              Expanded(
                                child: Text(
                                  location,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                _formatTimestamp(timestamp),
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (description.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color:
                            _getSeverityColor(severity).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        severity.toUpperCase(),
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: _getSeverityColor(severity),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onTap,
                      child: Text(
                        'Read More',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
