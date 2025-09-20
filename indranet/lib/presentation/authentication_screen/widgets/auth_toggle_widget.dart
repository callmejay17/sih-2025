import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AuthToggleWidget extends StatelessWidget {
  final bool isLoginMode;
  final Function(bool) onToggle;

  const AuthToggleWidget({
    Key? key,
    required this.isLoginMode,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.h),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isLoginMode
                      ? AppTheme.lightTheme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(3.h),
                  boxShadow: isLoginMode
                      ? [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Login',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: isLoginMode
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: !isLoginMode
                      ? AppTheme.lightTheme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(3.h),
                  boxShadow: !isLoginMode
                      ? [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Register',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: !isLoginMode
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
