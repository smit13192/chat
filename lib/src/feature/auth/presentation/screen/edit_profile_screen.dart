import 'package:chat/main.dart';
import 'package:chat/src/api/endpoints.dart';
import 'package:chat/src/config/constant/app_color.dart';
import 'package:chat/src/core/services/image_service.dart';
import 'package:chat/src/core/utils/validator.dart';
import 'package:chat/src/core/widgets/custom_button.dart';
import 'package:chat/src/core/widgets/custom_form_field.dart';
import 'package:chat/src/core/widgets/custom_image.dart';
import 'package:chat/src/core/widgets/custom_text.dart';
import 'package:chat/src/core/widgets/gap.dart';
import 'package:chat/src/feature/auth/presentation/provider/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController usernameController = TextEditingController();

  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final authenticationProvider = context.read<AuthenticationProvider>();
        usernameController.text = authenticationProvider.user!.username;
        authenticationProvider.onUpdateImage(null);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authenticationProvider = context.read<AuthenticationProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor.withOpacity(0.15),
        elevation: 0,
        systemOverlayStyle: systemOverlayStyle,
        title: CustomText(
          'Edit profile',
          fontSize: 13.sp,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Form(
          key: _key,
          child: Column(
            children: [
              GapH(3.h),
              Builder(
                builder: (context) {
                  final authenticationProvider =
                      context.watch<AuthenticationProvider>();

                  return GestureDetector(
                    onTap: () => _onImageTap(context),
                    child: SizedBox(
                      height: 30.w,
                      width: 30.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.w),
                        child: authenticationProvider.updatedImage == null
                            ? CustomImage(
                                authenticationProvider.user!.image.toApiImage(),
                              )
                            : Image.file(
                                authenticationProvider.updatedImage!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  );
                },
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
                initialValue: authenticationProvider.user!.email,
                readOnly: true,
                enabled: false,
                hintText: 'Enter email',
              ),
              GapH(2.h),
              CustomButton(
                text: 'Save',
                onPressed: () => _onSaveSubmit(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSaveSubmit(BuildContext context) {
    final authenticationProvider = context.read<AuthenticationProvider>();
    if (!_key.currentState!.validate() ||
        (authenticationProvider.user!.username ==
                usernameController.text.trim() &&
            authenticationProvider.updatedImage == null)) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    authenticationProvider.updateUser(
      context,
      username: usernameController.text.trim(),
    );
  }

  Future<void> _onImageTap(BuildContext context) async {
    final image = await ImageService.pickImage(
      context: context,
      source: ImageSource.gallery,
    );
    if (image == null) return;
    if (!context.mounted) return;
    context.read<AuthenticationProvider>().onUpdateImage(image);
  }
}
