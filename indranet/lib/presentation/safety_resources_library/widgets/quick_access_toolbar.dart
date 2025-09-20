import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickAccessToolbar extends StatelessWidget {
  final VoidCallback onEmergencyContactsTap;
  final VoidCallback onLocationShareTap;
  final VoidCallback onSavedResourcesTap;

  const QuickAccessToolbar({
    Key? key,
    required this.onEmergencyContactsTap,
    required this.onLocationShareTap,
    required this.onSavedResourcesTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickAccessButton(
            iconName: 'phone',
            label: 'Emergency\nContacts',
            color: AppTheme.alertLight,
            onTap: onEmergencyContactsTap,
          ),
          Container(
            width: 1,
            height: 8.h,
            color: AppTheme.dividerLight,
          ),
          _buildQuickAccessButton(
            iconName: 'location_on',
            label: 'Share\nLocation',
            color: AppTheme.primaryLight,
            onTap: onLocationShareTap,
          ),
          Container(
            width: 1,
            height: 8.h,
            color: AppTheme.dividerLight,
          ),
          _buildQuickAccessButton(
            iconName: 'bookmark',
            label: 'Saved\nResources',
            color: AppTheme.secondaryLight,
            onTap: onSavedResourcesTap,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessButton({
    required String iconName,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: color,
                  size: 6.w,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.textSecondaryLight,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
