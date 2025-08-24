import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'cadastro_cliente_widget.dart' show CadastroClienteWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class CadastroClienteModel extends FlutterFlowModel<CadastroClienteWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for NomeCliente widget.
  FocusNode? nomeClienteFocusNode;
  TextEditingController? nomeClienteTextController;
  String? Function(BuildContext, String?)? nomeClienteTextControllerValidator;
  // State field(s) for EmailCliente widget.
  FocusNode? emailClienteFocusNode;
  TextEditingController? emailClienteTextController;
  String? Function(BuildContext, String?)? emailClienteTextControllerValidator;
  String? _emailClienteTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Digite seu e-mail';
    }

    return null;
  }

  // State field(s) for SenhaCliente widget.
  FocusNode? senhaClienteFocusNode;
  TextEditingController? senhaClienteTextController;
  late bool senhaClienteVisibility;
  String? Function(BuildContext, String?)? senhaClienteTextControllerValidator;
  // State field(s) for TelCliente widget.
  FocusNode? telClienteFocusNode;
  TextEditingController? telClienteTextController;
  late MaskTextInputFormatter telClienteMask;
  String? Function(BuildContext, String?)? telClienteTextControllerValidator;
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
  void initState(BuildContext context) {
    emailClienteTextControllerValidator = _emailClienteTextControllerValidator;
    senhaClienteVisibility = false;
  }

  @override
  void dispose() {
    nomeClienteFocusNode?.dispose();
    nomeClienteTextController?.dispose();

    emailClienteFocusNode?.dispose();
    emailClienteTextController?.dispose();

    senhaClienteFocusNode?.dispose();
    senhaClienteTextController?.dispose();

    telClienteFocusNode?.dispose();
    telClienteTextController?.dispose();

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
