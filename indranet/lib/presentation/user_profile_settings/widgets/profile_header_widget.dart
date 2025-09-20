import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onEditProfile;

  const ProfileHeaderWidget({
    super.key,
    required this.userData,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Profile Avatar
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.primaryColor,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: userData['avatar'] != null
                      ? CustomImageWidget(
                          imageUrl: userData['avatar'] as String,
                          width: 20.w,
                          height: 20.w,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.1),
                          child: CustomIconWidget(
                            iconName: 'person',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 10.w,
                          ),
                        ),
                ),
              ),
              SizedBox(width: 4.w),
              // Profile Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData['name'] as String? ?? 'User Name',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    // Volunteer Status Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: userData['isVolunteer'] == true
                            ? AppTheme.lightTheme.colorScheme.secondary
                                .withValues(alpha: 0.1)
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: userData['isVolunteer'] == true
                                ? 'verified'
                                : 'person',
                            color: userData['isVolunteer'] == true
                                ? AppTheme.lightTheme.colorScheme.secondary
                                : AppTheme.lightTheme.colorScheme.outline,
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            userData['isVolunteer'] == true
                                ? 'Active Volunteer'
                                : 'Citizen',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: userData['isVolunteer'] == true
                                      ? AppTheme
                                          .lightTheme.colorScheme.secondary
                                      : AppTheme.lightTheme.colorScheme.outline,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      userData['location'] as String? ?? 'Location not set',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          // Edit Profile Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onEditProfile,
              icon: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.primaryColor,
                size: 4.w,
              ),
              label: Text('Edit Profile'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
