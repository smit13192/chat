import 'package:chat/src/config/constant/app_color.dart';
import 'package:chat/src/config/constant/app_string.dart';
import 'package:chat/src/core/utils/formz_status.dart';
import 'package:chat/src/core/utils/validator.dart';
import 'package:chat/src/core/widgets/custom_button.dart';
import 'package:chat/src/core/widgets/custom_form_field.dart';
import 'package:chat/src/core/widgets/custom_text.dart';
import 'package:chat/src/core/widgets/gap.dart';
import 'package:chat/src/feature/auth/presentation/provider/authentication_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                'Register',
                color: AppColor.whiteColor,
                fontSize: 24.sp,
              ),
              GapH(2.h),
              CustomFormField(
                controller: usernameController,
                hintText: 'Enter username',
                keyboardType: TextInputType.name,
                validator: (value) => Validator.validateUsername(value ?? ''),
              ),
              GapH(2.h),
              CustomFormField(
                controller: emailController,
                hintText: 'Enter email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) => Validator.validateEmail(value ?? ''),
              ),
              GapH(2.h),
              CustomFormField(
                controller: passwordController,
                hintText: 'Enter password',
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => Validator.validatePassword(value ?? ''),
                obscureText: true,
              ),
              GapH(2.h),
              Builder(
                builder: (context) {
                  final isLoading =
                      context.select<AuthenticationProvider, bool>(
                    (provider) => provider.registerFormzStatus.isLoading,
                  );
                  return CustomButton(
                    text: 'Register',
                    onPressed: () => _onSubmit(context),
                    isLoading: isLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 1.h),
          child: RichText(
            text: TextSpan(
              text: 'Already have an account? ',
              style: TextStyle(
                color: AppColor.whiteColor.withAlpha(178),
                fontFamily: AppString.fontFamily,
              ),
              children: [
                TextSpan(
                  text: 'Sign In',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _onSignInTap(context),
                  style: const TextStyle(color: AppColor.primaryColor),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    if (!_key.currentState!.validate()) return;
    FocusScope.of(context).requestFocus(FocusNode());
    context.read<AuthenticationProvider>().register(
          context,
          username: usernameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
  }

  void _onSignInTap(BuildContext context) {
    Navigator.pop(context);
  }
}
