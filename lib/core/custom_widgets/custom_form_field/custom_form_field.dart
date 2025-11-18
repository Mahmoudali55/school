import 'dart:ui' as ui;

import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../../extension/context_extension.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_style.dart';

enum FormFieldBorder { underLine, outLine, none }

class CustomFormField extends StatefulWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isPassword;
  final String? hintText;
  final int? maxLines;
  final void Function()? onTap;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double radius;
  final Color? fillColor;
  final Color? focusColor;
  final Color? unFocusColor;
  final Color? passwordColor;
  final String? title;
  final String? otherSideTitle;
  final ui.TextDirection? textDirection;
  final Country? country;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(Country)? onCountrySelect;
  final FormFieldBorder formFieldBorder;
  final TextStyle? titleStyle;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final int? maxLength;
  final double? width;
  final AutovalidateMode? autovalidateMode;
  const CustomFormField({
    super.key,
    this.controller,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
    this.hintText,
    this.maxLines = 1,
    this.onTap,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.radius = 5,
    this.fillColor,
    this.focusColor,
    this.unFocusColor,
    this.title,
    this.textDirection,
    this.otherSideTitle,
    this.country,
    this.passwordColor,
    this.formFieldBorder = FormFieldBorder.outLine,
    this.inputFormatters,
    this.onCountrySelect,
    this.titleStyle,
    this.textStyle,
    this.hintStyle,
    this.maxLength,
    this.autovalidateMode,
    this.width,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (widget.title != null) ...{
                Expanded(
                  child: Text(
                    widget.title!,
                    style:
                        widget.titleStyle ??
                        AppTextStyle.formTitleStyle(context),
                  ),
                ),
              },
              if (widget.otherSideTitle != null) ...{
                Text(
                  widget.otherSideTitle!,
                  style:
                      widget.titleStyle ?? AppTextStyle.formTitleStyle(context),
                ),
              },
            ],
          ),
          if (widget.title != null || widget.otherSideTitle != null) ...{
            const Gap(5),
          },
          Directionality(
            textDirection: widget.textDirection != null
                ? widget.textDirection!
                : context.isRTL()
                ? ui.TextDirection.rtl
                : ui.TextDirection.ltr,
            child: TextFormField(
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              controller: widget.controller,
              onChanged: widget.onChanged,
              validator: widget.validator,
              onTap: widget.onTap,
              readOnly: widget.readOnly,
              keyboardType: widget.keyboardType,
              obscureText: widget.isPassword ? _obscureText : false,
              style: widget.textStyle ?? AppTextStyle.textFormStyle(context),
              autovalidateMode:
                  widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
              maxLines: widget.maxLines,
              cursorColor: widget.focusColor ?? AppColor.primaryColor(context),
              inputFormatters: widget.inputFormatters,
              maxLength: widget.maxLength,
              decoration: InputDecoration(
                hintMaxLines: 2,
                errorMaxLines: 2,
                hintText: widget.hintText,
                hintStyle: widget.hintStyle ?? AppTextStyle.hintStyle(context),
                fillColor:
                    widget.fillColor ??
                    (widget.formFieldBorder == FormFieldBorder.underLine
                        ? Colors.transparent
                        : AppColor.textFormFillColor(context)),
                filled: true,
                border: _border(
                  color:
                      widget.unFocusColor ??
                      AppColor.textFormBorderColor(context),
                ),
                disabledBorder: _border(
                  color:
                      widget.unFocusColor ??
                      AppColor.textFormBorderColor(context),
                ),
                focusedBorder: _border(
                  color: widget.unFocusColor ?? AppColor.primaryColor(context),
                ),
                enabledBorder: _border(
                  color:
                      widget.unFocusColor ??
                      AppColor.textFormBorderColor(context),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                prefixIcon:
                    widget.country != null &&
                        context.locale == const Locale('en')
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          widget.prefixIcon ?? const SizedBox(),
                          TextButton(
                            onPressed: null,
                            // onPressed:
                            //     widget.onCountrySelect != null ? _select : null,
                            child: Text(
                              '${widget.country?.flagEmoji} +${widget.country?.phoneCode}',
                              style:
                                  widget.textStyle ??
                                  AppTextStyle.textFormStyle(context),
                              textDirection: ui.TextDirection.ltr,
                            ),
                          ),
                        ],
                      )
                    : widget.prefixIcon,
                suffixIcon:
                    widget.country != null &&
                        context.locale == const Locale('ar')
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: null,
                            // onPressed:
                            //     widget.onCountrySelect != null ? _select : null,
                            child: Text(
                              '${widget.country?.flagEmoji} +${widget.country?.phoneCode}',
                              style:
                                  widget.textStyle ??
                                  AppTextStyle.textFormStyle(context),
                              textDirection: ui.TextDirection.ltr,
                            ),
                          ),
                          widget.suffixIcon ?? const SizedBox(),
                        ],
                      )
                    : widget.isPassword
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          size: 20,
                          color:
                              widget.passwordColor ??
                              AppColor.hintColor(context),
                        ),
                      )
                    : widget.suffixIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputBorder _border({required Color color}) {
    switch (widget.formFieldBorder) {
      case FormFieldBorder.outLine:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius),
          borderSide: BorderSide(color: color),
        );
      case FormFieldBorder.underLine:
        return UnderlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(color: color),
        );
      case FormFieldBorder.none:
        return InputBorder.none;
    }
  }

  // void _select() {
  //   CountryCodeMethods.pickCountry(
  //     onSelect: (v) {
  //       widget.onCountrySelect?.call(v);
  //     },
  //     context: context,
  //   );
  // }
}
