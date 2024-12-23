import 'package:flow/features/flow/domain/entities/flow_block_state.dart';
import 'package:flow/features/flow/presentation/flow_styles.dart';
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
    const circleRadius = 15.0;
    final width = anotherBlock.entity.width;
    final height = anotherBlock.entity.height;

    return Transform.translate(
      offset: anotherBlockPos + const Offset(5, 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(circleRadius),
        child: Transform.translate(
          offset: -anotherBlockPos + dragPosition,
          child: Stack(
            children: [
              Container(
                width: width,
                height: height,
                decoration:
                    FlowStyles.buldBoxDecoration(true, false, false, 10.0),
              ),
              Transform.translate(
                offset: (-(dragPosition - anotherBlockPos) +
                        Offset(width - iconSize, height - iconSize)) /
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
      ),
    );
  }
}
