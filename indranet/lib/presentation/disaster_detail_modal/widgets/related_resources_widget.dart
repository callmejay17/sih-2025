import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RelatedResourcesWidget extends StatelessWidget {
  final Map<String, dynamic> disasterData;

  const RelatedResourcesWidget({
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
                iconName: 'library_books',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Related Resources',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ..._getRelatedResources()
              .map((resource) => _buildResourceItem(
                    context,
                    resource['title'] as String,
                    resource['description'] as String,
                    resource['icon'] as String,
                    resource['route'] as String?,
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildResourceItem(
    BuildContext context,
    String title,
    String description,
    String iconName,
    String? route,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: () => _navigateToResource(context, title, route),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      description,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 4.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getRelatedResources() {
    String disasterType = disasterData['type']?.toLowerCase() ?? '';

    List<Map<String, dynamic>> commonResources = [
      {
        'title': 'Safety Resources Library',
        'description': 'Complete safety guides and emergency procedures',
        'icon': 'menu_book',
        'route': '/safety-resources-library',
      },
      {
        'title': 'Volunteer Mission Board',
        'description': 'Join relief efforts and help your community',
        'icon': 'volunteer_activism',
        'route': '/volunteer-mission-board',
      },
      {
        'title': 'Alert Center',
        'description': 'View all active alerts and notifications',
        'icon': 'notifications_active',
        'route': '/alert-center',
      },
    ];

    // Add disaster-specific resources
    switch (disasterType) {
      case 'earthquake':
        commonResources.insert(0, {
          'title': 'Earthquake Safety Guide',
          'description': 'Learn Drop, Cover, and Hold On techniques',
          'icon': 'vibration',
          'route': null,
        });
        break;
      case 'flood':
        commonResources.insert(0, {
          'title': 'Flood Safety Procedures',
          'description': 'Water safety and evacuation guidelines',
          'icon': 'water_drop',
          'route': null,
        });
        break;
      case 'cyclone':
        commonResources.insert(0, {
          'title': 'Cyclone Preparedness',
          'description': 'Storm safety and shelter guidelines',
          'icon': 'cyclone',
          'route': null,
        });
        break;
      case 'fire':
        commonResources.insert(0, {
          'title': 'Fire Safety Manual',
          'description': 'Evacuation routes and fire prevention',
          'icon': 'local_fire_department',
          'route': null,
        });
        break;
    }

    return commonResources;
  }

  void _navigateToResource(BuildContext context, String title, String? route) {
    if (route != null) {
      Navigator.pushNamed(context, route);
    } else {
      Fluttertoast.showToast(
        msg: "Opening $title...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        textColor: Colors.white,
        fontSize: 14.sp,
      );

      // Show additional information for disaster-specific guides
      Future.delayed(Duration(seconds: 1), () {
        Fluttertoast.showToast(
          msg:
              "This would open detailed safety guide for ${disasterData['type']}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: AppTheme.lightTheme.colorScheme.onSurface,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
      });
    }
  }
}
