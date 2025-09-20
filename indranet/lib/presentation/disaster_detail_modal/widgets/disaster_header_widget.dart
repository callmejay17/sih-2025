import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DisasterHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> disasterData;

  const DisasterHeaderWidget({
    Key? key,
    required this.disasterData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildDisasterIcon(),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      disasterData['type'] ?? 'Unknown Disaster',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    _buildSeverityBadge(),
                  ],
                ),
              ),
              _buildTimestamp(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisasterIcon() {
    String iconName = 'warning';
    Color iconColor = AppTheme.lightTheme.colorScheme.error;

    switch (disasterData['type']?.toLowerCase()) {
      case 'earthquake':
        iconName = 'vibration';
        iconColor = AppTheme.lightTheme.colorScheme.error;
        break;
      case 'flood':
        iconName = 'water_drop';
        iconColor = Colors.blue;
        break;
      case 'cyclone':
        iconName = 'cyclone';
        iconColor = Colors.purple;
        break;
      case 'fire':
        iconName = 'local_fire_department';
        iconColor = Colors.orange;
        break;
      case 'landslide':
        iconName = 'landscape';
        iconColor = Colors.brown;
        break;
      default:
        iconName = 'warning';
        iconColor = AppTheme.lightTheme.colorScheme.error;
    }

    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomIconWidget(
        iconName: iconName,
        color: iconColor,
        size: 8.w,
      ),
    );
  }

  Widget _buildSeverityBadge() {
    String severity = disasterData['severity'] ?? 'Unknown';
    Color badgeColor = _getSeverityColor(severity);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor, width: 1),
      ),
      child: Text(
        severity.toUpperCase(),
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.w600,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  Widget _buildTimestamp() {
    String timestamp = _formatTimestamp(disasterData['timestamp']);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          timestamp,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontSize: 10.sp,
          ),
        ),
        SizedBox(height: 0.5.h),
        CustomIconWidget(
          iconName: 'access_time',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 4.w,
        ),
      ],
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return AppTheme.lightTheme.colorScheme.error;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.amber;
      case 'low':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Unknown time';

    DateTime eventTime;
    if (timestamp is DateTime) {
      eventTime = timestamp;
    } else if (timestamp is String) {
      try {
        eventTime = DateTime.parse(timestamp);
      } catch (e) {
        return 'Unknown time';
      }
    } else {
      return 'Unknown time';
    }

    final now = DateTime.now();
    final difference = now.difference(eventTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${eventTime.day}/${eventTime.month}/${eventTime.year}';
    }
  }
}
