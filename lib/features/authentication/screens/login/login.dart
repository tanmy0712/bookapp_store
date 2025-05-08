import 'package:flutter/material.dart';
import 'package:libercopia_bookstore_app/features/authentication/screens/login/widgets/login_form.dart';
import 'package:libercopia_bookstore_app/features/authentication/screens/login/widgets/login_header.dart';

import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: LSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo , Title & Subtitle
              LLoginHeader(),

              /// Form
              LLoginForm(),

              /// Divider
              LFormDivider(dividerText: LTexts.orSignInWith),
              const SizedBox(height: LSizes.spaceBtwItems),

              /// Footer
              LSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
