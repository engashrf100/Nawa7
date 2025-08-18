import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/features/home/data/model/branch_model/branch_model.dart';
import 'package:nawah/features/home/presentation/widgets/branch_details_widgets/advanced_clickable_contact_cards.dart';

class SocialButtonsRow extends StatelessWidget {
  final Branch? branch;

  const SocialButtonsRow({super.key, this.branch});

  @override
  Widget build(BuildContext context) {
    if (branch == null) return const SizedBox.shrink();

    final socialLinks = _getAvailableSocialLinks(branch!);

    if (socialLinks.isEmpty) return const SizedBox.shrink();

    return Center(
      child: SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: socialLinks.map((link) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: _socialButton(
                iconPath: link.iconPath,
                onTap: () => _handleSocialTap(context, link),
                tooltip: link.tooltip,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  List<SocialLink> _getAvailableSocialLinks(Branch branch) {
    final links = <SocialLink>[];

    if (branch.facebook != null && branch.facebook!.isNotEmpty) {
      links.add(
        SocialLink(
          type: SocialType.facebook,
          url: branch.facebook!,
          iconPath: AppAssets.facebook,
          tooltip: 'open_facebook'.tr(),
        ),
      );
    }

    if (branch.x != null && branch.x!.isNotEmpty) {
      links.add(
        SocialLink(
          type: SocialType.x,
          url: branch.x!,
          iconPath: AppAssets.x,
          tooltip: 'open_x'.tr(),
        ),
      );
    }

    if (branch.instagram != null && branch.instagram!.isNotEmpty) {
      links.add(
        SocialLink(
          type: SocialType.instagram,
          url: branch.instagram!,
          iconPath: AppAssets.instagram,
          tooltip: 'open_instagram'.tr(),
        ),
      );
    }

    if (branch.youtube != null && branch.youtube!.isNotEmpty) {
      links.add(
        SocialLink(
          type: SocialType.youtube,
          url: branch.youtube!,
          iconPath: AppAssets.youtube,
          tooltip: 'open_youtube'.tr(),
        ),
      );
    }

    if (branch.tiktok != null && branch.tiktok!.isNotEmpty) {
      links.add(
        SocialLink(
          type: SocialType.tiktok,
          url: branch.tiktok!,
          iconPath: AppAssets.tiktok,
          tooltip: 'open_tiktok'.tr(),
        ),
      );
    }

    if (branch.snapchat != null && branch.snapchat!.isNotEmpty) {
      links.add(
        SocialLink(
          type: SocialType.snapchat,
          url: branch.snapchat!,
          iconPath: AppAssets.snapchat,
          tooltip: 'open_snapchat'.tr(),
        ),
      );
    }

    return links;
  }

  Future<void> _handleSocialTap(BuildContext context, SocialLink link) async {
    bool success = false;

    switch (link.type) {
      case SocialType.facebook:
        success = await ContactService.openFacebook(link.url);
        break;
      case SocialType.x:
        success = await ContactService.openX(link.url);
        break;
      case SocialType.instagram:
        success = await ContactService.openInstagram(link.url);
        break;
      case SocialType.youtube:
        success = await ContactService.openYouTube(link.url);
        break;
      case SocialType.tiktok:
        success = await ContactService.openTikTok(link.url);
        break;
      case SocialType.snapchat:
        success = await ContactService.openSnapchat(link.url);
        break;
    }

    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('cant_open_social_app'.tr()),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _socialButton({
    required String iconPath,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SvgPicture.asset(
            iconPath,
            width: 20,
            height: 20,
            // Add error handling for SVG loading
            placeholderBuilder: (context) =>
                const Icon(Icons.error, size: 20, color: Colors.red),
          ),
        ),
      ),
    );
  }
}

class SocialLink {
  final SocialType type;
  final String url;
  final String iconPath;
  final String tooltip;

  SocialLink({
    required this.type,
    required this.url,
    required this.iconPath,
    required this.tooltip,
  });
}

enum SocialType { facebook, x, instagram, youtube, tiktok, snapchat }
