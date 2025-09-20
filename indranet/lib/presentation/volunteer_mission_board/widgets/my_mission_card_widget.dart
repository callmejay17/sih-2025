import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MyMissionCardWidget extends StatelessWidget {
  final Map<String, dynamic> mission;
  final VoidCallback onTap;
  final VoidCallback onUpdate;
  final VoidCallback onCommunicate;

  const MyMissionCardWidget({
    Key? key,
    required this.mission,
    required this.onTap,
    required this.onUpdate,
    required this.onCommunicate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = mission['status'] as String? ?? 'pending';
    final missionType = mission['type'] as String? ?? 'rescue';
    final location = mission['location'] as String? ?? 'Unknown Location';
    final joinedDate = mission['joinedDate'] as String? ?? 'Today';
    final description = mission['description'] as String? ?? '';
    final coordinator = mission['coordinator'] as String? ?? 'Unknown';

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showContextMenu(context),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getStatusColor(status).withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status and mission type
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: _getStatusColor(status).withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  // Status indicator
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: _getStatusIcon(status),
                          color: Colors.white,
                          size: 12,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          _getStatusLabel(status),
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 2.w),
                  // Mission type icon
                  CustomIconWidget(
                    iconName: _getMissionTypeIcon(missionType),
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      _getMissionTypeLabel(missionType),
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location and joined date
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'location_on',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          location,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'Joined: $joinedDate',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Description
                  Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12.sp,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 2.h),

                  // Coordinator info
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'person',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Coordinator: $coordinator',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onUpdate,
                          icon: CustomIconWidget(
                            iconName: 'update',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                          label: Text(
                            'Update',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onCommunicate,
                          icon: CustomIconWidget(
                            iconName: 'chat',
                            color: Colors.white,
                            size: 16,
                          ),
                          label: Text(
                            'Communicate',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: Colors.white,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.primary,
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'pending':
        return const Color(0xFFFF9800);
      case 'completed':
        return AppTheme.lightTheme.colorScheme.primary;
      default:
        return Colors.grey;
    }
  }

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'play_arrow';
      case 'pending':
        return 'schedule';
      case 'completed':
        return 'check_circle';
      default:
        return 'help';
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'ACTIVE';
      case 'pending':
        return 'PENDING';
      case 'completed':
        return 'COMPLETED';
      default:
        return 'UNKNOWN';
    }
  }

  String _getMissionTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'rescue':
        return 'emergency';
      case 'medical':
        return 'medical_services';
      case 'supply':
        return 'local_shipping';
      case 'evacuation':
        return 'directions_run';
      case 'search':
        return 'search';
      case 'relief':
        return 'volunteer_activism';
      default:
        return 'help';
    }
  }

  String _getMissionTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'rescue':
        return 'Rescue Operation';
      case 'medical':
        return 'Medical Aid';
      case 'supply':
        return 'Supply Distribution';
      case 'evacuation':
        return 'Evacuation Support';
      case 'search':
        return 'Search Operation';
      case 'relief':
        return 'Relief Work';
      default:
        return 'General Mission';
    }
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Share Mission'),
              onTap: () {
                Navigator.pop(context);
                // Handle share
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'exit_to_app',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: Text('Leave Mission'),
              onTap: () {
                Navigator.pop(context);
                _showLeaveMissionDialog(context);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showLeaveMissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Leave Mission'),
        content: Text(
            'Are you sure you want to leave this mission? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle leave mission
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Leave', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
