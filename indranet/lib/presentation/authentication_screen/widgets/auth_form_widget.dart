import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AuthFormWidget extends StatefulWidget {
  final bool isLoginMode;
  final Function(String email, String password, {String? name, String? phone})
      onSubmit;
  final bool isLoading;

  const AuthFormWidget({
    Key? key,
    required this.isLoginMode,
    required this.onSubmit,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<AuthFormWidget> createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final isValid = widget.isLoginMode
        ? _emailController.text.isNotEmpty &&
            _passwordController.text.isNotEmpty
        : _nameController.text.isNotEmpty &&
            _emailController.text.isNotEmpty &&
            _phoneController.text.isNotEmpty &&
            _passwordController.text.isNotEmpty;

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit mobile number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(
        _emailController.text.trim(),
        _passwordController.text,
        name: widget.isLoginMode ? null : _nameController.text.trim(),
        phone: widget.isLoginMode ? null : _phoneController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!widget.isLoginMode) ...[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'person',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
              ),
              textInputAction: TextInputAction.next,
              validator: _validateName,
            ),
            SizedBox(height: 2.h),
          ],
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email Address',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'email',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: _validateEmail,
          ),
          if (!widget.isLoginMode) ...[
            SizedBox(height: 2.h),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'phone',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
                prefixText: '+91 ',
                prefixStyle: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: _validatePhone,
            ),
          ],
          SizedBox(height: 2.h),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: CustomIconWidget(
                  iconName: _obscurePassword ? 'visibility' : 'visibility_off',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
            ),
            obscureText: _obscurePassword,
            textInputAction: widget.isLoginMode
                ? TextInputAction.done
                : TextInputAction.next,
            validator: _validatePassword,
            onFieldSubmitted: (_) {
              if (_isFormValid) {
                _handleSubmit();
              }
            },
          ),
          if (widget.isLoginMode) ...[
            SizedBox(height: 1.h),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Implement forgot password functionality
                },
                child: Text(
                  'Forgot Password?',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
          SizedBox(height: 4.h),
          SizedBox(
            height: 6.h,
            child: ElevatedButton(
              onPressed:
                  _isFormValid && !widget.isLoading ? _handleSubmit : null,
              child: widget.isLoading
                  ? SizedBox(
                      height: 4.w,
                      width: 4.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      widget.isLoginMode ? 'Login' : 'Create Account',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
