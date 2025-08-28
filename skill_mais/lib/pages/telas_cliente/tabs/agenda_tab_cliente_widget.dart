// lib/pages/telas_cliente/tabs/agenda_tab_cliente_widget.dart

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AgendaTabClienteWidget extends StatefulWidget {
  final UsuariosRow? user;

  const AgendaTabClienteWidget({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  State<AgendaTabClienteWidget> createState() => _AgendaTabClienteWidgetState();
}

class _AgendaTabClienteWidgetState extends State<AgendaTabClienteWidget> {
  FormFieldController<String>? dropDownValueController;
  String? dropDownValue;

  // Mapa de cores para cada status
  final Map<String, Color> _statusCores = {
    'pendente': const Color(0xFFFFA726), // Laranja
    'confirmado': const Color(0xFF42A5F5), // Azul
    'concluido': const Color(0xFF66BB6A), // Verde
    'cancelado': const Color(0xFFEF5350), // Vermelho
  };

  // Mapa de labels para os status
  final Map<String, String> _statusLabels = {
    'pendente': 'Pendente',
    'confirmado': 'Agendado',
    'concluido': 'Concluído',
    'cancelado': 'Cancelado',
  };

  @override
  void initState() {
    super.initState();
    dropDownValue = 'Todos'; // Valor padrão
  }

  // Buscar APENAS os agendamentos do cliente logado
  Future<List<Map<String, dynamic>>> _buscarAgendamentosCliente() async {
    final clienteId = currentUserUid;
    if (clienteId == null) {
      debugPrint('Cliente ID é null - usuário não está logado');
      return [];
    }

    try {
      final agendamentos = await Supabase.instance.client
          .from('agendamentos')
          .select('*')
          .eq('contratante_id', clienteId)
          .order('data_hora', ascending: false);

      // Filtrar por status se necessário
      List<Map<String, dynamic>> agendamentosFiltrados = agendamentos;
      if (dropDownValue != null && dropDownValue != 'Todos') {
        String statusFiltro = dropDownValue!.toLowerCase();
        if (statusFiltro == 'agendado') statusFiltro = 'confirmado';
        if (statusFiltro == 'concluído') statusFiltro = 'concluido';

        agendamentosFiltrados = agendamentos
            .where((ag) => ag['status'] == statusFiltro)
            .toList();
      }

      List<Map<String, dynamic>> resultado = [];

      for (var agendamento in agendamentosFiltrados) {
        // Buscar dados do serviço
        final servico = await Supabase.instance.client
            .from('servicos')
            .select('id, titulo, preco_base, prestador_id, categoria_id')
            .eq('id', agendamento['servico_id'])
            .maybeSingle();

        // Buscar dados do prestador
        String nomePrestador = 'Prestador';
        if (servico != null && servico['prestador_id'] != null) {
          final prestador = await Supabase.instance.client
              .from('usuarios')
              .select('nome')
              .eq('user_id', servico['prestador_id'])
              .maybeSingle();

          nomePrestador = prestador?['nome'] ?? 'Prestador';
        }

        // Buscar categoria
        String nomeCategoria = '';
        if (servico != null && servico['categoria_id'] != null) {
          final categoria = await Supabase.instance.client
              .from('categorias')
              .select('nome')
              .eq('id', servico['categoria_id'])
              .maybeSingle();

          nomeCategoria = categoria?['nome'] ?? '';
        }

        // Calcular valor final (prioridade: valor_acordado > preco_base)
        double valorFinal = 0.0;
        if (agendamento['valor_acordado'] != null) {
          valorFinal = (agendamento['valor_acordado'] as num).toDouble();
        } else if (servico != null && servico['preco_base'] != null) {
          valorFinal = (servico['preco_base'] as num).toDouble();
        }

        // NOVO: Verificar se o serviço já foi avaliado
        bool jaAvaliado = false;
        if (agendamento['status'] == 'concluido') {
          final avaliacaoExistente = await Supabase.instance.client
              .from('avaliacoes')
              .select('id')
              .eq('agendamento_id', agendamento['id'])
              .eq('contratante_id', clienteId)
              .maybeSingle();
          jaAvaliado = avaliacaoExistente != null;
        }

        resultado.add({
          ...agendamento,
          'servico_titulo': servico?['titulo'] ?? 'Serviço',
          'prestador_nome': nomePrestador,
          'categoria_nome': nomeCategoria,
          'valor_final': valorFinal,
          'prestador_id': servico?['prestador_id'], // << necessário para salvar
          'servico_id': servico?['id'] ?? agendamento['servico_id'],
          'ja_avaliado': jaAvaliado, // NOVO: Flag para o estado da avaliação
        });
      }

      return resultado;
    } catch (e) {
      debugPrint('Erro ao buscar agendamentos do cliente: $e');
      return [];
    }
  }

  // Formatar data e hora igual ao design
  String _formatarDataHora(String? dataHoraString) {
    if (dataHoraString == null) return 'Hoje • 08:00';

    try {
      final dataHora = DateTime.parse(dataHoraString);
      final hoje = DateTime.now();

      String dataTexto;
      if (_isSameDay(dataHora, hoje)) {
        dataTexto = 'Hoje';
      } else if (_isSameDay(dataHora, hoje.add(const Duration(days: 1)))) {
        dataTexto = 'Amanhã';
      } else {
        dataTexto = DateFormat('dd/MM', 'pt_BR').format(dataHora);
      }

      final horaTexto = DateFormat('HH:mm', 'pt_BR').format(dataHora);
      return '$dataTexto • $horaTexto';
    } catch (e) {
      return 'Data inválida';
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Obter cor do status
  Color _getStatusColor(String status) {
    return _statusCores[status] ?? Colors.grey;
  }

  // Obter label do status
  String _getStatusLabel(String status) {
    return _statusLabels[status] ?? status;
  }

  /// Abre o modal de avaliação e salva no banco
  Future<void> _abrirModalAvaliacao(Map<String, dynamic> agendamento) async {
    final TextEditingController comentarioCtrl = TextEditingController();
    double ratingValue = 0.0;
    bool salvando = false;

    await showDialog( // Alterado para showDialog
      context: context,
      builder: (ctx) {
        return Dialog( // Alterado para Dialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Card com avatar, nome, serviço e data de conclusão
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0x33000000),
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).accent1,
                            shape: BoxShape.circle,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            'https://picsum.photos/seed/${agendamento['prestador_id'] ?? 'noid'}/150',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.person,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                agendamento['prestador_nome'] ?? 'Prestador',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                agendamento['servico_titulo'] ?? 'Serviço',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                              ),
                              Text(
                                'Concluído em ${agendamento['data_hora'] != null ? DateFormat('dd/MM/yyyy').format(DateTime.parse(agendamento['data_hora'])) : '-'}',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Como foi o Serviço',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  StatefulBuilder(builder: (context, setRatingState) {
                    return RatingBar.builder(
                      onRatingUpdate: (newValue) {
                        setRatingState(() {
                          ratingValue = newValue;
                        });
                      },
                      itemBuilder: (context, index) =>
                      const Icon(Icons.star_rounded, color: Colors.orange),
                      direction: Axis.horizontal,
                      initialRating: ratingValue,
                      unratedColor: const Color(0xFFE0E0E0),
                      itemCount: 5,
                      itemSize: 40,
                      glowColor: Colors.orange,
                      allowHalfRating: false,
                      minRating: 1,
                    );
                  }),

                  const SizedBox(height: 16),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Deixe um comentário (Opcional)',
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: comentarioCtrl,
                    maxLines: 4,
                    maxLength: 500,
                    decoration: InputDecoration(
                      hintText: 'Escreva aqui seu comentário',
                      hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primary,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor:
                      FlutterFlowTheme.of(context).secondaryBackground,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (salvando) return;
                        if (ratingValue == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Selecione uma nota de 1 a 5.'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        final clienteId = currentUserUid;
                        if (clienteId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Erro: usuário não está logado.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final String? prestadorId = agendamento['prestador_id'];
                        final String? servicoId = agendamento['servico_id'];
                        final String? agendamentoId = agendamento['id'];

                        if (prestadorId == null || servicoId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Não foi possível identificar o prestador/serviço.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        salvando = true;
                        try {
                          final payload = {
                            'contratante_id': clienteId,
                            'prestador_id': prestadorId,
                            'servico_id': servicoId,
                            'agendamento_id': agendamentoId,
                            'nota': ratingValue.toInt(),
                            'comentario': comentarioCtrl.text.trim().isEmpty
                                ? null
                                : comentarioCtrl.text.trim(),
                            'data': DateTime.now().toIso8601String(),
                          };

                          await Supabase.instance.client
                              .from('avaliacoes')
                              .insert(payload);

                          if (mounted) {
                            Navigator.of(ctx).pop(); // fecha modal
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Avaliação enviada com sucesso!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            setState(() {}); // força recarregar a lista
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erro ao enviar avaliação: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } finally {
                          salvando = false;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 47, 99),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Avaliar Serviço',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título dentro de container branco (expandido)
          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 4.0,
                  color: Color(0x33000000),
                  offset: Offset(0.0, 2.0),
                ),
              ],
            ),
            child: Text(
              'Meus Agendamentos',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          const SizedBox(height: 20.0),

          // Seção de filtros
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Resultados',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // Dropdown de filtros
              Container(
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 1.0,
                  ),
                ),
                child: FlutterFlowDropDown<String>(
                  controller: dropDownValueController ??=
                  FormFieldController<String>(dropDownValue),
                  options: const [
                    'Todos',
                    'Pendente',
                    'Agendado',
                    'Concluído',
                    'Cancelado'
                  ],
                  onChanged: (val) {
                    setState(() {
                      dropDownValue = val;
                    });
                  },
                  width: 120,
                  height: 40,
                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontSize: 14.0,
                  ),
                  hintText: 'Filtro',
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 20.0,
                  ),
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  elevation: 2.0,
                  borderColor: Colors.transparent,
                  borderWidth: 0.0,
                  borderRadius: 8.0,
                  margin:
                  const EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 4.0),
                  hidesUnderline: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16.0),

          // Lista de agendamentos
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _buscarAgendamentosCliente(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  );
                }

                final agendamentos = snapshot.data ?? [];

                if (agendamentos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 64.0,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Nenhum agendamento encontrado',
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                            color:
                            FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: agendamentos.length,
                  itemBuilder: (context, index) {
                    final agendamento = agendamentos[index];
                    final statusColor =
                    _getStatusColor(agendamento['status'] ?? '');
                    final statusLabel =
                    _getStatusLabel(agendamento['status'] ?? '');

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .secondaryBackground,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4.0,
                              color: Color(0x33000000),
                              offset: Offset(0.0, 2.0),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              // Barra lateral colorida
                              Container(
                                width: 4.0,
                                height: 70.0,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                              ),

                              const SizedBox(width: 16.0),

                              // Informações principais
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _formatarDataHora(
                                          agendamento['data_hora']),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    Text(
                                      agendamento['servico_titulo'] ??
                                          'Serviço',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(
                                      '${agendamento['prestador_nome']} • ${agendamento['categoria_nome']}',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 4.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.2),
                                        borderRadius:
                                        BorderRadius.circular(16.0),
                                      ),
                                      child: Text(
                                        statusLabel,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                          color: statusColor,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Coluna direita com valor e botão Avaliar
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${(agendamento['valor_final'] ?? 0.0).toStringAsFixed(0)}',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    'R\$ / hora',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  if (agendamento['status'] == 'concluido')
                                    ...[
                                      const SizedBox(height: 12.0),
                                      // NOVO: Condicional para exibir "Avaliar" ou "Avaliado"
                                      if (agendamento['ja_avaliado'])
                                        Text(
                                          'Avaliado',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            color: Colors.green, // Cor verde para indicar que já foi avaliado
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      else
                                        InkWell(
                                          onTap: () =>
                                              _abrirModalAvaliacao(agendamento),
                                          child: Text(
                                            'Avaliar',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                              color: const Color.fromARGB(
                                                  255, 255, 44, 44),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w700,
                                              decoration:
                                              TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                    ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}