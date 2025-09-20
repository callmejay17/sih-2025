import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final String actionText;
  final VoidCallback? onActionPressed;
  final String iconName;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    required this.message,
    required this.actionText,
    this.onActionPressed,
    this.iconName = 'volunteer_activism',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 40,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Message
            Text(
              message,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                height: 1.5,
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Action button
            if (onActionPressed != null)
              ElevatedButton(
                onPressed: onActionPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  actionText,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
