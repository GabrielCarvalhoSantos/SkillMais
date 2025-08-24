import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'cadastro_prestador_widget.dart' show CadastroPrestadorWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class CadastroPrestadorModel extends FlutterFlowModel<CadastroPrestadorWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for NomePrestador widget.
  FocusNode? nomePrestadorFocusNode;
  TextEditingController? nomePrestadorTextController;
  String? Function(BuildContext, String?)? nomePrestadorTextControllerValidator;
  // State field(s) for SenhaPrestador widget.
  FocusNode? senhaPrestadorFocusNode;
  TextEditingController? senhaPrestadorTextController;
  late bool senhaPrestadorVisibility;
  String? Function(BuildContext, String?)?
      senhaPrestadorTextControllerValidator;
  String? _senhaPrestadorTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Sua senha é inválida.';
    }

    if (val.length < 6) {
      return 'Sua senha tem que ter no mínimo 6 caracteres.';
    }
    if (val.length > 18) {
      return 'Máximo de caracteres suportado - 18';
    }

    return null;
  }

  // State field(s) for EmailPrestador widget.
  FocusNode? emailPrestadorFocusNode;
  TextEditingController? emailPrestadorTextController;
  String? Function(BuildContext, String?)?
      emailPrestadorTextControllerValidator;
  // State field(s) for TelefonePrestador widget.
  FocusNode? telefonePrestadorFocusNode;
  TextEditingController? telefonePrestadorTextController;
  late MaskTextInputFormatter telefonePrestadorMask;
  String? Function(BuildContext, String?)?
      telefonePrestadorTextControllerValidator;
  // State field(s) for RuaPrestador widget.
  FocusNode? ruaPrestadorFocusNode;
  TextEditingController? ruaPrestadorTextController;
  String? Function(BuildContext, String?)? ruaPrestadorTextControllerValidator;
  // State field(s) for CEPprestador widget.
  FocusNode? cEPprestadorFocusNode;
  TextEditingController? cEPprestadorTextController;
  late MaskTextInputFormatter cEPprestadorMask;
  String? Function(BuildContext, String?)? cEPprestadorTextControllerValidator;
  // State field(s) for n-Prestador widget.
  FocusNode? nPrestadorFocusNode;
  TextEditingController? nPrestadorTextController;
  String? Function(BuildContext, String?)? nPrestadorTextControllerValidator;
  // State field(s) for UFprestador widget.
  FocusNode? uFprestadorFocusNode;
  TextEditingController? uFprestadorTextController;
  late MaskTextInputFormatter uFprestadorMask;
  String? Function(BuildContext, String?)? uFprestadorTextControllerValidator;
  // State field(s) for CidadePrestador widget.
  FocusNode? cidadePrestadorFocusNode;
  TextEditingController? cidadePrestadorTextController;
  String? Function(BuildContext, String?)?
      cidadePrestadorTextControllerValidator;
  // State field(s) for CategoriaPrestador widget.
  String? categoriaPrestadorValue;
  FormFieldController<String>? categoriaPrestadorValueController;
  // State field(s) for SobrePrestador widget.
  FocusNode? sobrePrestadorFocusNode;
  TextEditingController? sobrePrestadorTextController;
  String? Function(BuildContext, String?)?
      sobrePrestadorTextControllerValidator;

  @override
  void initState(BuildContext context) {
    senhaPrestadorVisibility = false;
    senhaPrestadorTextControllerValidator =
        _senhaPrestadorTextControllerValidator;
  }

  @override
  void dispose() {
    nomePrestadorFocusNode?.dispose();
    nomePrestadorTextController?.dispose();

    senhaPrestadorFocusNode?.dispose();
    senhaPrestadorTextController?.dispose();

    emailPrestadorFocusNode?.dispose();
    emailPrestadorTextController?.dispose();

    telefonePrestadorFocusNode?.dispose();
    telefonePrestadorTextController?.dispose();

    ruaPrestadorFocusNode?.dispose();
    ruaPrestadorTextController?.dispose();

    cEPprestadorFocusNode?.dispose();
    cEPprestadorTextController?.dispose();

    nPrestadorFocusNode?.dispose();
    nPrestadorTextController?.dispose();

    uFprestadorFocusNode?.dispose();
    uFprestadorTextController?.dispose();

    cidadePrestadorFocusNode?.dispose();
    cidadePrestadorTextController?.dispose();

    sobrePrestadorFocusNode?.dispose();
    sobrePrestadorTextController?.dispose();
  }
}
