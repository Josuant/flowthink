import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

import 'services/openai_service.dart';
import 'features/flow/utils/enums/flow_block_type.dart';
import 'features/flow/utils/flow_util.dart';
import 'core/widgets/animated_dashed_line.dart';
import 'features/flow/presentation/widgets/widget_flow_container.dart';
import 'core/widgets/widget_trash.dart';
import 'core/widgets/xml_input.dart';
import 'features/flow/presentation/flow_styles.dart';
import 'core/widgets/grid/grid_display.dart';
import 'core/widgets/grid/grid_manager.dart';

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

/* void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => GridManager(
            cellWidth: 20.0,
            cellHeight: 20.0,
            screenSize: const Size(
                0, 0), // Tamaño inicial (puedes ajustarlo dinámicamente)
          ),
      child: const MyApp()));
} */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const GridScreen();
  }
}

class GridScreen extends StatefulWidget {
  const GridScreen({super.key});

  @override
  State<GridScreen> createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  final ValueNotifier<List<Map<String, dynamic>>> activeWidgetsNotifier =
      ValueNotifier<List<Map<String, dynamic>>>([]);
  final List<ValueNotifier<bool>> _editingNotifiers = [];
  List<Map<String, dynamic>> _widgetsData = [];
  final List<int> _erasedWidgets = [];
  final double flowProcessWidth = 150.0;
  final double flowProcessHeight = 60.0;
  final double trashSize = 70.0;
  final double trashExpandedSize = 140.0;
  final int _deletedDurationMS = 200;
  int? _collisionIndex;
  Offset _tapPosition = Offset.zero;
  final ValueNotifier<bool> _isOnAnimation = ValueNotifier<bool>(false);
  bool _isDragging = false;
  Offset _trashInitialPosition = Offset.zero;
  late OpenAIService _openAIService;
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    // Inicializa con un widget de tipo "start"
    _addWidget("Start Block", FlowBlockType.start, const Offset(100, 100));
    _updateActiveWidgets();
  }

  @override
  void dispose() {
    _openAIService.disconnect();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.isNotEmpty) {
      setState(() {
        _messages.add('Tú: $text');
      });
      _openAIService.sendMessage(text);
    }
  }

  void _addWidget(String text, FlowBlockType type, Offset position) {
    setState(() {
      _editingNotifiers.add(ValueNotifier<bool>(false));
      _widgetsData.add({
        'id': _widgetsData.length,
        'text': text,
        'type': type,
        'position': position,
        'width': flowProcessWidth,
        'height': flowProcessHeight,
        'cornerRadius': type == FlowBlockType.decision ? 0.0 : 15.0,
        'circleRadius': 10.0,
        'connections': List<int>.empty(),
        'isDeleted': false,
      });
      _updateActiveWidgets();
    });
  }

  int getElementAt(List<List<int>> grid, int row, int col) {
    return grid[row][col];
  }

  List<Offset> _getPositions(int firstWidgetIndex, int secondWidgetindex) {
    Offset startPosition = Offset(
        _widgetsData[firstWidgetIndex]['position'].dx +
            _widgetsData[firstWidgetIndex]['width'] / 2,
        _widgetsData[firstWidgetIndex]['position'].dy +
            _widgetsData[firstWidgetIndex]['height'] / 2);

    Offset finalPosition = Offset(
        _widgetsData[secondWidgetindex]['position'].dx +
            _widgetsData[secondWidgetindex]['width'] / 2,
        _widgetsData[secondWidgetindex]['position'].dy +
            _widgetsData[secondWidgetindex]['height'] / 2);

    return [startPosition, finalPosition];
  }

  void _addConnection(int firstWidgetIndex, int secondWidgetindex) {
    _widgetsData[firstWidgetIndex]['connections'] =
        List<int>.from(_widgetsData[firstWidgetIndex]['connections'])
          ..add(secondWidgetindex);
  }

  void _updateActiveWidgets() {
    setState(() {
      activeWidgetsNotifier.value = _widgetsData
          .asMap()
          .entries
          .where((entry) => !_erasedWidgets.contains(entry.key))
          .map((entry) => entry.value)
          .toList();
    });
  }

  void _detectCollisionWithDraggingWidget(
      int draggingWidgetIndex,
      Offset draggingWidgetPosition,
      double draggingWidgetWidth,
      double draggingWidgetHeight) {
    for (int i = 0; i < _widgetsData.length; i++) {
      // Verifica si el índice del widget está en _erasedWidgets
      if (_erasedWidgets.contains(i)) {
        continue;
      }
      if (i == draggingWidgetIndex) {
        continue;
      }

      // Extrae los datos del widget actual
      final widgetData = _widgetsData[i];
      final Offset widgetPosition = widgetData['position'];
      final double widgetWidth = widgetData['width'];
      final double widgetHeight = widgetData['height'];

      // Calcula los límites del widget actual
      final double leftA = widgetPosition.dx;
      final double rightA = widgetPosition.dx + widgetWidth;
      final double topA = widgetPosition.dy;
      final double bottomA = widgetPosition.dy + widgetHeight;

      // Calcula los límites del widget que se arrastra
      final double leftB = draggingWidgetPosition.dx;
      final double rightB = draggingWidgetPosition.dx + draggingWidgetWidth;
      final double topB = draggingWidgetPosition.dy;
      final double bottomB = draggingWidgetPosition.dy + draggingWidgetHeight;

      // Verifica si los dos rectángulos se solapan (colisión)
      if (leftA < rightB &&
          rightA > leftB &&
          topA < bottomB &&
          bottomA > topB &&
          _isIndexValid(i)) {
        _collisionIndex = i;
        return; // Devuelve el índice del widget con el que colisionó
      }
    }
    _collisionIndex = null; // No se detectó colisión
  }

  bool _isIndexValid(int index) {
    return index >= 0 &&
        index < _widgetsData.length &&
        !_erasedWidgets.contains(index);
  }

  void _combineWidgets(int indexA, int indexB) {
    // Validar índices
    if (!_isIndexValid(indexA) || !_isIndexValid(indexB) || indexA == indexB) {
      return;
    }

    // Extraer widgets
    final widgetA = _widgetsData[indexA];
    final widgetB = _widgetsData[indexB];

    setState(() {
      // Combinar texto
      widgetA['text'] = _combineWidgetTexts(widgetA['text'], widgetB['text']);

      // Transferir conexiones de widgetB a widgetA
      final connectionsA = Set<int>.from(widgetA['connections']);
      final connectionsB = Set<int>.from(widgetB['connections']);

      widgetA['connections'] = connectionsA.union(connectionsB).toList();

      // Actualizar referencias en otros widgets
      for (var widget in _widgetsData) {
        if (widget['connections'].contains(widgetB['id'])) {
          widget['connections'].remove(widgetB['id']);
          if (!widget['connections'].contains(widgetA['id'])) {
            widget['connections'].add(widgetA['id']);
          }
        }
      }

      // Actualizar posición de widgetA si es necesario
      widgetA['position'] = widgetB['position'];

      // Marcar widgetB como eliminado
      _erasedWidgets.add(widgetB['id']);
    });
  }

  void startAnimation(int durationMS) {
    _isOnAnimation.value = true;
    Future.delayed(Duration(milliseconds: durationMS), () {
      _isOnAnimation.value = false;
    });
  }

// Método que combina los textos de dos widgets
  String _combineWidgetTexts(String textA, String textB) {
    return '$textA + $textB'; // Combina los textos con un salto de línea, ajusta si necesario
  }

  void chekForDeletedWidgets() {
    setState(() {
      // Elimina los elementos de `_widgetsData` según `_erasedWidgets`
      int index = 0;
      _widgetsData.removeWhere((element) {
        final shouldRemove = _erasedWidgets.contains(index);
        index++;
        return shouldRemove;
      });

      // Filtra `_erasedWidgets` para eliminar los índices que ya no existen
      _erasedWidgets.clear();
    });
  }

  AnimatedDashedLine _buildLine(Offset startPosition, Offset finalPosition) {
    return AnimatedDashedLine(
      isPreview: false,
      start: startPosition,
      end: finalPosition,
      color: Colors.purple,
    );
  }

  List<AnimatedDashedLine> _getAllLines() {
    List<AnimatedDashedLine> lines = [];

    for (int i = 0; i < activeWidgetsNotifier.value.length; i++) {
      int firstIndex = activeWidgetsNotifier.value[i]['id'];
      List<int> connections = activeWidgetsNotifier.value[i]['connections'];

      for (int connectionIndex in connections) {
        if (_erasedWidgets.contains(connectionIndex) ||
            _erasedWidgets.contains(firstIndex)) {
          continue;
        }
        List<Offset> positions = _getPositions(firstIndex, connectionIndex);
        lines.add(_buildLine(positions[0], positions[1]));
      }
    }

    return lines;
  }

  void _handleTapOutside() {
    // Desactiva el modo de edición de todos los widgets
    for (var notifier in _editingNotifiers) {
      notifier.value = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _trashInitialPosition = Offset(
        MediaQuery.of(context).size.width / 2 - trashSize / 2,
        MediaQuery.of(context).size.height - 150);

    final gridManager = provider.Provider.of<GridManager>(context);
    // Actualiza el tamaño de la pantalla si no está configurado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;
      if (gridManager.screenSize != screenSize) {
        gridManager.updateGrid(
            screenSize, gridManager.cellWidth, gridManager.cellHeight);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FF),
      body: Stack(
        children: [
          GestureDetector(
            onTap: _handleTapOutside,
            behavior: HitTestBehavior.translucent,
            child: Container(),
          ),
          Stack(
            children: [
              InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(
                    double.infinity), // Permite movimiento sin límites
                minScale: 0.5, // Escala mínima de zoom
                maxScale: 3.0, // Escala máxima de zoom
                constrained:
                    false, // Permite expandirse más allá del tamaño original
                child: SizedBox(
                  width: MediaQuery.of(context).size.width *
                      2, // Ancho personalizado
                  height: MediaQuery.of(context).size.height *
                      2, // Alto personalizado
                  child: Stack(
                    children: [
                      const GridDisplay(),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: _handleTapOutside,
                        child: Stack(children: _getAllLines()),
                      ),
                      ValueListenableBuilder<List<Map<String, dynamic>>>(
                          valueListenable: activeWidgetsNotifier,
                          builder: (context, activeWidgets, child) {
                            return Stack(
                              children: activeWidgets.map((data) {
                                final id = data['id'];
                                return FlowBlock(
                                  key: ValueKey(id),
                                  text: data['text'],
                                  cornerRadius: data['cornerRadius'],
                                  width: data['width'],
                                  height: data['height'],
                                  position: data['position'],
                                  deletedDuration: _deletedDurationMS,
                                  isEditingNotifier: _editingNotifiers[id],
                                  startEditing: _editingNotifiers[id].value,
                                  type: data['type'],
                                  isOnAnimation: _isOnAnimation,
                                  isDeleted: data['isDeleted'],
                                  anotherBlockPosition:
                                      _collisionIndex != null &&
                                              _collisionIndex != id &&
                                              _isIndexValid(_collisionIndex!)
                                          ? _widgetsData[_collisionIndex!]
                                              ['position']
                                          : const Offset(0, 0),
                                  isInAnotherBlock: _collisionIndex != null &&
                                      _collisionIndex != id,
                                  onTextChanged: (newText) {
                                    setState(() {
                                      _widgetsData[id]['text'] = newText;
                                    });
                                  },
                                  onDrag: (Offset newPosition) {
                                    setState(() {
                                      _isOnAnimation.value = false;
                                      _isDragging = true;
                                      _tapPosition = newPosition;
                                      _widgetsData[id]['position'] =
                                          newPosition;
                                    });
                                    _detectCollisionWithDraggingWidget(
                                        id,
                                        newPosition,
                                        _widgetsData[id]['width'],
                                        _widgetsData[id]['height']);
                                    // Accede al estado montado mediante el GlobalKey
                                    final trashState =
                                        WidgetTrash.globalKey.currentState;
                                    if (trashState != null) {
                                      trashState.notifyProximity(newPosition);
                                    }
                                  },
                                  onFinishDrag: (Offset finalPosition) {
                                    if (WidgetTrash
                                            .globalKey.currentState?.isNear ??
                                        false) {
                                      _widgetsData[id]['isDeleted'] = true;
                                      Future.delayed(
                                          Duration(
                                              milliseconds: _deletedDurationMS),
                                          () {
                                        _erasedWidgets.add(id);
                                        _updateActiveWidgets();
                                        startAnimation(500);
                                      });
                                    }
                                    if (_collisionIndex != null) {
                                      _widgetsData[_collisionIndex!]
                                          ['isDeleted'] = true;
                                      Future.delayed(
                                          Duration(
                                              milliseconds: _deletedDurationMS),
                                          () {
                                        _combineWidgets(id, _collisionIndex!);
                                        _updateActiveWidgets();
                                        startAnimation(500);
                                      });
                                    }
                                    setState(() {
                                      _isDragging = false;
                                    });
                                  },
                                  onEditing: () {},
                                  onCreateWidget:
                                      (Offset position, Offset circlePosition) {
                                    _addWidget(
                                      "New Block ${_widgetsData.length}",
                                      FlowBlockType.process,
                                      position, // Posiciona el nuevo widget
                                    );
                                    _addConnection(id, _widgetsData.length - 1);
                                  },
                                );
                              }).toList(),
                            );
                          }),
                      if (_isDragging && _collisionIndex != null)
                        _buildUnionIndicator(
                            _collisionIndex != null &&
                                    _isIndexValid(_collisionIndex!)
                                ? _widgetsData[_collisionIndex!]['position']
                                : const Offset(0, 0),
                            _tapPosition,
                            15.0,
                            flowProcessWidth,
                            flowProcessHeight),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await _openAIService.startRecording();
                            },
                            child: Text('Iniciar Grabación'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await _openAIService.stopRecording();
                            },
                            child: Text('Detener Grabación'),
                          )
                        ],
                      ),
                      WidgetTrash(
                        key: WidgetTrash.globalKey,
                        widgetSize: trashSize,
                        expandedSize: trashExpandedSize,
                        initialPosition: _trashInitialPosition,
                        distanceThreshold: 50,
                        outsideWidgetSize: flowProcessHeight,
                        isTrashVisible: _isDragging,
                      ),
                    ],
                  ),
                ),
              ),
              XmlInputWidget(
                onXmlSubmitted: _sendMessage,
                hintText: 'Escribe algo...',
              ),
              if (_messages.isNotEmpty) Text(_messages[_messages.length - 1])
            ],
          )
        ],
      ),
    );
  }

  Widget _buildUnionIndicator(Offset anotherBlockPosition, Offset dragPosition,
      double circleRadius, double width, double height) {
    const iconSize = 20.0;
    return Transform.translate(
      offset: anotherBlockPosition + const Offset(5, 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(circleRadius),
        child: Transform.translate(
          offset: -anotherBlockPosition + dragPosition,
          child: Stack(
            children: [
              Container(
                width: width,
                height: height,
                decoration:
                    FlowStyles.buldBoxDecoration(true, false, false, 10.0),
              ),
              Transform.translate(
                  offset: (-(dragPosition - anotherBlockPosition) +
                          Offset(width - iconSize, height - iconSize)) /
                      2,
                  child: const Icon(
                    Icons.add,
                    size: iconSize,
                    color: Colors.white,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  updateFlow(input) {
    setState(() {
      _widgetsData = FlowUtil.parseXmlToWidgets(input);
      _editingNotifiers.clear();

      for (var _ in _widgetsData) {
        _editingNotifiers.add(ValueNotifier<bool>(false));
      }

      _erasedWidgets.clear();

      _updateActiveWidgets();
      startAnimation(500);
    });
  }
}
