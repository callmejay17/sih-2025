import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationInfoWidget extends StatelessWidget {
  final Map<String, dynamic> disasterData;

  const LocationInfoWidget({
    Key? key,
    required this.disasterData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Location Details',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildLocationItem(
            'Area',
            disasterData['location']?['area'] ?? 'Unknown Area',
            'place',
          ),
          SizedBox(height: 1.5.h),
          _buildLocationItem(
            'District',
            disasterData['location']?['district'] ?? 'Unknown District',
            'location_city',
          ),
          SizedBox(height: 1.5.h),
          _buildLocationItem(
            'State',
            disasterData['location']?['state'] ?? 'Unknown State',
            'map',
          ),
          SizedBox(height: 1.5.h),
          _buildCoordinatesRow(),
          SizedBox(height: 1.5.h),
          _buildDistanceRow(),
        ],
      ),
    );
  }

  Widget _buildLocationItem(String label, String value, String iconName) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 4.w,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontSize: 10.sp,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCoordinatesRow() {
    double? latitude = disasterData['location']?['latitude']?.toDouble();
    double? longitude = disasterData['location']?['longitude']?.toDouble();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: 'my_location',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 4.w,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Coordinates',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontSize: 10.sp,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                latitude != null && longitude != null
                    ? '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}'
                    : 'Coordinates unavailable',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDistanceRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: 'near_me',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 4.w,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Distance from you',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontSize: 10.sp,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                _calculateDistance(),
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _calculateDistance() {
    // Mock distance calculation - in real app, use user's current location
    final distances = [
      '2.3 km',
      '5.7 km',
      '12.1 km',
      '8.9 km',
      '15.4 km',
      '3.2 km'
    ];
    return distances[disasterData['id'] % distances.length];
  }
}
