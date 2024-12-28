/// Defines a set of default constants for flow blocks in the application.
///
/// This abstract class contains static constants that define various
/// dimensions and durations used for flow blocks. These constants
/// can be used throughout the application to maintain consistency in the
/// appearance and behavior of flow blocks.
abstract class FlowDefaultConstants {
  /// The default height of a flow block in logical pixels.
  static const double flowBlockHeight = 55.0;

  /// The default width of a flow block in logical pixels.
  static const double flowBlockWidth = 150.0;

  /// The default margin around a flow block in logical pixels.
  static const double flowBlockMargin = 10.0;

  /// The default padding inside a flow block in logical pixels.
  static const double flowBlockPadding = 10.0;

  /// The default corner radius of a flow block in logical pixels.
  static const double flowBlockCornerRadius = 20.0;

  /// The default selected corner radius of a flow block in logical pixels.
  static const double flowBlockSelectedCornerRadius = 25.0;

  /// The default duration for animations related to flow blocks, in seconds.
  static const double flowBlockAnimationDuration = 0.5;

  /// The default delay before starting animations for flow blocks, in seconds.
  static const double flowBlockAnimationDelay = 0.1;

  /// The default radius of circular elements in a flow block in logical pixels.
  static const flowBlockCircleRadius = 2.0;

  static const lineThickness = 2.0;
}
