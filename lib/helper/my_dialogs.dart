import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/colors.dart';
import '../utils/custom_text_style.dart';

class MyDialogs {
  static Future<void> shareApp(BuildContext context) async {
    final mqData = MediaQuery.of(context).size;
    const playStoreLink =
        "https://play.google.com/store/apps/details?id=com.appcreatorrahul.smartexpirytracker";
    try {
      final result = await SharePlus.instance.share(
        ShareParams(
          text:
              'Avoid waste and save time with Smart Expiry Tracker! Easily manage expiry dates for groceries, medicines, and other items. Download now:\n$playStoreLink',
          subject: 'Smart Expiry Tracker',
        ),
      );
      if (result.status == ShareResultStatus.success) {
        /// Show impressive thank you animation
        await showDialog(
          context: context,
          barrierColor: Colors.black26,
          builder:
              (context) => Center(
                child: Material(
                  color: AppColors.secondary,
                  child: Container(
                    width: mqData.width * 0.85,
                    height: mqData.height * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Lottie.asset(
                            alignment: Alignment.center,
                            "assets/lottie/thank you.json",
                            height: mqData.width * 0.6,
                            fit: BoxFit.fill,
                            repeat: true,
                          ),
                        ),
                        Text(
                          "Thank You for Sharing!",
                          style: myTextStyle18(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Your support helps us grow and improve the app for everyone!",
                            textAlign: TextAlign.center,
                            style: myTextStyle15(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Spacer(),

                        /// --- Elevated button --- ///
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Continue",
                            style: myTextStyle18(
                              fontWeight: FontWeight.bold,
                              fontColor: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: mqData.height * 0.01),
                      ],
                    ),
                  ),
                ),
              ),
        );
      }
    } catch (e) {
      debugPrint('Sharing failed: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to share")));
    }
  }
}
