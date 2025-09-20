import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DisasterContentWidget extends StatelessWidget {
  final Map<String, dynamic> disasterData;

  const DisasterContentWidget({
    Key? key,
    required this.disasterData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(),
          SizedBox(height: 2.h),
          _buildAffectedPopulationCard(),
          SizedBox(height: 2.h),
          _buildSafetyActionsCard(),
          SizedBox(height: 2.h),
          _buildEvacuationRoutesCard(),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
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
                iconName: 'info',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Current Status',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            disasterData['status'] ??
                'Status information is currently being updated. Please stay alert and follow official guidelines.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildAffectedPopulationCard() {
    return Container(
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
                iconName: 'groups',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Affected Population',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildPopulationStat(
                  'Estimated Affected',
                  disasterData['affectedPopulation']?.toString() ?? '~5,000',
                  'people',
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildPopulationStat(
                  'Evacuated',
                  disasterData['evacuated']?.toString() ?? '~1,200',
                  'person',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopulationStat(String label, String value, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 6.w,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSafetyActionsCard() {
    List<String> safetyActions = _getSafetyActions();

    return Container(
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
                iconName: 'security',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Recommended Safety Actions',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ...safetyActions.asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: 1.5.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildEvacuationRoutesCard() {
    return Container(
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
                iconName: 'directions',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Evacuation Routes',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            _getEvacuationInfo(),
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  List<String> _getSafetyActions() {
    String disasterType = disasterData['type']?.toLowerCase() ?? '';

    switch (disasterType) {
      case 'earthquake':
        return [
          'Drop, Cover, and Hold On if shaking continues',
          'Stay away from windows and heavy objects',
          'If outdoors, move away from buildings and power lines',
          'Check for injuries and provide first aid if needed',
          'Be prepared for aftershocks',
        ];
      case 'flood':
        return [
          'Move to higher ground immediately',
          'Avoid walking or driving through flood water',
          'Stay away from electrical equipment if wet',
          'Listen to emergency broadcasts for updates',
          'Do not drink flood water - use bottled water only',
        ];
      case 'cyclone':
        return [
          'Stay indoors and away from windows',
          'Secure loose objects that could become projectiles',
          'Keep emergency supplies ready',
          'Monitor weather updates continuously',
          'Do not go outside during the eye of the storm',
        ];
      case 'fire':
        return [
          'Evacuate immediately if instructed',
          'Stay low to avoid smoke inhalation',
          'Close doors behind you to slow fire spread',
          'Call emergency services if safe to do so',
          'Do not use elevators during evacuation',
        ];
      default:
        return [
          'Follow instructions from local authorities',
          'Stay informed through official channels',
          'Keep emergency supplies ready',
          'Avoid affected areas unless necessary',
          'Help others if you can do so safely',
        ];
    }
  }

  String _getEvacuationInfo() {
    String disasterType = disasterData['type']?.toLowerCase() ?? '';

    switch (disasterType) {
      case 'flood':
        return 'Primary evacuation route: NH-44 towards higher ground. Alternative routes: State Highway 15 and local roads via Sector 12. Avoid low-lying areas and underpasses. Emergency shelters available at Government Higher Secondary School and Community Center.';
      case 'cyclone':
        return 'Evacuation not recommended during active cyclone. Shelter in place in sturdy buildings. Post-cyclone evacuation routes will be announced. Emergency shelters: District Collector Office and nearby schools.';
      case 'earthquake':
        return 'If evacuation is necessary, use main roads avoiding damaged structures. Assembly points: Central Park and Stadium Ground. Check building safety before re-entry. Emergency medical facilities at District Hospital.';
      case 'fire':
        return 'Immediate evacuation via Ring Road and bypass routes. Avoid areas with heavy smoke. Temporary shelters at Sports Complex and Marriage Hall. Fire department establishing safe corridors.';
      default:
        return 'Follow designated evacuation routes as announced by local authorities. Primary assembly point at Central Ground. Keep important documents ready. Emergency transportation available at main intersections.';
    }
  }
}
