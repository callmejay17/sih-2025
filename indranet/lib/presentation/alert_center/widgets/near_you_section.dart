import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './alert_card.dart';

class NearYouSection extends StatelessWidget {
  final List<Map<String, dynamic>> nearbyAlerts;
  final Function(Map<String, dynamic>) onAlertTap;
  final Function(String, Map<String, dynamic>) onSwipeAction;

  const NearYouSection({
    Key? key,
    required this.nearbyAlerts,
    required this.onAlertTap,
    required this.onSwipeAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (nearbyAlerts.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Near You',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  '${nearbyAlerts.length}',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: nearbyAlerts.length,
          itemBuilder: (context, index) {
            final alert = nearbyAlerts[index];
            return AlertCard(
              alert: alert,
              onTap: () => onAlertTap(alert),
              onSwipeAction: (action) => onSwipeAction(action, alert),
            );
          },
        ),
        SizedBox(height: 2.h),
      ],
    );
  }
}
