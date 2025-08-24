import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'novo_endereco_widget.dart' show NovoEnderecoWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class NovoEnderecoModel extends FlutterFlowModel<NovoEnderecoWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for RuaCliente widget.
  FocusNode? ruaClienteFocusNode;
  TextEditingController? ruaClienteTextController;
  String? Function(BuildContext, String?)? ruaClienteTextControllerValidator;
  // State field(s) for CEPcliente widget.
  FocusNode? cEPclienteFocusNode;
  TextEditingController? cEPclienteTextController;
  late MaskTextInputFormatter cEPclienteMask;
  String? Function(BuildContext, String?)? cEPclienteTextControllerValidator;
  // State field(s) for NumCliente widget.
  FocusNode? numClienteFocusNode;
  TextEditingController? numClienteTextController;
  String? Function(BuildContext, String?)? numClienteTextControllerValidator;
  // State field(s) for UFcliente widget.
  FocusNode? uFclienteFocusNode;
  TextEditingController? uFclienteTextController;
  late MaskTextInputFormatter uFclienteMask;
  String? Function(BuildContext, String?)? uFclienteTextControllerValidator;
  // State field(s) for CidadeCliente widget.
  FocusNode? cidadeClienteFocusNode;
  TextEditingController? cidadeClienteTextController;
  String? Function(BuildContext, String?)? cidadeClienteTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    ruaClienteFocusNode?.dispose();
    ruaClienteTextController?.dispose();

    cEPclienteFocusNode?.dispose();
    cEPclienteTextController?.dispose();

    numClienteFocusNode?.dispose();
    numClienteTextController?.dispose();

    uFclienteFocusNode?.dispose();
    uFclienteTextController?.dispose();

    cidadeClienteFocusNode?.dispose();
    cidadeClienteTextController?.dispose();
  }
}
