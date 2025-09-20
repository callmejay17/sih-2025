import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageWidget(
              imageUrl:
                  'https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
              width: 60.w,
              height: 30.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 4.h),
            Text(
              'No Current Alerts',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'No current alerts in your area. We\'ll notify you immediately when any emergency situations arise.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: () {
                // Refresh action
              },
              icon: CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 20,
              ),
              label: Text(
                'Refresh Alerts',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
