import 'dart:ui';

import 'package:flow/features/flow/utils/enums/flow_connection_direction.dart';

/// Represents a connection between two flows in a flow diagram.
///
/// This class encapsulates the information needed to define a connection
/// between two flows, including their identifiers and the direction of
/// the connection for each flow.
class FlowConnection {
  /// The identifier of the first flow in the connection.
  final String flowIdA;

  /// The identifier of the second flow in the connection.
  final String flowIdB;

  /// The direction of the connection from the perspective of the first flow.
  final FlowConnectionDirection flowConnectionDirectionA;

  /// The direction of the connection from the perspective of the second flow.
  final FlowConnectionDirection flowConnectionDirectionB;

  /// The color of the connection line.
  final Color color;

  /// Whether the connection line is dotted.
  final bool isDotted;

  /// The thickness of the connection line.
  final double thickness;

  /// The corner radius of the connection line.
  final double cornerRadius;

  /// The label of the connection.
  final String label;

  // The label positioning relative to the connection line.
  final double labelPosition;

  /// Creates a new [FlowConnection] instance.
  ///
  /// [flowIdA] and [flowIdB] are required parameters representing the
  /// identifiers of the two flows being connected.
  ///
  /// [flowConnectionDirectionA] and [flowConnectionDirectionB] are optional
  /// parameters that specify the direction of the connection for each flow.
  /// They default to [FlowConnectionDirection.nearest] if not provided.
  FlowConnection(
      {required this.flowIdA,
      required this.flowIdB,
      required this.flowConnectionDirectionA,
      required this.flowConnectionDirectionB,
      required this.color,
      required this.isDotted,
      required this.thickness,
      required this.cornerRadius,
      required this.label,
      required this.labelPosition});
}
