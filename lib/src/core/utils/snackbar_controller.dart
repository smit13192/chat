import 'dart:async';

import 'package:chat/src/config/constant/app_color.dart';
import 'package:chat/src/config/router/router.dart';
import 'package:chat/src/core/widgets/custom_text.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

enum TransitionType { up, down }

class SnackbarMessage extends Equatable {
  final String message;

  const SnackbarMessage({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class SnackbarController {
  static final List<SnackbarMessage> _messages = [];
  static final List<OverlayEntry> _entries = [];

  static void showSnackbar({
    BuildContext? context,
    String message = '',
    IconData icon = Icons.info,
    Widget Function(BuildContext context, void Function() dismiss)? builder,
    Color iconColor = AppColor.whiteColor,
    Color backgroundColor = AppColor.blackColor,
    TransitionType transitionType = TransitionType.down,
    double top = 30,
    double bottom = 20,
    Duration duration = const Duration(seconds: 5),
    bool isClose = true,
  }) {
    final snackbarMessage = SnackbarMessage(message: message);
    _messages.add(snackbarMessage);

    final overlay = context != null
        ? Overlay.of(context)
        : AppRouterNavigationKey.navigatorKey.currentState!.overlay!;
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => _SnackbarOverlay(
        message: message,
        icon: icon,
        iconColor: iconColor,
        builder: builder,
        backgroundColor: backgroundColor,
        onDismiss: () => _removeEntry(overlayEntry),
        duration: duration,
        transitionType: transitionType,
        top: top,
        bottom: bottom,
        isClose: isClose,
      ),
    );

    _entries.add(overlayEntry);
    overlay.insert(overlayEntry);

    if (duration != Duration.zero) {
      Future.delayed(duration, () {
        if (overlayEntry.mounted) {
          overlayEntry.remove();
          final index = _entries.indexOf(overlayEntry);
          _entries.remove(overlayEntry);
          if (index >= 0 && index < _messages.length) {
            _messages.removeAt(index);
          }
        }
      });
    }
  }

  static void _removeEntry(OverlayEntry entry) {
    if (_entries.contains(entry)) {
      final index = _entries.indexOf(entry);
      if (index >= 0 && index < _messages.length) {
        _messages.removeAt(index);
      }
      entry.remove();
      _entries.remove(entry);
      _updatePositions();
    }
  }

  static void _updatePositions() {
    for (var i = 0; i < _entries.length; i++) {
      _entries[i].markNeedsBuild();
    }
  }

  static void dismissAll() {
    while (_entries.isNotEmpty) {
      final entry = _entries.first;
      entry.remove();
      _entries.remove(entry);
    }
    _messages.clear();
  }
}

class _SnackbarOverlay extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color iconColor;
  final Widget Function(BuildContext context, void Function() dismiss)? builder;
  final Color backgroundColor;
  final VoidCallback onDismiss;
  final Duration duration;
  final TransitionType transitionType;
  final double top;
  final double bottom;
  final bool isClose;

  const _SnackbarOverlay({
    required this.message,
    required this.icon,
    required this.iconColor,
    this.builder,
    required this.backgroundColor,
    required this.onDismiss,
    required this.duration,
    required this.transitionType,
    required this.top,
    required this.bottom,
    required this.isClose,
  });

  @override
  State<_SnackbarOverlay> createState() => _SnackbarOverlayState();
}

class _SnackbarOverlayState extends State<_SnackbarOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.transitionType == TransitionType.down
          ? const Offset(0.0, 1.0)
          : const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();

    if (widget.duration != Duration.zero) {
      timer =
          Timer(widget.duration - const Duration(milliseconds: 300), _dismiss);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  void _dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: widget.transitionType == TransitionType.down ? 0 : null,
      top: widget.transitionType == TransitionType.up ? 0 : null,
      right: 0,
      left: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            onVerticalDragEnd: _onVerticalDrag,
            child: Container(
              decoration: BoxDecoration(
                color: widget.backgroundColor,
              ),
              child: SafeArea(
                top: widget.transitionType == TransitionType.up ? true : false,
                bottom:
                    widget.transitionType == TransitionType.down ? true : false,
                child: widget.builder?.call(context, _dismiss) ??
                    Material(
                      color: Colors.transparent,
                      child: ListTile(
                        minLeadingWidth: 0,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            widget.icon,
                            color: widget.iconColor,
                            size: 25,
                          ),
                        ),
                        title: CustomText(
                          widget.message,
                          color: AppColor.whiteColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          color: AppColor.whiteColor,
                          onPressed: _dismiss,
                        ),
                      ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onVerticalDrag(DragEndDetails details) {
    if (details.primaryVelocity != null &&
        details.primaryVelocity! > 100 &&
        widget.transitionType == TransitionType.down) {
      _dismiss();
    }
    if (details.primaryVelocity != null &&
        details.primaryVelocity! <= -100 &&
        widget.transitionType == TransitionType.up) {
      _dismiss();
    }
  }
}
