import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'telas_prestador_widget.dart' show TelasPrestadorWidget;
import 'package:flutter/material.dart';

class TelasPrestadorModel extends FlutterFlowModel<TelasPrestadorWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for Switch widget.
  bool? switchValue;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
