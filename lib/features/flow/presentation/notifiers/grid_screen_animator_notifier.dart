part of 'package:flow/features/flow/presentation/notifiers/grid_screen_notifier.dart';

class GridScreenNotifierAnimator extends GridScreenNotifier {
  GridScreenNotifierAnimator() : super();

  void drag(
      String id, Offset initialPosition, Offset finalPosition, int durationMS,
      {Function()? onComplete}) {
    final dragAnimationController = BlockAnimationController(
      finalPosition: finalPosition,
      durationMS: durationMS,
      tickerProvider: state.tickerProvider!,
      initialPosition: initialPosition,
    );

    dragAnimationController.startAnimation(
      onUpdate: (position) {
        state.blocksNotifier.setPosition(position, id);
      },
      onComplete: () {
        onDragEnd(id, finalPosition);
        if (onComplete != null) {
          onComplete();
        }
      },
      onBegin: () {
        state.blocksNotifier.setAnimating(true, id);
        state.blocksNotifier.setDragging(true, id);
      },
    );
  }

  void pan(
      String id, Offset initialPosition, Offset finalPosition, int durationMS,
      {Function()? onComplete, Offset? transformedPosition}) {
    if (state.blocksNotifier.isAnimating(id)) {
      return;
    }
    final panAnimationController = BlockAnimationController(
      finalPosition: finalPosition,
      durationMS: durationMS,
      tickerProvider: state.tickerProvider!,
      initialPosition: initialPosition,
    );

    panAnimationController.startAnimation(
      onUpdate: (position) {
        state.blocksNotifier.setTapPosition(position, id);
      },
      onComplete: () {
        onPanEnd(id, finalPosition, tp: transformedPosition);
        if (onComplete != null) {
          onComplete();
        }
      },
      onBegin: () {
        state.blocksNotifier.setAnimating(true, id);
        state.blocksNotifier.setPanUpdating(true, id);
      },
      curve: Curves.fastOutSlowIn,
    );
  }

  void dragAt(String id, Direction direction,
      {Function()? onComplete, double? amount}) {
    FlowBlockState block = state.blocksNotifier.getBlock(id);
    Offset initialPosition = block.position;
    double width = block.entity.width;
    double height = block.entity.height;

    Offset finalPosition =
        _getFinalPosition(initialPosition, direction, width, height);

    FlowBlockState? posiblyCollidingBlock =
        state.blocksNotifier.getBlockByPosition(finalPosition);

    if (posiblyCollidingBlock != null) {
      Direction directionAnother = FlowUtil.getRandomDirection(
          exclude: FlowUtil.getReverseDirection(direction));

      dragAt(
        posiblyCollidingBlock.entity.id,
        directionAnother,
        onComplete: () {
          dragAt(id, direction, onComplete: onComplete);
        },
        amount: amount,
      );
      return;
    }
    drag(id, initialPosition, finalPosition, 500, onComplete: onComplete);
  }

  _getFinalPosition(
      Offset initialPosition, Direction direction, double width, double height,
      {double? amount, double margin = FlowDefaultConstants.flowBlockMargin}) {
    switch (direction) {
      case Direction.up:
        amount ??= -height - margin;
        return Offset(initialPosition.dx, initialPosition.dy + amount);
      case Direction.down:
        amount ??= height + margin;
        return Offset(initialPosition.dx, initialPosition.dy + amount);
      case Direction.left:
        amount ??= -width - margin;
        return Offset(initialPosition.dx + amount, initialPosition.dy);
      case Direction.right:
        amount ??= width + margin;
        return Offset(initialPosition.dx + amount, initialPosition.dy);
    }
  }

  void generate(Offset position, String text, {String? id}) {
    FlowBlockState? posiblyCollidingBlock =
        state.blocksNotifier.getBlockByPosition(position);

    if (posiblyCollidingBlock != null) {
      Direction direction = FlowUtil.getDirectionFromPositions(
          position, posiblyCollidingBlock.position);

      Direction directionAnother = FlowUtil.getRandomDirection(
          exclude: FlowUtil.getReverseDirection(direction));
      dragAt(
        posiblyCollidingBlock.entity.id,
        directionAnother,
        onComplete: () => generate(position, text, id: id),
      );
      return;
    }

    FlowBlock newBlock = FlowBlock.buildDefault(text, position, id: id);
    state.blocksNotifier.addNewBlock(newBlock);
  }

  void connect(String idA, String idB) {
    Offset initialPosition = state.blocksNotifier.getBlock(idA).position;
    Offset positionB = state.blocksNotifier.getBlock(idB).position;
    pan(idA, initialPosition, positionB, 800);
  }

  void combine(String idA, String idB) {
    Offset initialPosition = state.blocksNotifier.getBlock(idA).position;
    Offset positionB = state.blocksNotifier.getBlock(idB).position;
    drag(idA, initialPosition, positionB, 800);
  }

  void generateAt(String idA, String text, Direction direction,
      {String? idB, bool connected = false}) {
    Offset initialPosition = state.blocksNotifier.getBlock(idA).position;
    double width = FlowDefaultConstants.flowBlockWidth;
    double height = FlowDefaultConstants.flowBlockHeight;

    Offset finalPosition =
        _getFinalPosition(initialPosition, direction, width, height);

    if (connected) {
      FlowBlockState? posiblyCollidingBlock =
          state.blocksNotifier.getBlockByPosition(finalPosition);

      if (posiblyCollidingBlock != null) {
        Direction direction = FlowUtil.getDirectionFromPositions(
            finalPosition, posiblyCollidingBlock.position);

        Direction directionAnother = FlowUtil.getRandomDirection(
            exclude: FlowUtil.getReverseDirection(direction));
        dragAt(
          posiblyCollidingBlock.entity.id,
          directionAnother,
          onComplete: () => pan(idA, initialPosition, finalPosition, 800,
              transformedPosition: finalPosition),
        );
        return;
      }

      pan(idA, initialPosition, finalPosition, 800,
          transformedPosition: finalPosition);
    } else {
      generate(finalPosition, text, id: idB);
    }
  }

  void generateFirst(String text, {String? id}) {
    generate(const Offset(1000, 1000), text, id: id);
  }

  @override
  void doubleTapOnScreen(TapDownDetails details) {
    state.blocksNotifier.setAllEditingFalse();
    generate(
        state.transformationController.toScene(details.globalPosition), "New");
  }
}

class BlockAnimationController {
  final Offset initialPosition;
  final Offset finalPosition;
  final int durationMS;
  final TickerProvider tickerProvider;

  BlockAnimationController({
    required this.initialPosition,
    required this.finalPosition,
    required this.durationMS,
    required this.tickerProvider,
  });

  void startAnimation({
    required void Function(Offset position) onUpdate,
    required void Function() onComplete,
    required void Function() onBegin,
    Curve curve = Curves.fastLinearToSlowEaseIn,
  }) {
    final controller = AnimationController(
      vsync: tickerProvider,
      duration: Duration(milliseconds: durationMS),
    );

    final curvedAnimation = CurvedAnimation(
      parent: controller,
      curve: curve,
    );

    final animation = Tween<Offset>(
      begin: initialPosition,
      end: finalPosition,
    ).animate(curvedAnimation);

    controller.addListener(() {
      onUpdate(animation.value);
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
        onComplete();
      }
    });

    onBegin();

    controller.forward();
  }
}
