import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MissionCardWidget extends StatelessWidget {
  final Map<String, dynamic> mission;
  final VoidCallback onJoinMission;
  final VoidCallback onTap;

  const MissionCardWidget({
    Key? key,
    required this.mission,
    required this.onJoinMission,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final priority = mission['priority'] as String? ?? 'normal';
    final missionType = mission['type'] as String? ?? 'rescue';
    final location = mission['location'] as String? ?? 'Unknown Location';
    final distance = mission['distance'] as String? ?? '0 km';
    final requiredSkills =
        (mission['requiredSkills'] as List?)?.cast<String>() ?? [];
    final volunteersNeeded = mission['volunteersNeeded'] as int? ?? 0;
    final description = mission['description'] as String? ?? '';
    final estimatedTime = mission['estimatedTime'] as String? ?? '2-4 hours';
    final isUrgent = priority.toLowerCase() == 'urgent';

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showContextMenu(context),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: isUrgent
              ? Border.all(
                  color: AppTheme.lightTheme.colorScheme.error, width: 2)
              : null,
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
            // Header with priority indicator and mission type
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: isUrgent
                    ? AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  // Priority indicator
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(priority),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      priority.toUpperCase(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                      ),
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
                  // Location and distance
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
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          distance,
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 10.sp,
                          ),
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

                  // Required skills
                  if (requiredSkills.isNotEmpty) ...[
                    Text(
                      'Required Skills:',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 1.w,
                      runSpacing: 0.5.h,
                      children: requiredSkills
                          .take(3)
                          .map((skill) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppTheme
                                        .lightTheme.colorScheme.primary
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  skill,
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 2.h),
                  ],

                  // Bottom row with volunteers needed, time, and join button
                  Row(
                    children: [
                      // Volunteers needed
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'people',
                            color: AppTheme.lightTheme.colorScheme.secondary,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '$volunteersNeeded needed',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 4.w),

                      // Estimated time
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: AppTheme.lightTheme.colorScheme.secondary,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            estimatedTime,
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Join button
                      ElevatedButton(
                        onPressed: onJoinMission,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isUrgent
                              ? AppTheme.lightTheme.colorScheme.error
                              : AppTheme.lightTheme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Join Mission',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 11.sp,
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

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return AppTheme.lightTheme.colorScheme.error;
      case 'high':
        return const Color(0xFFFF9800);
      case 'normal':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'low':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
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
                iconName: 'bookmark',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Save Mission'),
              onTap: () {
                Navigator.pop(context);
                // Handle save
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: Text('Report Issue'),
              onTap: () {
                Navigator.pop(context);
                // Handle report
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
