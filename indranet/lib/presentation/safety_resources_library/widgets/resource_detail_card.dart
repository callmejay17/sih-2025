import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ResourceDetailCard extends StatefulWidget {
  final String title;
  final String description;
  final String type;
  final bool isBookmarked;
  final bool isOfflineAvailable;
  final String? fileSize;
  final VoidCallback onTap;
  final VoidCallback onBookmarkTap;
  final VoidCallback? onDownloadTap;

  const ResourceDetailCard({
    Key? key,
    required this.title,
    required this.description,
    required this.type,
    required this.isBookmarked,
    required this.isOfflineAvailable,
    this.fileSize,
    required this.onTap,
    required this.onBookmarkTap,
    this.onDownloadTap,
  }) : super(key: key);

  @override
  State<ResourceDetailCard> createState() => _ResourceDetailCardState();
}

class _ResourceDetailCardState extends State<ResourceDetailCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _getTypeColor().withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.type,
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: _getTypeColor(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (widget.isOfflineAvailable)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color:
                                AppTheme.secondaryLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'offline_pin',
                                color: AppTheme.secondaryLight,
                                size: 3.w,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'Offline',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: AppTheme.secondaryLight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(width: 2.w),
                      GestureDetector(
                        onTap: widget.onBookmarkTap,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: widget.isBookmarked
                                ? AppTheme.alertLight.withValues(alpha: 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: widget.isBookmarked
                                ? 'favorite'
                                : 'favorite_border',
                            color: widget.isBookmarked
                                ? AppTheme.alertLight
                                : AppTheme.textSecondaryLight,
                            size: 5.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    widget.title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.description,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.fileSize != null) ...[
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'download',
                          color: AppTheme.textSecondaryLight,
                          size: 4.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Size: ${widget.fileSize}',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                        const Spacer(),
                        if (widget.onDownloadTap != null)
                          GestureDetector(
                            onTap: widget.onDownloadTap,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'download',
                                    color: AppTheme.primaryLight,
                                    size: 3.w,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'Download',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: AppTheme.primaryLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getTypeColor() {
    switch (widget.type.toLowerCase()) {
      case 'checklist':
        return AppTheme.secondaryLight;
      case 'guide':
        return AppTheme.primaryLight;
      case 'emergency':
        return AppTheme.alertLight;
      case 'first aid':
        return AppTheme.warningLight;
      default:
        return AppTheme.accentLight;
    }
  }
}
