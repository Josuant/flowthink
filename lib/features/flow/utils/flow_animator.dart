/// Possible values
/// generateFirst(text,id)
/// connect(idA,idB)
/// combine(idA,idB)
/// generateAt(idNew , text, direction, idOld, {bool connected = false})
/// dragAt(id, Direction direction)
///
library;

import 'package:flow/features/flow/presentation/notifiers/grid_screen_notifier.dart';
import 'package:flow/features/flow/utils/enums/flow_block_enums.dart';

abstract class FlowAnimator {
  /// The default delay before starting animations for flow blocks, in seconds.
  static const int defaultDelayMS = 1000;

  static executeList(
      String animationData, GridScreenNotifierAnimator animator) {
    final animations = getAnimations(animationData);
    for (var animation in animations) {
      executeAnimation(animation, animator);
    }
  }

  /// Execute the animation data on the given animator.
  static executeAnimation(
      Map<String, dynamic> animationData, GridScreenNotifierAnimator animator) {
    final animationType = animationData['type'];
    switch (animationType) {
      case 'generateFirst':
        String text = animationData['text'];
        String id = animationData['id'];
        animator.generateFirst(text, id: id);
        break;
      case 'connect':
        String idA = animationData['idA'];
        String idB = animationData['idB'];
        animator.connect(idA, idB);
        break;
      case 'combine':
        String idA = animationData['idA'];
        String idB = animationData['idB'];
        animator.combine(idA, idB);
        break;
      case 'generateAt':
        String idOld = animationData['idOld'];
        String text = animationData['text'];
        Direction direction = animationData['direction'];
        String idNew = animationData['idNew'];
        bool connected = animationData['connected'];
        animator.generateAt(idOld, text, direction,
            idB: idNew, connected: connected);
        break;
      case 'dragAt':
        String id = animationData['id'];
        Direction direction = animationData['direction'];
        animator.dragAt(id, direction);
        break;
      default:
        throw Exception('Invalid animation type');
    }
  }

  /// @param animationData The animation data to be executed. A comma separated list of commands.
  /// Possible values are: 'dragAt', 'generateFirst', 'connect', 'combine', 'generateAt'.
  /// @return The animation data as a list of maps.
  ///
  static List<Map<String, dynamic>> getAnimations(String animationData) {
    final animations = <Map<String, dynamic>>[];
    final animationList = animationData.split('/');
    for (var animation in animationList) {
      // remove spaces from beginning and end
      animation = animation.trim();

      final animationParts = animation.split(',');
      final animationType = animationParts[0];
      switch (animationType) {
        case 'dragAt':
          final id = animationParts[1];
          final direction = stringToEnum(animationParts[2]);
          animations.add({
            'type': 'dragAt',
            'id': id,
            'direction': direction,
          });
          break;
        case 'generateFirst':
          final id = animationParts[1];
          final text = animationParts[2];
          animations.add({
            'type': 'generateFirst',
            'id': id,
            'text': text,
          });
          break;
        case 'connect':
          final idA = animationParts[1];
          final idB = animationParts[2];
          animations.add({
            'type': 'connect',
            'idA': idA,
            'idB': idB,
          });
          break;
        case 'combine':
          final idA = animationParts[1];
          final idB = animationParts[2];
          animations.add({
            'type': 'combine',
            'idA': idA,
            'idB': idB,
          });
          break;
        case 'generateAt':
          final idNew = animationParts[1];
          final text = animationParts[2];
          final direction = stringToEnum(animationParts[3]);
          final idOld = animationParts[4];
          final connected = animationParts[5] == 'true';
          animations.add({
            'type': 'generateAt',
            'idNew': idNew,
            'text': text,
            'direction': direction,
            'idOld': idOld,
            'connected': connected,
          });
          break;
        default:
          throw Exception('Invalid animation type');
      }
    }
    return animations;
  }

  static Direction stringToEnum(String animationPart) {
    return Direction.values.firstWhere((e) => e.name == animationPart);
  }

  // test animationData
  static const String animationData =
      'generateFirst,node1,Start/generateAt,node2,Process 1,right,node1,true/generateAt,node3,Decision,down,node2,true/generateAt,node4,Process 2,right,node3,true/generateAt,node5,Process 3,down,node3,false/generateAt,node6,End,right,node4,true/generateAt,node7,End,down,node5,true/generateAt,node8,Process 4,right,node5,false';
}
