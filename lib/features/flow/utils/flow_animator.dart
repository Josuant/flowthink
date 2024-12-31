/// Possible values
/// generateFirst(text,id)
/// connect(idA,idB)
/// combine(idA,idB)
/// generateAt(idNew , text, direction, idOld, {bool connected = false})
/// dragAt(id, Direction direction)
///
library;

import 'dart:convert';

import 'package:flow/features/flow/presentation/notifiers/grid_screen_notifier.dart';
import 'package:flow/features/flow/utils/enums/flow_block_enums.dart';

abstract class FlowAnimator {
  /// The default delay before starting animations for flow blocks, in seconds.
  static const int defaultDelayMS = 1000;

  static void executeList(
      String animationData, GridScreenNotifierAnimator animator) {
    final animations = getAnimations(json.decode(animationData));
    if (animations.isNotEmpty) {
      executeListAt(animations, animator, 0);
    }
  }

  static void executeListAt(List<Map<String, dynamic>> animationList,
      GridScreenNotifierAnimator animator, int iterator,
      {int delayMS = defaultDelayMS}) {
    executeAnimation(
      animationList[iterator],
      animator,
      onComplete: () {
        if (iterator + 1 < animationList.length) {
          executeListAt(animationList, animator, iterator + 1,
              delayMS: delayMS);
        }
      },
    );
  }

  /// Execute the animation data on the given animator.
  static executeAnimation(
      Map<String, dynamic> animationData, GridScreenNotifierAnimator animator,
      {Function? onComplete}) {
    final animationType = animationData['type'];
    switch (animationType) {
      case 'generateFirst':
        String text = animationData['text'];
        String id = animationData['id'];
        animator.generateFirst(text, id: id, onComplete: onComplete);
        break;
      case 'connect':
        String idA = animationData['idA'];
        String idB = animationData['idB'];
        animator.connect(idA, idB, onComplete: onComplete);
        break;
      case 'combine':
        String idA = animationData['idA'];
        String idB = animationData['idB'];
        animator.combine(idA, idB, onComplete: onComplete);
        break;
      case 'generateAt':
        String idOld = animationData['idOld'];
        String text = animationData['text'];
        Direction direction = animationData['direction'];
        String idNew = animationData['idNew'];
        bool connected = animationData['connected'];
        animator.generateAt(idOld, text, direction,
            idB: idNew, connected: connected, onComplete: onComplete);
        break;
      case 'dragAt':
        String id = animationData['id'];
        Direction direction = animationData['direction'];
        animator.dragAt(id, direction, onComplete: onComplete);
        break;
      default:
        throw Exception('Invalid animation type');
    }
  }

  /// @param animationData The animation data to be executed. A comma separated list of commands.
  /// Possible values are: 'dragAt', 'generateFirst', 'connect', 'combine', 'generateAt'.
  /// @return The animation data as a list of maps.
  ///
  static List<Map<String, dynamic>> getAnimations(
      Map<String, dynamic> animationData) {
    final animations = <Map<String, dynamic>>[];

    // Verifica si la clave "animationData" existe y es una lista
    if (animationData.containsKey('animationData') &&
        animationData['animationData'] is List) {
      final animationList = animationData['animationData'] as List;

      for (final animation in animationList) {
        // Verifica que cada elemento sea un mapa con las claves esperadas
        if (animation is Map<String, dynamic> &&
            animation.containsKey('type') &&
            animation.containsKey('params')) {
          final animationType = animation['type'];
          final params = animation['params'];

          switch (animationType) {
            case 'dragAt':
              animations.add({
                'type': 'dragAt',
                'id': params['id'],
                'direction': stringToEnum(params['direction']),
              });
              break;
            case 'generateFirst':
              animations.add({
                'type': 'generateFirst',
                'id': params['id'],
                'text': params['text'],
              });
              break;
            case 'connect':
              animations.add({
                'type': 'connect',
                'idA': params['idA'],
                'idB': params['idB'],
              });
              break;
            case 'combine':
              animations.add({
                'type': 'combine',
                'idA': params['idA'],
                'idB': params['idB'],
              });
              break;
            case 'generateAt':
              animations.add({
                'type': 'generateAt',
                'idNew': params['idNew'],
                'text': params['text'],
                'direction': stringToEnum(params['direction']),
                'idOld': params['idOld'],
                'connected': params['connectedTrueOrFalse'] ?? false,
              });
              break;
            default:
              continue;
          }
        }
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
