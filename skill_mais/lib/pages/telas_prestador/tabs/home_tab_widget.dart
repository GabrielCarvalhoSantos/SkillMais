// lib/pages/telas_prestador/tabs/home_tab_widget.dart

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeTabWidget extends StatelessWidget {
  final UsuariosRow? user;
  final Function(String, Color) onShowMessage;
  final VoidCallback onRefresh;

  const HomeTabWidget({
    Key? key,
    this.user,
    required this.onShowMessage,
    required this.onRefresh,
  }) : super(key: key);

  Future<List<Map<String, dynamic>>> _buscarSolicitacoesPendentes() async {
    final prestadorId = currentUserUid;
    if (prestadorId == null) return [];

    try {
      final servicos = await Supabase.instance.client
          .from('servicos')
          .select('id, titulo, preco_base')
          .eq('prestador_id', prestadorId);

      if (servicos.isEmpty) return [];

      final servicoIds = servicos.map((s) => s['id']).toList();
      final agendamentos = await Supabase.instance.client
          .from('agendamentos')
          .select('id, contratante_id, servico_id, data_hora, status, observacoes')
          .eq('status', 'pendente')
          .inFilter('servico_id', servicoIds)
          .order('created_at', ascending: false);

      List<Map<String, dynamic>> resultado = [];
      for (var agendamento in agendamentos) {
        final cliente = await Supabase.instance.client
            .from('usuarios')
            .select('nome, telefone')
            .eq('user_id', agendamento['contratante_id'])
            .maybeSingle();

        final servico = servicos.firstWhere((s) => s['id'] == agendamento['servico_id']);

        resultado.add({
          ...agendamento,
          'contratante_nome': cliente?['nome'] ?? 'Cliente',
          'contratante_telefone': cliente?['telefone'] ?? '',
          'servico_titulo': servico['titulo'] ?? 'Serviço',
          'servico_preco': servico['preco_base'] ?? 0,
        });
      }
      return resultado;
    } catch (e) {
      print('Erro ao buscar solicitações: $e');
      return [];
    }
  }

  Future<void> _aceitarAgendamento(String id) async {
    try {
      await Supabase.instance.client
          .from('agendamentos')
          .update({'status': 'confirmado'})
          .eq('id', id);
      onShowMessage('Agendamento aceito!', Colors.green);
      onRefresh();
    } catch (e) {
      onShowMessage('Erro ao aceitar', Colors.red);
    }
  }

  Future<void> _recusarAgendamento(String id) async {
    try {
      await Supabase.instance.client
          .from('agendamentos')
          .update({'status': 'recusado'})
          .eq('id', id);
      onShowMessage('Agendamento recusado', Colors.orange);
      onRefresh();
    } catch (e) {
      onShowMessage('Erro ao recusar', Colors.red);
    }
  }

  String _formatarDataHora(String? dataHoraString) {
    if (dataHoraString == null) return '17/08 • 10:00';

    try {
      final dataHora = DateTime.parse(dataHoraString);
      final dia = dataHora.day.toString().padLeft(2, '0');
      final mes = dataHora.month.toString().padLeft(2, '0');
      final hora = dataHora.hour.toString().padLeft(2, '0');
      final minuto = dataHora.minute.toString().padLeft(2, '0');
      return '$dia/$mes • $hora:$minuto';
    } catch (e) {
      return '17/08 • 10:00';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Header
            Container(
              height: 100.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olá, ${user?.nome ?? 'TestePrestador'}!',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                        Text(
                          'Bem Vindo(a)!',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.0),

            // Cards de estatísticas
            _buildStatsCard(context, '3', 'Agendamentos\nConcluídos', Color(0xFFBCD4FF)),
            SizedBox(height: 16.0),
            _buildStatsCard(context, '5', 'Agendamentos\nPendentes', Color(0xFFD1FFCE)),

            SizedBox(height: 24.0),

            // Título das solicitações
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Solicitações de Agendamento',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily: 'Roboto Condensed',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),

            SizedBox(height: 16.0),

            // Lista de solicitações dinâmicas
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _buscarSolicitacoesPendentes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final solicitacoes = snapshot.data ?? [];
                if (solicitacoes.isEmpty) {
                  return Container(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 64,
                              color: FlutterFlowTheme.of(context).secondaryText),
                          SizedBox(height: 16),
                          Text('Nenhuma solicitação pendente',
                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                  )),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: solicitacoes.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16.0),
                  itemBuilder: (context, index) {
                    final item = solicitacoes[index];
                    return _buildAppointmentRequestCard(
                      context,
                      item['id'].toString(),
                      item['contratante_nome'] ?? 'Cliente',
                      _formatarDataHora(item['data_hora']),
                      item['servico_titulo'] ?? 'Serviço',
                      'Rua das Flores, 127', // Mock de endereço
                      '80', // Mock de preço
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- Widgets Auxiliares ---
  Widget _buildStatsCard(BuildContext context, String value, String label, Color color) {
    return Container(
      width: double.infinity,
      height: 100.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(value, style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    )),
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentRequestCard(
      BuildContext context, String id, String name, String dateTime, String service, String address, String price) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center, // Alinhamento central vertical para a linha principal
              children: [
                Container(
                  width: 3.0,
                  height: 80.0,
                  color: FlutterFlowTheme.of(context).accent1,
                ),
                SizedBox(width: 10.0),
                Container(
                  width: 40.0,
                  height: 40.0,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Image.network('https://picsum.photos/seed/835/600', fit: BoxFit.cover),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center, // Centraliza o texto verticalmente
                    children: [
                      Text(name, style: FlutterFlowTheme.of(context).bodyMedium.override(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Text(dateTime, style: FlutterFlowTheme.of(context).bodyMedium),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Text(service, style: FlutterFlowTheme.of(context).bodyMedium),
                      Text('$address • 2,1 Km', style: FlutterFlowTheme.of(context).bodyMedium),
                    ],
                  ),
                ),
                Text(
                  'R\$ $price',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 80.0),
                FFButtonWidget(
                  onPressed: () {},
                  text: 'Aceitar',
                  options: FFButtonOptions(
                    height: 30.0,
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Color(0x00FFFFFF),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(color: FlutterFlowTheme.of(context).success, fontSize: 14.0),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                SizedBox(width: 80.0),
                FFButtonWidget(
                  onPressed: () {},
                  text: 'Recusar',
                  options: FFButtonOptions(
                    height: 30.0,
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Color(0x00FFFFFF),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(color: FlutterFlowTheme.of(context).error, fontSize: 14.0),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//Condigo Correto