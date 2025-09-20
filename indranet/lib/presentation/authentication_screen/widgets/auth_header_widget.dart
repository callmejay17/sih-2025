import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AuthHeaderWidget extends StatelessWidget {
  const AuthHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 4.h),

        // App Logo
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary,
            borderRadius: BorderRadius.circular(4.w),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'shield',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 10.w,
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // App Name
        Text(
          'IndraNet',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),

        SizedBox(height: 1.h),

        // Tagline
        Text(
          'Emergency Response & Disaster Management',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 4.h),
      ],
    );
  }
}
