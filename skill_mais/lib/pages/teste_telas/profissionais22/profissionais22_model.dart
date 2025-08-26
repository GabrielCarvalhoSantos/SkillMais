import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'profissionais22_widget.dart' show Profissionais22Widget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Profissionais22Model extends FlutterFlowModel<Profissionais22Widget> {
  // State fields para widgets stateful nesta página
  List<CategoriasRow>? _categoriasCarregadas;
  
  @override
  void initState(BuildContext context) {
    // Carregar categorias na inicialização
    _carregarCategorias();
  }

  @override
  void dispose() {
    // Limpar recursos se necessário
  }

  // Função privada para carregar categorias
  Future<void> _carregarCategorias() async {
    try {
      _categoriasCarregadas = await CategoriasTable().queryRows(
        queryFn: (q) => q.eq('ativo', true).order('nome', ascending: true),
      );
    } catch (e) {
      print('Erro ao carregar categorias: $e');
    }
  }

  // Função para obter o ID da categoria pelo nome
  String? _obterIdCategoriaPorNome(String? nomeCategoria) {
    if (nomeCategoria == null || _categoriasCarregadas == null) {
      return null;
    }

    try {
      CategoriasRow categoria =
          _categoriasCarregadas!.firstWhere((cat) => cat.nome == nomeCategoria);
      return categoria.id;
    } catch (e) {
      print('Erro ao encontrar categoria: $e');
      return null;
    }
  }
}