import 'package:flutter/material.dart';

class ResponsiveUtils {
  /// Device size breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  static const double largeDesktopBreakpoint = 1440;

  /// Determines if the current screen size is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <= mobileBreakpoint;
  }

  /// Determines if the current screen size is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > mobileBreakpoint && width <= tabletBreakpoint;
  }

  /// Determines if the current screen size is desktop or web
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > tabletBreakpoint;
  }

  /// Determines if the current screen size is large desktop
  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > largeDesktopBreakpoint;
  }

  /// Returns the appropriate value based on screen size
  static T responsiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    required T desktop,
    T? largeDesktop,
  }) {
    final width = MediaQuery.of(context).size.width;

    if (width > largeDesktopBreakpoint && largeDesktop != null) {
      return largeDesktop;
    } else if (width > tabletBreakpoint) {
      return desktop;
    } else if (width > mobileBreakpoint && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  /// Returns the appropriate padding based on screen size
  static EdgeInsets responsivePadding(BuildContext context) {
    return responsiveValue<EdgeInsets>(
      context: context,
      mobile: const EdgeInsets.all(8.0),
      tablet: const EdgeInsets.all(10.0),
      desktop: const EdgeInsets.all(12.0),
    );
  }

  /// Returns the number of grid columns based on screen size
  static int gridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width > largeDesktopBreakpoint) {
      return 4;
    } else if (width > desktopBreakpoint) {
      return 3;
    } else if (width > tabletBreakpoint) {
      return 2;
    } else if (width > mobileBreakpoint) {
      return 2;
    }
    return 1;
  }

  /// Returns the appropriate font size based on screen size
  static double responsiveFontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    required double desktop,
  }) {
    return responsiveValue<double>(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.1,
      desktop: desktop,
    );
  }

  /// Returns the appropriate icon size based on screen size
  static double responsiveIconSize(BuildContext context) {
    return responsiveValue<double>(
      context: context,
      mobile: 20,
      tablet: 22,
      desktop: 24,
    );
  }

  /// Returns the appropriate aspect ratio for item grid cells
  static double gridAspectRatio(BuildContext context) {
    if (isDesktop(context)) {
      return 1.6;
    } else if (isTablet(context)) {
      return 1.4;
    }
    return 2.2; // Mobile
  }

  /// Returns the appropriate height for controls like buttons
  static double controlHeight(BuildContext context) {
    return responsiveValue<double>(
      context: context,
      mobile: 30,
      tablet: 30,
      desktop: 32,
    );
  }

  /// Returns the appropriate floating button size
  static Size floatingButtonSize(BuildContext context) {
    if (isDesktop(context)) {
      return const Size(double.infinity, 56);
    } else if (isTablet(context)) {
      return const Size(double.infinity, 52);
    }
    return const Size(double.infinity, 48);
  }

  /// Returns the content width percentage based on screen size
  static double contentWidthPercentage(BuildContext context) {
    if (isLargeDesktop(context)) {
      return 0.85; // 85% of screen width
    } else if (isDesktop(context)) {
      return 0.9; // 90% of screen width
    } else if (isTablet(context)) {
      return 0.95; // 95% of screen width
    }
    return 1.0; // 100% of screen width for mobile
  }

  /// Creates a responsive layout with optional sidebar and content
  static Widget responsiveLayout({
    required BuildContext context,
    required Widget mobileLayout,
    Widget? tabletLayout,
    required Widget desktopLayout,
  }) {
    if (isDesktop(context)) {
      return desktopLayout;
    } else if (isTablet(context) && tabletLayout != null) {
      return tabletLayout;
    }
    return mobileLayout;
  }

  /// Creates standard spacing based on screen size
  static double standardSpacing(BuildContext context) {
    return responsiveValue<double>(
      context: context,
      mobile: 8,
      tablet: 12,
      desktop: 16,
    );
  }

  /// Returns flex ratio for main content vs sidebar based on screen size
  static List<int> contentSidebarRatio(BuildContext context) {
    if (isLargeDesktop(context)) {
      return [4, 1]; // Main content takes 4/5, sidebar takes 1/5
    } else if (isDesktop(context)) {
      return [3, 1]; // Main content takes 3/4, sidebar takes 1/4
    }
    return [2, 1]; // More balanced for smaller screens
  }

  /// Creates a responsive scaffold with optional appBar, body, and floatingActionButton
  static Widget responsiveScaffold({
    required BuildContext context,
    required PreferredSizeWidget appBar,
    required Widget body,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    Widget? bottomNavigationBar,
  }) {
    return Scaffold(
      appBar: appBar,
      body: Container(
        width: double.infinity,
        padding: responsiveValue<EdgeInsets>(
          context: context,
          mobile: EdgeInsets.zero,
          tablet: const EdgeInsets.symmetric(horizontal: 16),
          desktop: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
        ),
        child: body,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

extension ResponsiveContext on BuildContext {
  bool get isMobile => ResponsiveUtils.isMobile(this);
  bool get isTablet => ResponsiveUtils.isTablet(this);
  bool get isDesktop => ResponsiveUtils.isDesktop(this);
  bool get isLargeDesktop => ResponsiveUtils.isLargeDesktop(this);

  double get responsiveIconSize => ResponsiveUtils.responsiveIconSize(this);
  double get standardSpacing => ResponsiveUtils.standardSpacing(this);
  EdgeInsets get responsivePadding => ResponsiveUtils.responsivePadding(this);
  int get gridColumns => ResponsiveUtils.gridColumns(this);
  double get gridAspectRatio => ResponsiveUtils.gridAspectRatio(this);
  double get controlHeight => ResponsiveUtils.controlHeight(this);
  Size get floatingButtonSize => ResponsiveUtils.floatingButtonSize(this);
  double get contentWidthPercentage =>
      ResponsiveUtils.contentWidthPercentage(this);
  List<int> get contentSidebarRatio =>
      ResponsiveUtils.contentSidebarRatio(this);

  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    required T desktop,
    T? largeDesktop,
  }) {
    return ResponsiveUtils.responsiveValue(
      context: this,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  double responsiveFontSize({
    required double mobile,
    double? tablet,
    required double desktop,
  }) {
    return ResponsiveUtils.responsiveFontSize(
      this,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}
