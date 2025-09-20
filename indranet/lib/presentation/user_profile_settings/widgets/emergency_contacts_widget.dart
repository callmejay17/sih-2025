import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencyContactsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> emergencyContacts;
  final VoidCallback onAddContact;
  final Function(int) onEditContact;
  final Function(int) onDeleteContact;

  const EmergencyContactsWidget({
    super.key,
    required this.emergencyContacts,
    required this.onAddContact,
    required this.onEditContact,
    required this.onDeleteContact,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add Contact Button
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: OutlinedButton.icon(
            onPressed: onAddContact,
            icon: CustomIconWidget(
              iconName: 'add',
              color: AppTheme.lightTheme.primaryColor,
              size: 4.w,
            ),
            label: Text('Add Emergency Contact'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
            ),
          ),
        ),
        // Emergency Contacts List
        if (emergencyContacts.isNotEmpty) ...[
          Divider(
            height: 1,
            thickness: 0.5,
            indent: 4.w,
            endIndent: 4.w,
            color: Theme.of(context).dividerColor,
          ),
          ...emergencyContacts.asMap().entries.map((entry) {
            final int index = entry.key;
            final Map<String, dynamic> contact = entry.value;
            final bool isLast = index == emergencyContacts.length - 1;

            return _buildContactItem(context, contact, index, !isLast);
          }).toList(),
        ],
      ],
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    Map<String, dynamic> contact,
    int index,
    bool showDivider,
  ) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: [
              // Contact Avatar
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'person',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 6.w,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              // Contact Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact['name'] as String? ?? 'Unknown Contact',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      contact['phone'] as String? ?? 'No phone number',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (contact['relationship'] != null) ...[
                      SizedBox(height: 0.5.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          contact['relationship'] as String,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppTheme.lightTheme.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Action Buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => onEditContact(index),
                    icon: CustomIconWidget(
                      iconName: 'edit',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 4.w,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 8.w,
                      minHeight: 8.w,
                    ),
                  ),
                  IconButton(
                    onPressed: () => onDeleteContact(index),
                    icon: CustomIconWidget(
                      iconName: 'delete',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 4.w,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 8.w,
                      minHeight: 8.w,
                    ),
                  ),
                ],
              ),
            ],
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
