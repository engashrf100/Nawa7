import 'dart:async';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/custom_text_field.dart';
import 'package:nawah/features/auth/presentation/widgets/field_with_country_picker.dart';
import 'package:nawah/features/home/presentation/widgets/consultation_form_widgets/specialty_dropdown_bottomsheet.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_promary_button.dart';

class ConsultationForm extends StatefulWidget {
  const ConsultationForm({super.key});

  @override
  State<ConsultationForm> createState() => _ConsultationFormState();
}

class _ConsultationFormState extends State<ConsultationForm> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _consultationController = TextEditingController();

  String? _selectedSpecialty;
  XFile? _pickedFile;
  double _uploadProgress = 0.0;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _consultationController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _pickedFile = file;
        _uploadProgress = 0.0;
      });
      _simulateUploadProgress();
    }
  }

  void _removeFile() {
    setState(() {
      _pickedFile = null;
      _uploadProgress = 0.0;
    });
  }

  void _simulateUploadProgress() {
    Timer.periodic(const Duration(milliseconds: 120), (timer) {
      setState(() {
        if (_uploadProgress < 1.0) {
          _uploadProgress += 0.05;
        } else {
          timer.cancel();
          _uploadProgress = 1.0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 341.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: colorScheme.border,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(context, 'consultation_form_full_name'.tr()),
          CustomTextField(
            controller: _nameController,
            hintText: 'consultation_form_full_name_hint'.tr(),
          ),
          SizedBox(height: 20.h),
          _buildLabel(context, 'consultation_form_phone_label'.tr()),
          PhoneFieldWithCountryPicker(
            controller: _phoneController,
            hintText: 'phone_label'.tr(),
          ),
          SizedBox(height: 20.h),
          _buildLabel(context, 'consultation_form_select_specialty'.tr()),

          SpecialtySelectionButton(
            selectedSpecialty: _selectedSpecialty,
            onSpecialtySelected: (specialty) {
              setState(() {
                _selectedSpecialty = specialty;
              });
            },
          ),
          SizedBox(height: 20.h),
          _buildLabel(context, 'consultation_form_write_consultation'.tr()),
          CustomTextField(
            controller: _consultationController,
            hintText: 'consultation_form_write_consultation_hint'.tr(),
            maxLines: 5,
          ),
          SizedBox(height: 20.h),
          FileUploadArea(onTap: _pickFile),
          if (_pickedFile != null) ...[
            SizedBox(height: 16.h),
            UploadedFileDisplay(
              file: _pickedFile!,
              progress: _uploadProgress,
              onRemove: _removeFile,
            ),
          ],
          SizedBox(height: 20.h),

          AppPrimaryButton(title: "send_consultation".tr(), onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Text(
            text,
            style: AppTextStyles.tajawal16W500.copyWith(
              color: colorScheme.text100,
            ),
          ),
          Text(
            ' *',
            style: AppTextStyles.tajawal22W700.copyWith(
              color: AppColors.lightBlue02,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 53.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: colorScheme.greyStroke,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          elevation: 2,

          dropdownColor: colorScheme.container,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: colorScheme.onSurface),
          hint: Text(
            hint,
            style: AppTextStyles.tajawal14W400.copyWith(
              color: colorScheme.text60,
            ),
          ),
          onChanged: onChanged,
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,

                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      e,
                      style: AppTextStyles.tajawal14W500.copyWith(
                        color: colorScheme.text100,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class FileUploadArea extends StatelessWidget {
  final VoidCallback onTap;
  const FileUploadArea({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 49.h,
        decoration: BoxDecoration(
          color: colorScheme.border,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: DottedBorder(
          options: RectDottedBorderOptions(
            strokeWidth: 1.5,
            dashPattern: [5, 5],
            gradient: LinearGradient(
              colors: [
                AppColors.lightBlue02,
                AppColors.lightBlue01.withOpacity(0.2),
              ],
            ),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 20.sp,
                  color: colorScheme.onSurface,
                ),
                SizedBox(width: 6.w),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        style: AppTextStyles.tajawal14W700.copyWith(
                          color: colorScheme.text40,
                        ),
                        text: 'consultation_form_upload_file'.tr(),
                      ),
                      WidgetSpan(child: SizedBox(width: 5.w)),
                      TextSpan(
                        text: 'consultation_form_upload_file_optional'.tr(),
                        style: AppTextStyles.tajawal12W400.copyWith(
                          color: colorScheme.text40,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UploadedFileDisplay extends StatelessWidget {
  final XFile file;
  final double progress;
  final VoidCallback onRemove;

  const UploadedFileDisplay({
    super.key,
    required this.file,
    required this.progress,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 80.h,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: Image.file(
              File(file.path),
              width: 64.w,
              height: 64.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        file.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onRemove,
                      child: Icon(
                        Icons.close,
                        size: 18.sp,
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: colorScheme.surfaceVariant,
                  color: colorScheme.primary,
                  minHeight: 4.h,
                  borderRadius: BorderRadius.circular(2.r),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final List<double> dashPattern; // [on, off, on, off...]

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.radius = 0.0,
    this.dashPattern = const [5.0, 5.0],
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final path = Path();
    path.addRRect(rect);

    var metrics = path.computeMetrics();
    for (var metric in metrics) {
      double currentLength = 0;
      while (currentLength < metric.length) {
        double on = dashPattern[0];
        double off = dashPattern[1];

        // Ensure we don't go past the end of the path
        double segmentLength = currentLength + on;
        if (segmentLength > metric.length) {
          on = metric.length - currentLength;
          segmentLength = metric.length;
        }

        canvas.drawPath(
          metric.extractPath(currentLength, segmentLength),
          paint,
        );

        currentLength += on + off;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Or true if properties can change
  }
}
