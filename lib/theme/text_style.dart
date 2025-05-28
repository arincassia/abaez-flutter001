import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle get heading3xl {
    return GoogleFonts.inter(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    );
  }

  static TextStyle get heading2xl {
    return GoogleFonts.inter(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    );
  }

  static TextStyle get headingXl {
    return GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    );
  }

  static TextStyle get headingLg {
    return GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
  }

  static TextStyle get heading18 {
    return GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
  }

  static TextStyle get headingMd {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }

  static TextStyle get headingSm {
    return GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
  }

  // Body styles (Body/lg)
  static TextStyle get bodyLg {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );
  }

  static TextStyle get bodyLgUnderline {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
      decoration: TextDecoration.underline,
    );
  }

  static TextStyle get bodyLgMedium {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500, // Medium weight
      color: Colors.black,
    );
  }

  static TextStyle get bodyLgSemiBold {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
  }

  // Body styles (Body/md)
  static TextStyle get bodyMd {
    return GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );
  }

  static TextStyle get bodyMdUnderline {
    return GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Colors.black,
      decoration: TextDecoration.underline,
    );
  }

  static TextStyle get bodyMdMedium {
    return GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
  }

  static TextStyle get bodyMdSemiBold {
    return GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
  }

  static TextStyle get bodyMdBold {
    return GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
  }

  // Body styles (Body/sm)
  static TextStyle get bodySm {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );
  }

  static TextStyle get bodySmUnderline {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Colors.black,
      decoration: TextDecoration.underline,
    );
  }

  static TextStyle get bodySmMedium {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
  }

  static TextStyle get bodySmMediumUnderline {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.black,
      decoration: TextDecoration.underline,
    );
  }

  static TextStyle get bodySmSemiBold {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
  }

  // Body styles (Body/xs)
  static TextStyle get bodyXs {
    return GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );
  }

  static TextStyle get bodyXsSemiBold {
    return GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
  }
}