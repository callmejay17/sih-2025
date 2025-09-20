import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencyContactsWidget extends StatelessWidget {
  final Map<String, dynamic> disasterData;

  const EmergencyContactsWidget({
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
                iconName: 'emergency',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Emergency Contacts',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildContactGrid(),
        ],
      ),
    );
  }

  Widget _buildContactGrid() {
    final contacts = _getEmergencyContacts();

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
      ),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return _buildContactButton(
          contact['label'] as String,
          contact['number'] as String,
          contact['icon'] as String,
          contact['color'] as Color,
        );
      },
    );
  }

  Widget _buildContactButton(
      String label, String number, String iconName, Color color) {
    return InkWell(
      onTap: () => _makeCall(number, label),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 6.w,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              number,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontSize: 9.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getEmergencyContacts() {
    return [
      {
        'label': 'Police',
        'number': '100',
        'icon': 'local_police',
        'color': Colors.blue,
      },
      {
        'label': 'Fire',
        'number': '101',
        'icon': 'local_fire_department',
        'color': Colors.red,
      },
      {
        'label': 'Ambulance',
        'number': '108',
        'icon': 'local_hospital',
        'color': Colors.green,
      },
      {
        'label': 'Disaster',
        'number': '1078',
        'icon': 'warning',
        'color': Colors.orange,
      },
      {
        'label': 'Women Help',
        'number': '1091',
        'icon': 'support_agent',
        'color': Colors.purple,
      },
      {
        'label': 'Child Help',
        'number': '1098',
        'icon': 'child_care',
        'color': Colors.pink,
      },
    ];
  }

  void _makeCall(String number, String service) {
    // In a real app, this would use url_launcher to make actual phone calls
    // For now, we'll show a toast with the number
    Fluttertoast.showToast(
      msg: "Calling $service: $number",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: Colors.white,
      fontSize: 14.sp,
    );

    // Show additional information after a delay
    Future.delayed(Duration(seconds: 1), () {
      Fluttertoast.showToast(
        msg: "In a real app, this would dial $number",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: AppTheme.lightTheme.colorScheme.onSurface,
        textColor: Colors.white,
        fontSize: 12.sp,
      );
    });
  }
}
