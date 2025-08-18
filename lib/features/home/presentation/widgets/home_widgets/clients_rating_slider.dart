import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/widgets/app_card.dart';
import 'package:nawah/core/widgets/custom_cached_image.dart';
import 'package:nawah/features/home/data/model/home_model.dart';

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  SizedBox(
                    width: 241.w,
                    child: Text(
                      rating.clientName ?? '',
                      overflow: TextOverflow.ellipsis,

                      style: AppTextStyles.tajawal18W700.copyWith(
                        color: theme.colorScheme.text80,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),

                  SizedBox(
                    width: 241.w,
                    child: Text(
                      rating.description ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,

                      style: AppTextStyles.tajawal14W400.copyWith(
                        color: theme.colorScheme.text60,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  Wrap(
                    spacing: 2.w,
                    children: List.generate(5, (i) {
                      return Icon(
                        i < (rating.stars?.toInt() ?? 0)
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 20.sp,
                      );
                    }),
                  ),
                ],
              ),
            ),

            Container(
              width: 281.w,
              height: 77.h,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.greyStroke,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10.r),
                  bottomLeft: Radius.circular(10.r),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.r),
                    child: CustomCachedImage(
                      imageUrl: rating.image ?? '',
                      width: 40.w,
                      height: 40.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 10.w),

                  /// النصوص
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rating.name ?? " ",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppTextStyles.tajawal16W500.copyWith(
                            color: theme.colorScheme.text100,
                          ),
                        ),
                        Text(
                          rating.clientJob ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppTextStyles.tajawal14W400.copyWith(
                            color: theme.colorScheme.text60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
