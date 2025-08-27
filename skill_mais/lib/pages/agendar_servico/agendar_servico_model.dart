import '/flutter_flow/flutter_flow_util.dart';
import 'agendar_servico_widget.dart' show AgendarServicoWidget;
import 'package:flutter/material.dart';

class AgendarServicoModel extends FlutterFlowModel<AgendarServicoWidget> {
  ///  State fields for stateful widgets in this page.

  // Lista para rastrear serviços selecionados
  Set<String> servicosSelecionados = <String>{};

  // Data selecionada
  DateTime? dataSelecionada;

  // Horário selecionado
  String? horarioSelecionado;

  // Controller para observações
  late TextEditingController observacoesController;

  @override
  void initState(BuildContext context) {
    observacoesController = TextEditingController();
  }

  @override
  void dispose() {
    observacoesController.dispose();
  }

  // Método para adicionar ou remover serviço da seleção
  void toggleServicoSelecionado(String servicoId) {
    if (servicosSelecionados.contains(servicoId)) {
      servicosSelecionados.remove(servicoId);
    } else {
      servicosSelecionados.add(servicoId);
    }
  }

  // Método para verificar se um serviço está selecionado
  bool isServicoSelecionado(String servicoId) {
    return servicosSelecionados.contains(servicoId);
  }

  // Método para obter o total de serviços selecionados
  int get totalServicosSelecionados => servicosSelecionados.length;

  // Método para limpar seleções
  void clearSelections() {
    servicosSelecionados.clear();
    dataSelecionada = null;
    horarioSelecionado = null;
    observacoesController.clear();
  }

  // Validações
  bool get isFormValid {
    return servicosSelecionados.isNotEmpty &&
           dataSelecionada != null &&
           horarioSelecionado != null;
  }

  // Obter data formatada
  String get dataFormatada {
    if (dataSelecionada == null) return '';
    return DateFormat('dd/MM/yyyy').format(dataSelecionada!);
  }
}