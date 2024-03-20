import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tourism_app/model/network_model/support_model.dart';
import 'package:flutter_tourism_app/network/api_service.dart';
import 'package:flutter_tourism_app/provider/genearl_providers.dart';
import 'package:flutter_tourism_app/provider/support_model.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callApi();
    });
    super.initState();
  }

  // final String emailAddress = "support@example.com";
  // final String phoneNumber = "+1234567890";

  callApi() async {
    ref.read(isNoDataProvider.notifier).state = false;
    ref.read(isLoadingProvider.notifier).state = true;
    await ref.read(apiServiceProvider).getSupportData(context).then((value) {
      if (value != null) {
        ref.read(supportDataProvider.notifier).addData(value);

        ref.read(isLoadingProvider.notifier).state = false;
      } else {
        ref.read(isNoDataProvider.notifier).state = true;
        ref.read(isLoadingProvider.notifier).state = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SupportModel? data = ref.watch(supportDataProvider);
    return Scaffold(
      appBar: const AppBarWidget(
        title: "Support",
      ),
      body: ref.watch(isLoadingProvider) == true || data == null
          ? const Center(
              child: CupertinoActivityIndicator(radius: 30),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                2.height(),
                Container(
                  color: AppColor.surfaceBackgroundColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        data.description,
                        style: AppTypography.paragraph16LG,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Get in touch with us",
                        style: AppTypography.title18LG.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 30),
                      InkWell(
                          onTap: () => _launchEmailApp("tel", data.phone),
                          child: ConfirmBookRowWidget(
                              title: "Phone", subtitle: data.phone)),
                      const SizedBox(height: 30),
                      InkWell(
                          onTap: () => _launchEmailApp("mailto", data.email),
                          child: ConfirmBookRowWidget(
                              title: "Email", subtitle: data.email)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _launchEmailApp(String scheme, String data) async {
    final Uri emailLaunchUri = Uri(
      scheme: scheme,
      path: data,
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      // Handle error
      print("Error launching email app");
    }
  }
}
