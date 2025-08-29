import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/widgets/app_card.dart';
import 'package:nawah/core/widgets/custom_cached_image.dart';
import 'package:nawah/features/home/data/model/home_model.dart';
import 'package:gap/gap.dart';

class ClientsRatingSlider extends StatelessWidget {
  final List<ClientReview> ratings;
  const ClientsRatingSlider({super.key, required this.ratings});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 275.h,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        controller: PageController(viewportFraction: 0.85.w),
        itemCount: ratings.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: ClientRatingItem(rating: ratings[index]),
          );
        },
      ),
    );
  }
}

class ClientRatingItem extends StatelessWidget {
  final ClientReview rating;
  
  const ClientRatingItem({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      width: 301.w,
      height: 275.h,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.border,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildMainContent(rating, theme),
            _buildClientInfo(rating, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(ClientReview rating, ThemeData theme) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClientName(rating, theme),
            Gap(6.h),
            _buildDescription(rating, theme),
            Gap(8.h),
            _buildStarRating(rating),
          ],
        ),
      ),
    );
  }

  Widget _buildClientName(ClientReview rating, ThemeData theme) {
    return Text(
      rating.clientName ?? '',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: AppTextStyles.tajawal18W700.copyWith(
        color: theme.colorScheme.text80,
      ),
    );
  }

  Widget _buildDescription(ClientReview rating, ThemeData theme) {
    return Flexible(
      child: Text(
        rating.description ?? '',
        overflow: TextOverflow.ellipsis,
        maxLines: 4,
        style: AppTextStyles.tajawal14W400.copyWith(
          color: theme.colorScheme.text60,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildStarRating(ClientReview rating) {
    return Wrap(
      spacing: 2.w,
      children: List.generate(5, (i) {
        return Icon(
          i < (rating.stars?.toInt() ?? 0)
              ? Icons.star
              : Icons.star_border,
          color: Colors.amber,
          size: 16.sp,
        );
      }),
    );
  }

  Widget _buildClientInfo(ClientReview rating, ThemeData theme) {
    return Container(
      width: double.infinity,
      height: 75.h, // Reduced height slightly
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h), // Reduced vertical padding
      decoration: BoxDecoration(
        color: theme.colorScheme.greyStroke,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10.r),
          bottomLeft: Radius.circular(10.r),
        ),
      ),
      child: Row(
        children: [
          _buildClientAvatar(rating),
          Gap(12.w),
          _buildClientDetails(rating, theme),
        ],
      ),
    );
  }

  Widget _buildClientAvatar(ClientReview rating) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: CustomCachedImage(
        imageUrl: rating.image ?? '',
        width: 40.w,
        height: 40.h,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildClientDetails(ClientReview rating, ThemeData theme) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            rating.name ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: AppTextStyles.tajawal16W500.copyWith(
              color: theme.colorScheme.text100,
            ),
          ),
          Gap(2.h),
          Text(
            rating.clientJob ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: AppTextStyles.tajawal14W400.copyWith(
              color: theme.colorScheme.text60,
            ),
          ),
        ],
      ),
    );
  }
}
