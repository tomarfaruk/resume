import 'package:flutter/material.dart';

class ScaleAnimationBtn extends StatefulWidget {
  final VoidCallback onTap;
  const ScaleAnimationBtn({
    super.key,
    required this.onTap,
  });

  @override
  State<ScaleAnimationBtn> createState() => _ScaleAnimationBtnState();
}

class _ScaleAnimationBtnState extends State<ScaleAnimationBtn>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
      lowerBound: 0.5,
      reverseDuration: const Duration(seconds: 3),
    );

    _controller.forward();

    animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    _controller.addListener(
      () {
        if (_controller.status == AnimationStatus.completed) {
          Future.delayed(const Duration(seconds: 5))
              .then((value) => _controller.reverse());
        } else if (_controller.status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        onPressed: widget.onTap,
        icon: ScaleTransition(
          scale: animation,
          child: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(animation),
            child: const Icon(
              Icons.remove_red_eye_outlined,
              color: Colors.amber,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
