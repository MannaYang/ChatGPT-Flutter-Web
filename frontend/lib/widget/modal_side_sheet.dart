import 'package:flutter/material.dart';

/// Displays a Material Side Sheet transitioned from Right side of the screen.
///
/// This function allows for customization of aspects of the Modal Side Sheet.
///
/// This function takes a `body` which is used to build the primary
/// content of the side sheet (typically a widget). Content below the side sheet
/// is dimmed with a [ModalBarrier]. The widget returned by the `body`
/// does not share a context with the location that `showModalSideSheet` is
/// originally called from. Use a [StatefulBuilder] or a custom
/// [StatefulWidget] if the side sheet needs to update dynamically. The
/// `body` argument cannot be null.
///
/// ### Note :
/// `ignoreAppBar` perameter determines that whether to show side sheet beneath the
/// [AppBar] or not. Default value of this perameter is `true`.
/// If this perameter set to `false`, the widget where you are calling[showModalSideSheet]
/// cannot be the direct child of the [Scaffold].
/// You must use a custom [Widget] or Wrap the used widget into [Builder] widget.
///
/// ##
/// `withCloseControll` perameter provide a Close Button on top right corner of the
/// side sheet to manually close the Modal Side Sheet. Default value is true.
/// If provided `false` you need to call [Navigator.of(context).pop()] method to close
/// the side sheet.
///
/// ##
/// `width` perameter gives a Width to the side sheet. For mobile devices default is 60%
/// of the device width and 25% for rest of the devices.
///
/// ## See Also
/// * The `context` argument is used to look up the [Navigator] for the
/// side sheet. It is only used when the method is called. Its corresponding widget
/// can be safely removed from the tree before the side sheet is closed.
///
/// * The `useRootNavigator` argument is used to determine whether to push the
/// side sheet to the [Navigator] furthest from or nearest to the given `context`.
/// By default, `useRootNavigator` is `true` and the side sheet route created by
/// this method is pushed to the root navigator.
///
/// * If the application has multiple [Navigator] objects, it may be necessary to
/// call `Navigator.of(context, rootNavigator: true).pop(result)` to close the
/// side sheet rather than just `Navigator.pop(context, result)`.
///
/// * The `barrierDismissible` argument is used to determine whether this route
/// can be dismissed by tapping the modal barrier. This argument defaults
/// to false. If `barrierDismissible` is true, a non-null `barrierLabel` must be
/// provided.
///
/// * The `barrierLabel` argument is the semantic label used for a dismissible
/// barrier. This argument defaults to `null`.
///
/// * The `barrierColor` argument is the color used for the modal barrier. This
/// argument defaults to `Color(0x80000000)`.
///
/// * The `transitionDuration` argument is used to determine how long it takes
/// for the route to arrive on or leave off the screen. This argument defaults
/// to 300 milliseconds.
///
/// * The `transitionBuilder` argument is used to define how the route arrives on
/// and leaves off the screen. By default, the transition is a linear fade of
/// the page's contents.
///
/// * The `routeSettings` will be used in the construction of the side sheet's route.
/// See [RouteSettings] for more details.
///
/// * Returns a [Future] that resolves to the value (if any) that was passed to
/// [Navigator.pop] when the side sheet was closed.
///
/// ##
/// * For more info on Modal Side Sheet see also : https://material.io/components/sheets-side#modal-side-sheet

Future<T?> showModalSideSheet<T extends Object?>(
    {required BuildContext context,
    required Widget body,
    bool barrierDismissible = false,
    Color barrierColor = const Color(0x80000000),
    double? width,
    double elevation = 8.0,
    Duration transitionDuration = const Duration(milliseconds: 300),
    String? barrierLabel = "Side Sheet",
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    bool withCloseControll = true,
    bool ignoreAppBar = true}) {
  var of = MediaQuery.of(context);
  var platform = Theme.of(context).platform;
  if (width == null) {
    if (platform == TargetPlatform.android || platform == TargetPlatform.iOS) {
      width = of.size.width * 0.6;
    } else {
      width = of.size.width / 4;
    }
  }
  double exceptionalheight = !ignoreAppBar
      ? Scaffold.of(context).hasAppBar
          ? Scaffold.of(context).appBarMaxHeight!
          : 0
      : 0;
  double height = of.size.height - exceptionalheight;
  assert(!barrierDismissible || barrierLabel != null);
  return showGeneralDialog(
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    transitionDuration: transitionDuration,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    context: context,
    pageBuilder: (BuildContext context, _, __) {
      return Align(
        alignment: Alignment.bottomRight,
        child: Material(
            elevation: elevation,
            child: SizedBox(
              width: width,
              height: height,
              child: withCloseControll
                  ? Stack(
                      children: [
                        body,
                        const Positioned(top: 5, right: 5, child: CloseButton())
                      ],
                    )
                  : body,
            )),
      );
    },
    transitionBuilder: (_, animation, __, child) {
      return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(animation),
          child: child);
    },
  );
}
