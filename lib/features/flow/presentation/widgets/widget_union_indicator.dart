import 'package:flow/features/flow/domain/entities/flow_block_state.dart';
import 'package:flow/features/flow/presentation/flow_styles.dart';
import 'package:flow/features/flow/utils/constants/flow_default_constants.dart';
import 'package:flutter/material.dart';

class UnionIndicator extends StatelessWidget {
  final BuildContext context;
  final FlowBlockState anotherBlock;
  final Offset dragPosition;

  const UnionIndicator({
    required this.context,
    required this.anotherBlock,
    required this.dragPosition,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final anotherBlockPos = anotherBlock.position;
    const iconSize = 20.0;
    const cornerRadius = FlowDefaultConstants.flowBlockCornerRadius;
    final width = anotherBlock.entity.width;
    final height = anotherBlock.entity.height;

    return Positioned(
      left: anotherBlockPos.dx - width / 2 + 5,
      top: anotherBlockPos.dy - height / 2 + 5,
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cornerRadius),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 50),
              curve: Curves.easeInOut,
              left: dragPosition.dx - anotherBlockPos.dx,
              top: dragPosition.dy - anotherBlockPos.dy,
              child: Container(
                width: width,
                height: height,
                decoration: FlowStyles.buldBoxDecoration(
                  true,
                  false,
                  false,
                  FlowDefaultConstants.flowBlockSelectedCornerRadius,
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 50),
              curve: Curves.easeInOut,
              left:
                  (dragPosition.dx - anotherBlockPos.dx + width - iconSize) / 2,
              top: (dragPosition.dy - anotherBlockPos.dy + height - iconSize) /
                  2,
              child: const Icon(
                Icons.add,
                size: iconSize,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
