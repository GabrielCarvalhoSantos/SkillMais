import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'novo_servico_widget.dart' show NovoServicoWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
