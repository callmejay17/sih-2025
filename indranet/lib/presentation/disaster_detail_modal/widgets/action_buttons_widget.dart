import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final Map<String, dynamic> disasterData;

  const ActionButtonsWidget({
    Key? key,
    required this.disasterData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  'Share Alert',
                  'share',
                  AppTheme.lightTheme.colorScheme.primary,
                  () => _shareAlert(context),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionButton(
                  context,
                  'Get Directions',
                  'directions',
                  AppTheme.lightTheme.colorScheme.secondary,
                  () => _getDirections(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: _buildActionButton(
              context,
              'Report Update',
              'report',
              AppTheme.lightTheme.colorScheme.tertiary,
              () => _reportUpdate(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    String iconName,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: Colors.white,
            size: 5.w,
          ),
          SizedBox(width: 2.w),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _shareAlert(BuildContext context) {
    final String shareText = _generateShareText();

    // Copy to clipboard as a fallback for sharing
    Clipboard.setData(ClipboardData(text: shareText));

    Fluttertoast.showToast(
      msg:
          "Alert details copied to clipboard. You can now share via any messaging app.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: Colors.white,
      fontSize: 14.sp,
    );
  }

  void _getDirections(BuildContext context) {
    final latitude = disasterData['location']?['latitude'];
    final longitude = disasterData['location']?['longitude'];

    if (latitude != null && longitude != null) {
      Fluttertoast.showToast(
        msg: "Opening directions to disaster location...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        textColor: Colors.white,
        fontSize: 14.sp,
      );

      // In a real app, this would open the device's default map app
      // For now, we'll show a toast with coordinates
      Future.delayed(Duration(seconds: 1), () {
        Fluttertoast.showToast(
          msg:
              "Coordinates: ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: AppTheme.lightTheme.colorScheme.onSurface,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
      });
    } else {
      Fluttertoast.showToast(
        msg: "Location coordinates not available",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: Colors.white,
        fontSize: 14.sp,
      );
    }
  }

  void _reportUpdate(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Report Update',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Help improve disaster information by reporting updates:',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              _buildReportOption(context, 'Situation Improved', 'trending_up'),
              SizedBox(height: 1.h),
              _buildReportOption(
                  context, 'Situation Worsened', 'trending_down'),
              SizedBox(height: 1.h),
              _buildReportOption(context, 'New Information', 'info'),
              SizedBox(height: 1.h),
              _buildReportOption(context, 'Incorrect Details', 'error'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReportOption(
      BuildContext context, String label, String iconName) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
          msg: "Thank you for reporting: $label",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          textColor: Colors.white,
          fontSize: 14.sp,
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  String _generateShareText() {
    final type = disasterData['type'] ?? 'Disaster';
    final severity = disasterData['severity'] ?? 'Unknown';
    final area = disasterData['location']?['area'] ?? 'Unknown Area';
    final district =
        disasterData['location']?['district'] ?? 'Unknown District';
    final state = disasterData['location']?['state'] ?? 'Unknown State';
    final latitude = disasterData['location']?['latitude'];
    final longitude = disasterData['location']?['longitude'];

    String coordinates = '';
    if (latitude != null && longitude != null) {
      coordinates =
          '\nCoordinates: ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
    }

    return '''🚨 DISASTER ALERT - $type
    
Severity: $severity
Location: $area, $district, $state$coordinates

Status: ${disasterData['status'] ?? 'Monitoring situation'}

⚠️ Please stay safe and follow official guidelines.

Shared via IndraNet - India's Emergency Response App''';
  }
}
