import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ScrollingText extends StatefulWidget {
  final String text;

  // add callback function that takes in a context
  final void Function(BuildContext) onTapCallback;

  const ScrollingText({
    super.key,
    required this.text,
    required this.onTapCallback,
  });

  @override
  State<ScrollingText> createState() => _ScrollingTextState();
}

class _ScrollingTextState extends State<ScrollingText> {
  final _scrollController = ScrollController();
  Timer? _timer;
  bool _running = false;
  bool _paused = false;
  bool get _available => mounted && _scrollController.hasClients;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _initScroller(timeStamp);
    });
  }

  Future<void> _initScroller(_) async {
    _setTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _setTimer() {
    _timer?.cancel();

    _running = false;

    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_paused) return;

      if (!_available) {
        timer.cancel();
        return;
      }

      if (!_running) _run();
    });
  }

  Future<void> _run() async {
    _running = true;
    await _animate();
    _running = false;
  }

  Future<void> _animate() async {
    if (_paused) return;

    if (!_available) return;

    final ScrollPosition position = _scrollController.position;
    final bool needsScrolling = position.maxScrollExtent > 0;
    if (!needsScrolling) {
      return;
    }

    if (!_available) return;
    await _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 4),
      curve: Curves.linear,
    );

    await Future.delayed(const Duration(seconds: 1, milliseconds: 500));

    if (!_available) return;
    await _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.linear,
    );

    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  void didUpdateWidget(ScrollingText oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return GestureDetector(
      onLongPressEnd: (details) => {
        _paused = false,
      },
      onLongPressCancel: () => {
        _paused = false,
      },
      onHorizontalDragCancel: () => {
        _paused = false,
      },
      onTap: () => {
        widget.onTapCallback(context),
      },
      onTapDown: (details) => {
        _paused = true,
      },
      onForcePressEnd: (details) => {
        _paused = false,
      },
      onTapUp: (details) => {
        _paused = false,
      },
      onTapCancel: () => {
        _paused = false,
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Text(
          widget.text,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
