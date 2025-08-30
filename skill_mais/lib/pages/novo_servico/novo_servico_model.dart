import '/flutter_flow/flutter_flow_util.dart';
import 'novo_servico_widget.dart' show NovoServicoWidget;
import 'package:flutter/material.dart';

class NovoServicoModel extends FlutterFlowModel<NovoServicoWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for NomeServico widget.
  FocusNode? nomeServicoFocusNode;
  TextEditingController? nomeServicoTextController;
  String? Function(BuildContext, String?)? nomeServicoTextControllerValidator;
  // State field(s) for ValorServico widget.
  FocusNode? valorServicoFocusNode;
  TextEditingController? valorServicoTextController;
  String? Function(BuildContext, String?)? valorServicoTextControllerValidator;
  // State field(s) for Descricao widget.
  FocusNode? descricaoFocusNode;
  TextEditingController? descricaoTextController;
  String? Function(BuildContext, String?)? descricaoTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nomeServicoFocusNode?.dispose();
    nomeServicoTextController?.dispose();

    valorServicoFocusNode?.dispose();
    valorServicoTextController?.dispose();

    descricaoFocusNode?.dispose();
    descricaoTextController?.dispose();
  }
}
