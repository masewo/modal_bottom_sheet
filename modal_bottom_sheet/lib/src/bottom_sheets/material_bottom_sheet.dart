import 'dart:async';

import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const double _willPopThreshold = 0.8;

/// Shows a modal material design bottom sheet.
Future<T?> showMaterialModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  Color? barrierColor,
  bool bounce = false,
  bool expand = false,
  AnimationController? secondAnimation,
  Curve? animationCurve,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  ValueNotifier<bool>? enableDragNotifier,
  Duration? duration,
  RouteSettings? settings,
  double? closeProgressThreshold,
  double willPopThreshold = _willPopThreshold,
  VoidCallback? onClosing,
}) async {
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));
  final result = await Navigator.of(context, rootNavigator: useRootNavigator)
      .push(ModalSheetRoute<T>(
    builder: builder,
    closeProgressThreshold: closeProgressThreshold,
    willPopThreshold: willPopThreshold,
    containerBuilder: _materialContainerBuilder(
      context,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      theme: Theme.of(context),
    ),
    secondAnimationController: secondAnimation,
    bounce: bounce,
    expanded: expand,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    isDismissible: isDismissible,
    modalBarrierColor: barrierColor,
    enableDrag: enableDrag,
    enableDragNotifier: enableDragNotifier,
    animationCurve: animationCurve,
    duration: duration,
    settings: settings,
    onClosing: onClosing,
  ));
  return result;
}

//Default container builder is the Material Appearance
WidgetWithChildBuilder _materialContainerBuilder(BuildContext context,
    {Color? backgroundColor,
    double? elevation,
    ThemeData? theme,
    Clip? clipBehavior,
    ShapeBorder? shape}) {
  final bottomSheetTheme = Theme.of(context).bottomSheetTheme;
  final color = backgroundColor ??
      bottomSheetTheme.modalBackgroundColor ??
      bottomSheetTheme.backgroundColor;
  final effectiveElevation = elevation ?? bottomSheetTheme.elevation ?? 0.0;
  final effectiveShape = shape ?? bottomSheetTheme.shape;
  final effectiveClipBehavior =
      clipBehavior ?? bottomSheetTheme.clipBehavior ?? Clip.none;

  Widget result(context, animation, child) => Material(
        color: color,
        elevation: effectiveElevation,
        shape: effectiveShape,
        clipBehavior: effectiveClipBehavior,
        child: child,
      );
  if (theme != null) {
    return (context, animation, child) =>
        Theme(data: theme, child: result(context, animation, child));
  } else {
    return result;
  }
}
