import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/auth_form_widget.dart';
import './widgets/auth_header_widget.dart';
import './widgets/auth_toggle_widget.dart';
import './widgets/biometric_auth_widget.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    with TickerProviderStateMixin {
  bool _isLoginMode = true;
  bool _isLoading = false;
  bool _isBiometricAvailable = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock credentials for testing
  final Map<String, Map<String, String>> _mockUsers = {
    'admin@indranet.gov.in': {
      'password': 'admin123',
      'name': 'Emergency Admin',
      'phone': '9876543210',
      'role': 'admin'
    },
    'volunteer@indranet.gov.in': {
      'password': 'volunteer123',
      'name': 'Relief Volunteer',
      'phone': '9876543211',
      'role': 'volunteer'
    },
    'citizen@indranet.gov.in': {
      'password': 'citizen123',
      'name': 'Local Citizen',
      'phone': '9876543212',
      'role': 'citizen'
    },
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkBiometricAvailability();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  void _checkBiometricAvailability() {
    // Simulate biometric availability check
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android)) {
      setState(() {
        _isBiometricAvailable = true;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleAuthMode(bool isLogin) {
    if (_isLoginMode != isLogin) {
      setState(() {
        _isLoginMode = isLogin;
      });

      // Haptic feedback
      HapticFeedback.lightImpact();
    }
  }

  Future<void> _handleAuthentication(
    String email,
    String password, {
    String? name,
    String? phone,
  }) async {
    setState(() {
      _isLoading = true;
    });

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      if (_isLoginMode) {
        // Login logic
        if (_mockUsers.containsKey(email.toLowerCase()) &&
            _mockUsers[email.toLowerCase()]!['password'] == password) {
          // Success haptic feedback
          HapticFeedback.heavyImpact();

          _showSuccessToast('Login successful! Welcome back.');

          // Navigate to dashboard (placeholder)
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          }
        } else {
          throw Exception(
              'Invalid email or password. Please try:\nadmin@indranet.gov.in / admin123\nvolunteer@indranet.gov.in / volunteer123\ncitizen@indranet.gov.in / citizen123');
        }
      } else {
        // Registration logic
        if (_mockUsers.containsKey(email.toLowerCase())) {
          throw Exception(
              'An account with this email already exists. Please login instead.');
        }

        // Simulate successful registration
        _mockUsers[email.toLowerCase()] = {
          'password': password,
          'name': name ?? '',
          'phone': phone ?? '',
          'role': 'citizen'
        };

        // Success haptic feedback
        HapticFeedback.heavyImpact();

        _showSuccessToast('Account created successfully! Please login.');

        // Switch to login mode
        setState(() {
          _isLoginMode = true;
        });

        // Request location permission after successful registration
        await _requestLocationPermission();
      }
    } catch (e) {
      // Error haptic feedback
      HapticFeedback.heavyImpact();

      _showErrorToast(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _requestLocationPermission() async {
    // Simulate location permission request
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'location_on',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Location Access',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
          ],
        ),
        content: Text(
          'IndraNet needs access to your location to provide disaster alerts and emergency services in your area.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSuccessToast('Location permission granted.');
            },
            child: const Text('Allow'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleBiometricAuth() async {
    try {
      // Simulate biometric authentication
      HapticFeedback.lightImpact();

      await Future.delayed(const Duration(milliseconds: 1500));

      // Success haptic feedback
      HapticFeedback.heavyImpact();

      _showSuccessToast('Biometric authentication successful!');

      // Navigate to dashboard
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      HapticFeedback.heavyImpact();
      _showErrorToast('Biometric authentication failed. Please try again.');
    }
  }

  void _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      textColor: AppTheme.lightTheme.colorScheme.onSecondary,
      fontSize: 14.sp,
    );
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.error,
      textColor: AppTheme.lightTheme.colorScheme.onError,
      fontSize: 14.sp,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AuthHeaderWidget(),

                        AuthToggleWidget(
                          isLoginMode: _isLoginMode,
                          onToggle: _toggleAuthMode,
                        ),

                        SizedBox(height: 4.h),

                        AuthFormWidget(
                          isLoginMode: _isLoginMode,
                          onSubmit: _handleAuthentication,
                          isLoading: _isLoading,
                        ),

                        if (_isLoginMode && _isBiometricAvailable)
                          BiometricAuthWidget(
                            onBiometricAuth: _handleBiometricAuth,
                            isAvailable: _isBiometricAvailable,
                          ),

                        SizedBox(height: 4.h),

                        // Terms and Privacy
                        if (!_isLoginMode) ...[
                          Text(
                            'By creating an account, you agree to our Terms of Service and Privacy Policy.',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 2.h),
                        ],

                        // Emergency contact info
                        Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.secondary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(3.w),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.secondary
                                  .withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'emergency',
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                                size: 6.w,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Emergency Helpline',
                                      style: AppTheme
                                          .lightTheme.textTheme.titleSmall
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.secondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Call 112 for immediate assistance',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}