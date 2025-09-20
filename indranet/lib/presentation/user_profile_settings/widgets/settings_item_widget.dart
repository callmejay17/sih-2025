import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsItemWidget extends StatelessWidget {
  final String iconName;
  final String title;
  final String? subtitle;
  final String? value;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showDivider;

  const SettingsItemWidget({
    super.key,
    required this.iconName,
    required this.title,
    this.subtitle,
    this.value,
    this.onTap,
    this.trailing,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: iconName,
                      color: AppTheme.lightTheme.primaryColor,
                      size: 5.w,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 0.5.h),
                        Text(
                          subtitle!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                // Value or Trailing
                if (value != null)
                  Text(
                    value!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (trailing != null) trailing!,
                if (onTap != null && trailing == null && value == null)
                  CustomIconWidget(
                    iconName: 'chevron_right',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.5,
            indent: 4.w,
            endIndent: 4.w,
            color: Theme.of(context).dividerColor,
          ),
      ],
    );
  }
}
