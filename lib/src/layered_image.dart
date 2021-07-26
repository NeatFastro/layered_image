import 'package:flutter/material.dart';

import 'package:layered_image/layered_image.dart';

class LayeredImage extends StatefulWidget {
  LayeredImage({
    Key? key,
    required this.backgroundImageUrl,
    required this.layersImagesUrl,
    this.padding = const EdgeInsets.all(30),
  }) : super(key: key);

  final String backgroundImageUrl;
  final List<String> layersImagesUrl;
  final EdgeInsets padding;

  @override
  _LayeredImageState createState() => _LayeredImageState();
}

class _LayeredImageState extends State<LayeredImage> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  late Tween<Offset> _offsetTween;
  late Animation<Offset> _offsetAnimation;
  late AnimationController _offsetAnimationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.ease),
    );

    _offsetAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _offsetTween = Tween<Offset>(begin: Offset.zero, end: Offset.zero);

    _offsetAnimation = _offsetTween.animate(
      CurvedAnimation(parent: _offsetAnimationController, curve: Curves.ease),
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _animationController.dispose();
    _offsetAnimationController.dispose();
  }

  Offset getPerspectivePointer(Offset offset) {
    final _size = MediaQuery.of(context).size;

    final _screenWidth = _size.width;
    final _screenHeight = _size.height;
    final _centerX = _screenWidth / 2;
    final _centerY = _screenHeight / 2;

    final _perspectivePointer = Offset(
      (_centerX - offset.dx) / 2,
      -((_centerY - offset.dy) / 2),
    );

    return _perspectivePointer;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: widget.padding,
        child: MouseRegion(
          onEnter: _onCursorEnter,
          onHover: _onCursorHover,
          onExit: _onCursorExit,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return AnimatedBuilder(
                animation: _offsetAnimation,
                builder: (context, _) {
                  final _animatedOffset = _offsetAnimation.value * _animation.value;

                  return Transform(
                    alignment: FractionalOffset.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.002)
                      ..rotateY(0.0003 * _animatedOffset.dx)
                      ..rotateX(0.0003 * _animatedOffset.dy),
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 1024,
                        maxHeight: 576,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.3),
                            spreadRadius: 5,
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ImageLayer(
                            imageSrc: widget.backgroundImageUrl,
                            offset: Offset(
                              .03 * _animatedOffset.dx,
                              .03 * _animatedOffset.dy,
                            ),
                          ),
                          for (var i = 0; i < widget.layersImagesUrl.length; i++)
                            ImageLayer(
                              imageSrc: widget.layersImagesUrl[i],
                              offset: Offset(
                                (i * .03) * _animatedOffset.dx,
                                (i * .03) * _animatedOffset.dy,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCursorExit(event) {
    _offsetAnimationController.duration = const Duration(milliseconds: 500);

    _offsetTween.begin = _offsetTween.end;
    _offsetAnimationController.reset();

    _offsetTween.end = Offset.zero;
    _offsetAnimationController.forward();

    _animationController.reverse();
  }

  void _onCursorHover(event) {
    /// This prevents the image from jump instantly from
    /// the offset given by the onEnter event to the offset
    /// of the onHover event (kind of conflit)
    if (_animation.status != AnimationStatus.forward) {
      _offsetAnimationController.duration = Duration.zero;
    }

    _offsetTween.begin = _offsetTween.end;
    _offsetAnimationController.reset();

    _offsetTween.end = getPerspectivePointer(event.position);
    _offsetAnimationController.forward();
  }

  void _onCursorEnter(event) {
    _offsetTween.begin = _offsetTween.end;
    _offsetAnimationController.reset();

    _offsetTween.end = getPerspectivePointer(event.position);
    _offsetAnimationController.forward();

    _animationController.forward();
  }
}
