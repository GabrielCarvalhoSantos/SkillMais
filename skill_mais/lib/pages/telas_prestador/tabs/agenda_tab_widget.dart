// lib/pages/telas_prestador/tabs/agenda_tab_prestador_widget.dart

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AgendaTabPrestadorWidget extends StatefulWidget {
  const AgendaTabPrestadorWidget({Key? key}) : super(key: key);

  @override
  State<AgendaTabPrestadorWidget> createState() => _AgendaTabPrestadorWidgetState();
}

class _AgendaTabPrestadorWidgetState extends State<AgendaTabPrestadorWidget> {
  FormFieldController<String>? dropDownValueController;
  String? dropDownValue;

  final Map<String, Color> _statusCores = {
    'pendente': const Color(0xFFFFA726),
    'confirmado': const Color(0xFF42A5F5),
    'concluido': const Color(0xFF66BB6A),
    'cancelado': const Color(0xFFEF5350),
  };

  final Map<String, String> _statusLabels = {
    'pendente': 'Pendente',
    'confirmado': 'Agendado',
    'concluido': 'Concluído',
    'cancelado': 'Cancelado',
  };

  @override
  void initState() {
    super.initState();
    dropDownValue = 'Todos';
  }

  Future<List<Map<String, dynamic>>> _buscarAgendamentosPrestador() async {
    try {
      final prestadorId = currentUserUid;

      print('Iniciando busca para prestador: $prestadorId');

      // Buscar serviços do prestador
      final servicos = await Supabase.instance.client
          .from('servicos')
          .select('id, titulo, preco_base, categoria_id')
          .eq('prestador_id', prestadorId);

      print('Serviços encontrados: ${servicos.length}');
      
      if (servicos.isEmpty) {
        return [];
      }

      List<Map<String, dynamic>> todosAgendamentos = [];
      
      // Buscar agendamentos para cada serviço
      for (var servico in servicos) {
        try {
          final agendamentosServico = await Supabase.instance.client
              .from('agendamentos')
              .select('*')
              .eq('servico_id', servico['id']);
          
          todosAgendamentos.addAll(agendamentosServico.cast<Map<String, dynamic>>());
        } catch (e) {
          print('Erro ao buscar agendamentos do serviço ${servico['id']}: $e');
        }
      }

      print('Total agendamentos encontrados: ${todosAgendamentos.length}');

      // Aplicar filtros
      List<Map<String, dynamic>> agendamentosFiltrados = todosAgendamentos;
      
      if (dropDownValue != null && dropDownValue != 'Todos') {
        if (dropDownValue == 'Hoje') {
          final hoje = DateTime.now();
          agendamentosFiltrados = todosAgendamentos.where((ag) {
            if (ag['data_hora'] == null) return false;
            try {
              final dataAgendamento = DateTime.parse(ag['data_hora']);
              return _isSameDay(dataAgendamento, hoje);
            } catch (e) {
              return false;
            }
          }).toList();
        } else {
          String statusFiltro = dropDownValue!.toLowerCase();
          if (statusFiltro == 'agendado') statusFiltro = 'confirmado';
          if (statusFiltro == 'concluído') statusFiltro = 'concluido';
          
          agendamentosFiltrados = todosAgendamentos.where((ag) => 
            ag['status']?.toString().toLowerCase() == statusFiltro
          ).toList();
        }
      }

      // Ordenar por data
      agendamentosFiltrados.sort((a, b) {
        if (a['data_hora'] == null && b['data_hora'] == null) return 0;
        if (a['data_hora'] == null) return 1;
        if (b['data_hora'] == null) return -1;
        try {
          return DateTime.parse(b['data_hora']).compareTo(DateTime.parse(a['data_hora']));
        } catch (e) {
          return 0;
        }
      });

      // Processar dados finais
      List<Map<String, dynamic>> resultado = [];

      for (var agendamento in agendamentosFiltrados) {
        try {
          // Encontrar serviço
          final servico = servicos.firstWhere(
            (s) => s['id'].toString() == agendamento['servico_id'].toString(),
            orElse: () => {'titulo': 'Serviço', 'preco_base': 0, 'categoria_id': null},
          );

          // Buscar nome do contratante
          String nomeContratante = 'Cliente';
          try {
            if (agendamento['contratante_id'] != null) {
              final usuario = await Supabase.instance.client
                  .from('usuarios')
                  .select('nome')
                  .eq('user_id', agendamento['contratante_id'])
                  .maybeSingle();
              nomeContratante = usuario?['nome'] ?? 'Cliente';
            }
          } catch (e) {
            print('Erro ao buscar usuário: $e');
          }

          // Buscar endereço
          String enderecoCompleto = 'Endereço não informado';
          try {
            if (agendamento['contratante_id'] != null) {
              final endereco = await Supabase.instance.client
                  .from('enderecos')
                  .select('logradouro, numero, bairro, cidade, estado')
                  .eq('usuario_id', agendamento['contratante_id'])
                  .limit(1)
                  .maybeSingle();

              if (endereco != null) {
                List<String> partes = [];
                if (endereco['logradouro'] != null && endereco['logradouro'].toString().isNotEmpty) {
                  String logradouroCompleto = endereco['logradouro'].toString();
                  if (endereco['numero'] != null && endereco['numero'].toString().isNotEmpty) {
                    logradouroCompleto += ', ${endereco['numero']}';
                  }
                  partes.add(logradouroCompleto);
                }
                if (endereco['bairro'] != null && endereco['bairro'].toString().isNotEmpty) {
                  partes.add(endereco['bairro'].toString());
                }
                if (endereco['cidade'] != null && endereco['cidade'].toString().isNotEmpty) {
                  String cidadeEstado = endereco['cidade'].toString();
                  if (endereco['estado'] != null && endereco['estado'].toString().isNotEmpty) {
                    cidadeEstado += ', ${endereco['estado']}';
                  }
                  partes.add(cidadeEstado);
                }
                
                if (partes.isNotEmpty) {
                  enderecoCompleto = partes.join(' • ');
                }
              }
            }
          } catch (e) {
            print('Erro ao buscar endereço: $e');
          }

          // Buscar categoria
          String nomeCategoria = '';
          try {
            if (servico['categoria_id'] != null) {
              final categoria = await Supabase.instance.client
                  .from('categorias')
                  .select('nome')
                  .eq('id', servico['categoria_id'])
                  .maybeSingle();
              nomeCategoria = categoria?['nome'] ?? '';
            }
          } catch (e) {
            print('Erro ao buscar categoria: $e');
          }

          // Calcular valor
          double valorFinal = 0.0;
          try {
            if (agendamento['valor_acordado'] != null) {
              valorFinal = (agendamento['valor_acordado'] as num).toDouble();
            } else if (servico['preco_base'] != null) {
              valorFinal = (servico['preco_base'] as num).toDouble();
            }
          } catch (e) {
            print('Erro ao calcular valor: $e');
          }

          resultado.add({
            'id': agendamento['id'],
            'data_hora': agendamento['data_hora'],
            'status': agendamento['status'] ?? 'pendente',
            'observacoes': agendamento['observacoes'],
            'servico_titulo': servico['titulo'] ?? 'Serviço',
            'contratante_nome': nomeContratante,
            'categoria_nome': nomeCategoria,
            'endereco_completo': enderecoCompleto,
            'valor_final': valorFinal,
          });

        } catch (e) {
          print('Erro ao processar agendamento: $e');
          // Adicionar com dados mínimos para não quebrar a tela
          resultado.add({
            'id': agendamento['id'] ?? 'unknown',
            'data_hora': agendamento['data_hora'],
            'status': agendamento['status'] ?? 'pendente',
            'observacoes': agendamento['observacoes'],
            'servico_titulo': 'Serviço',
            'contratante_nome': 'Cliente',
            'categoria_nome': '',
            'endereco_completo': 'Endereço não informado',
            'valor_final': 0.0,
          });
        }
      }

      print('Processamento concluído: ${resultado.length} agendamentos');
      return resultado;

    } catch (e) {
      print('ERRO GERAL na busca: $e');
      return [];
    }
  }

  String _formatarDataHora(String? dataHoraString) {
    if (dataHoraString == null) return 'Data inválida';
    
    try {
      final dataHora = DateTime.parse(dataHoraString);
      final hoje = DateTime.now();
      
      String dataTexto;
      if (_isSameDay(dataHora, hoje)) {
        dataTexto = 'Hoje';
      } else if (_isSameDay(dataHora, hoje.add(Duration(days: 1)))) {
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

  Color _getStatusColor(String status) {
    return _statusCores[status] ?? Colors.grey;
  }

  String _getStatusLabel(String status) {
    return _statusLabels[status] ?? status;
  }

  Future<void> _concluirAgendamento(String agendamentoId) async {
    try {
      await Supabase.instance.client
          .from('agendamentos')
          .update({'status': 'concluido'})
          .eq('id', agendamentoId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Agendamento concluído com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao concluir agendamento'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _mostrarModalEdicao(Map<String, dynamic> agendamento) {
    DateTime dataAtual = DateTime.now();
    TimeOfDay horaAtual = TimeOfDay.now();

    if (agendamento['data_hora'] != null) {
      try {
        dataAtual = DateTime.parse(agendamento['data_hora']);
        horaAtual = TimeOfDay.fromDateTime(dataAtual);
      } catch (e) {
        print('Erro ao fazer parse da data: $e');
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime novaData = dataAtual;
        TimeOfDay novaHora = horaAtual;

        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              title: Text('Editar Agendamento'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('Data: ${DateFormat('dd/MM/yyyy').format(novaData)}'),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      final data = await showDatePicker(
                        context: context,
                        initialDate: novaData,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (data != null) {
                        setStateModal(() {
                          novaData = data;
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: Text('Hora: ${novaHora.format(context)}'),
                    trailing: Icon(Icons.access_time),
                    onTap: () async {
                      final hora = await showTimePicker(
                        context: context,
                        initialTime: novaHora,
                      );
                      if (hora != null) {
                        setStateModal(() {
                          novaHora = hora;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _salvarEdicao(agendamento['id'], novaData, novaHora);
                    Navigator.of(context).pop();
                  },
                  child: Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _salvarEdicao(String agendamentoId, DateTime novaData, TimeOfDay novaHora) async {
    try {
      final dataHoraCompleta = DateTime(
        novaData.year,
        novaData.month,
        novaData.day,
        novaHora.hour,
        novaHora.minute,
      );

      await Supabase.instance.client
          .from('agendamentos')
          .update({'data_hora': dataHoraCompleta.toIso8601String()})
          .eq('id', agendamentoId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Agendamento editado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao editar agendamento'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
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
            
            // Filtros
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
                      'Hoje',
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
                    margin: const EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 4.0),
                    hidesUnderline: true,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16.0),
            
            // Lista de agendamentos
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _buscarAgendamentosPrestador(),
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

                  if (snapshot.hasError) {
                    print('Erro no snapshot: ${snapshot.error}');
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error,
                            size: 64.0,
                            color: FlutterFlowTheme.of(context).error,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Erro ao carregar agendamentos',
                            style: FlutterFlowTheme.of(context).headlineSmall,
                          ),
                        ],
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
                            style: FlutterFlowTheme.of(context).headlineSmall.override(
                              color: FlutterFlowTheme.of(context).secondaryText,
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
                      final statusColor = _getStatusColor(agendamento['status'] ?? '');
                      final statusLabel = _getStatusLabel(agendamento['status'] ?? '');

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
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
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                ),
                                
                                const SizedBox(width: 16.0),
                                
                                // Avatar do cliente
                                Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).alternate,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    size: 20.0,
                                  ),
                                ),
                                
                                const SizedBox(width: 12.0),
                                
                                // Informações principais
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Nome do cliente
                                      Text(
                                        agendamento['contratante_nome'] ?? 'Cliente',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      
                                      const SizedBox(height: 2.0),
                                      
                                      // Data e hora
                                      Text(
                                        _formatarDataHora(agendamento['data_hora']),
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          color: FlutterFlowTheme.of(context).secondaryText,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      
                                      const SizedBox(height: 2.0),
                                      
                                      // Nome do serviço
                                      Text(
                                        agendamento['servico_titulo'] ?? 'Serviço',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      
                                      const SizedBox(height: 2.0),
                                      
                                      // Endereço completo
                                      Text(
                                        agendamento['endereco_completo'] ?? 'Endereço não informado',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          color: FlutterFlowTheme.of(context).secondaryText,
                                          fontSize: 12.0,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      
                                      const SizedBox(height: 8.0),
                                      
                                      // Status badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                          vertical: 4.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(16.0),
                                        ),
                                        child: Text(
                                          statusLabel,
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            color: statusColor,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Coluna direita com valor e botões
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // Valor
                                    Text(
                                      'R\$ ${(agendamento['valor_final'] ?? 0.0).toStringAsFixed(2)}',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 12.0),
                                    
                                    // Botões baseados no status
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Botão Editar
                                        if (agendamento['status'] == 'pendente' || 
                                            agendamento['status'] == 'confirmado')
                                          InkWell(
                                            onTap: () => _mostrarModalEdicao(agendamento),
                                            child: Text(
                                              'Editar',
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                color: const Color(0xFF42A5F5),
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        
                                        // Espaçamento entre botões
                                        if ((agendamento['status'] == 'pendente' || 
                                             agendamento['status'] == 'confirmado') &&
                                            agendamento['status'] == 'confirmado')
                                          const SizedBox(width: 16.0),
                                        
                                        // Botão Concluir
                                        if (agendamento['status'] == 'confirmado')
                                          InkWell(
                                            onTap: () => _concluirAgendamento(agendamento['id']),
                                            child: Text(
                                              'Concluir',
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                color: const Color(0xFF66BB6A),
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
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
      ),
    );
  }
}