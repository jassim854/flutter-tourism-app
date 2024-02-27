import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:url_launcher/url_launcher.dart';

class SupportView extends ConsumerStatefulWidget {
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
      appBar: AppBar(
        title: Text("Contact Us"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "For support, contact us via:",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () => _launchEmailApp(),
              child: Text(
                "Email: $emailAddress",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () => _launchPhonePad(),
              child: Text(
                "Phone: $phoneNumber",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
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
  