import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tourism_app/utils/app_assets.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/view/home_/home_detail_view.dart';
import 'package:flutter_tourism_app/widgets/custom_appbar_widget.dart';

import 'package:url_launcher/url_launcher.dart';

class SupportView extends ConsumerStatefulWidget {
  static const routeName = "/supportView";
  const SupportView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SupportViewState();
}

class _SupportViewState extends ConsumerState<SupportView> {
  final String emailAddress = "support@example.com";
  final String phoneNumber = "+1234567890";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "Support",
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          2.height(),
          Container(
            color: AppColor.surfaceBackgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "At Cultural Guides by SMCCU, we're dedicated to ensuring your journey with us is smooth and enjoyable. Whether you have questions, need assistance, or want to provide feedback, our support team is here to help.",
                  style: AppTypography.paragraph16LG,
                ),
                SizedBox(height: 20),
                Text(
                  "Get in touch with us",
                  style: AppTypography.title18LG.copyWith(fontSize: 16),
                ),
                SizedBox(height: 30),
                InkWell(
                    onTap: () => _launchPhonePad(),
                    child: ConfirmBookRowWidget(
                        title: "Phone", subtitle: "+971 (0) 4 353 6666")),
                SizedBox(height: 30),
                InkWell(
                    onTap: () => _launchEmailApp(),
                    child: ConfirmBookRowWidget(
                        title: "Email",
                        subtitle: "marhaba@culturalguides.com")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _launchEmailApp() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      // Handle error
      print("Error launching email app");
    }
  }

  void _launchPhonePad() async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    } else {
      // Handle error
      print("Error launching phone pad");
    }
  }
}
