import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../core/app_export.dart';
import '../routes/app_routes.dart';

// custom_error_widget.dart

class CustomErrorWidget extends StatelessWidget {
  final FlutterErrorDetails? errorDetails;
  final String? errorMessage;

  const CustomErrorWidget({
    Key? key,
    this.errorDetails,
    this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/sad_face.svg',
                height: 42,
                width: 42,
              ),
              const SizedBox(height: 8),
              Text(
                "Something went wrong",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'We encountered an unexpected error while processing your request.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  bool canBeBack = Navigator.canPop(context);
                  if (canBeBack) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.pushNamed(context, AppRoutes.initial);
                  }
                },
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Back'),
                style: theme.elevatedButtonTheme.style,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
