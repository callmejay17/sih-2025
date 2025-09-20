import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricAuthWidget extends StatelessWidget {
  final VoidCallback onBiometricAuth;
  final bool isAvailable;

  const BiometricAuthWidget({
    Key? key,
    required this.onBiometricAuth,
    required this.isAvailable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isAvailable || kIsWeb) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(height: 3.h),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'OR',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                thickness: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        GestureDetector(
          onTap: onBiometricAuth,
          child: Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(7.5.w),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: defaultTargetPlatform == TargetPlatform.iOS
                    ? 'fingerprint'
                    : 'fingerprint',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 8.w,
              ),
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          defaultTargetPlatform == TargetPlatform.iOS
              ? 'Use Face ID / Touch ID'
              : 'Use Biometric Authentication',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
