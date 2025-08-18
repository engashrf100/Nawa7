import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/nawah_dialog.dart';
import 'package:nawah/features/home/data/model/branch_model/app_branch_model.dart';
import 'package:nawah/features/home/presentation/widgets/branch_details_widgets/expandable_header_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdvancedClickableContactCards extends StatelessWidget {
  final AppBranch? appBranch;

  const AdvancedClickableContactCards({Key? key, this.appBranch})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final branch = appBranch!.data!;

    return Column(
      children: [
        // Phone Numbers Card
        ExpandableHeaderCard(
          title: 'mobile_numbers'.tr(),
          description: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: (branch.phones ?? [])
                .map(
                  (phone) => _buildAdvancedContactTile(
                    context,
                    phone,
                    ContactType.phone,
                  ),
                )
                .toList(),
          ),
          isInitiallyExpanded: false,
          img: AppAssets.call,
        ),
        Gap(10.h),

        ExpandableHeaderCard(
          title: 'whatsapp_number'.tr(),
          description: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: (branch.whatsappNumbers ?? [])
                .map(
                  (phone) => _buildAdvancedContactTile(
                    context,
                    phone,
                    ContactType.whatsapp,
                  ),
                )
                .toList(),
          ),
          isInitiallyExpanded: false,
          img: AppAssets.message,
        ),
      ],
    );
  }

  Widget _buildAdvancedContactTile(
    BuildContext context,
    String number,
    ContactType type,
  ) {
    final theme = Theme.of(context);
    final isPhone = type == ContactType.phone;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.colorScheme.text60.withOpacity(0.2)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: (isPhone ? Colors.green : const Color(0xFF25D366))
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            isPhone ? Icons.phone : Icons.chat_bubble_outline,
            color: isPhone ? Colors.green : const Color(0xFF25D366),
            size: 20.sp,
          ),
        ),
        title: Text(
          number,
          style: AppTextStyles.tajawal16W400.copyWith(
            color: theme.colorScheme.text100,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          isPhone ? 'press_to_call'.tr() : 'press_to_open_whatsapp'.tr(),
          style: AppTextStyles.tajawal14W400.copyWith(
            color: theme.colorScheme.text60,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16.sp,
          color: theme.colorScheme.text60,
        ),
        onTap: () {
          HapticFeedback.lightImpact();
          if (isPhone) {
            _handleContact(context, ContactType.phone, number);
          } else {
            _handleContact(context, ContactType.whatsapp, number);
          }
        },
      ),
    );
  }

  void _handleContact(
    BuildContext context,
    ContactType type,
    String phoneNumber,
  ) async {
    bool success = false;

    if (type == ContactType.phone) {
      success = await ContactService.openPhoneCall(phoneNumber);
      if (!success) {
        _showErrorDialog(context, 'cant_open_phone_app'.tr());
      }
    } else if (type == ContactType.whatsapp) {
      success = await ContactService.openWhatsApp(phoneNumber);
      if (!success) {
        _showErrorDialog(context, 'cant_open_whatsapp_app'.tr());
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    DialogService.error(context, title: message);
  }
}

enum ContactType { phone, whatsapp }

class ContactService {
  static Future<bool> openPhoneCall(String phoneNumber) async {
    try {
      final cleanNumber = _sanitizePhoneNumber(phoneNumber);
      final uri = Uri.parse('tel:$cleanNumber');
      return await launchUrl(uri);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> openWhatsApp(String phoneNumber) async {
    try {
      final cleanNumber = _sanitizePhoneNumber(phoneNumber);
      final waMeNumber = cleanNumber.replaceAll('+', '');
      final uri = Uri.parse('https://wa.me/$waMeNumber');
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  // Social Media Link Handlers
  static Future<bool> openFacebook(String url) async {
    try {
      final uri = Uri.parse(url);
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> openInstagram(String url) async {
    try {
      final uri = Uri.parse(url);
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> openYouTube(String url) async {
    try {
      final uri = Uri.parse(url);
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> openTikTok(String url) async {
    try {
      final uri = Uri.parse(url);
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> openSnapchat(String url) async {
    try {
      final uri = Uri.parse(url);
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> openX(String url) async {
    try {
      final uri = Uri.parse(url);
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  static String _sanitizePhoneNumber(String number) {
    String clean = number.replaceAll(RegExp(r'[^\d+]'), '');
    if (!clean.startsWith('+')) {
      if (clean.startsWith('0')) {
        clean = '+2${clean.substring(1)}'; // Assume Egypt
      } else {
        clean = '+20$clean';
      }
    }
    return clean;
  }
}
