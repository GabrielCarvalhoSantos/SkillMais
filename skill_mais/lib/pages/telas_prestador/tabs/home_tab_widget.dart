// lib/pages/telas_prestador/tabs/home_tab_widget.dart

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  // ================= BUSCAS =================

  /// Lista para a seção "Solicitações de Agendamento" (apenas pendentes)
  Future<List<Map<String, dynamic>>> _buscarSolicitacoesPendentes() async {
    final prestadorId = currentUserUid;

    try {
      final servicos = await Supabase.instance.client
          .from('servicos')
          .select('id, titulo, preco_base')
          .eq('prestador_id', prestadorId);

      if (servicos.isEmpty) return [];
      final servicoIds = servicos.map((s) => s['id']).toList();

      final ags = await Supabase.instance.client
          .from('agendamentos')
          .select(
              'id, contratante_id, servico_id, data_hora, status, observacoes')
          .eq('status', 'pendente')
          .inFilter('servico_id', servicoIds)
          .order('data_hora', ascending: true);

      final List<Map<String, dynamic>> out = [];
      for (final ag in ags) {
        final cliente = await Supabase.instance.client
            .from('usuarios')
            .select('nome, telefone')
            .eq('user_id', ag['contratante_id'])
            .maybeSingle();

        final end = await Supabase.instance.client
            .from('enderecos')
            .select('logradouro, numero, bairro, cidade, estado')
            .eq('usuario_id', ag['contratante_id'])
            .maybeSingle();

        final serv = servicos.firstWhere(
          (s) => s['id'] == ag['servico_id'],
          orElse: () => {'titulo': 'Serviço', 'preco_base': 0},
        );

        out.add({
          ...ag,
          'contratante_nome': cliente?['nome'] ?? 'Cliente',
          'telefone': cliente?['telefone'],
          'logradouro': end?['logradouro'],
          'numero': end?['numero'],
          'bairro': end?['bairro'],
          'cidade': end?['cidade'],
          'estado': end?['estado'],
          'servico_titulo': serv['titulo'] ?? 'Serviço',
          // (5) preço SEMPRE do serviço escolhido
          'servico_preco': (serv['preco_base'] as num?)?.toDouble() ?? 0.0,
        });
      }
      return out;
    } catch (e) {
      print('Erro _buscarSolicitacoesPendentes: $e');
      return [];
    }
  }

  /// (2) KPI Concluídos = somente status 'concluido'
  Future<int> _contarConcluidos() async {
    final prestadorId = currentUserUid;

    try {
      final servicos = await Supabase.instance.client
          .from('servicos')
          .select('id')
          .eq('prestador_id', prestadorId);
      if (servicos.isEmpty) return 0;

      final ids = servicos.map((s) => s['id']).toList();

      final rows = await Supabase.instance.client
          .from('agendamentos')
          .select('id')
          .eq('status', 'concluido')
          .inFilter('servico_id', ids);

      return rows.length;
    } catch (e) {
      print('Erro _contarConcluidos: $e');
      return 0;
    }
  }

  /// (2) KPI Pendentes = 'pendente' + 'em_andamento' (não conta cancelado/confirmado)
  Future<int> _contarPendentes() async {
    final prestadorId = currentUserUid;

    try {
      final servicos = await Supabase.instance.client
          .from('servicos')
          .select('id')
          .eq('prestador_id', prestadorId);
      if (servicos.isEmpty) return 0;

      final ids = servicos.map((s) => s['id']).toList();

      final rows = await Supabase.instance.client
          .from('agendamentos')
          .select('id, status')
          .inFilter('servico_id', ids)
          .inFilter('status', ['pendente', 'em_andamento']);

      return rows.length;
    } catch (e) {
      print('Erro _contarPendentes: $e');
      return 0;
    }
  }

  // ================= AÇÕES =================

  Future<void> _aceitarAgendamento(String id) async {
    try {
      await Supabase.instance.client
          .from('agendamentos')
          .update({'status': 'confirmado'}).eq('id', id);
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
          .update({'status': 'cancelado'}).eq('id', id);
      onShowMessage('Agendamento recusado', Colors.orange);
      onRefresh();
    } catch (e) {
      onShowMessage('Erro ao recusar', Colors.red);
    }
  }

  // ================= HELPERS =================

  String _formatarDataHora(dynamic v) {
    if (v == null) return '—';
    try {
      final dt = DateTime.parse(v.toString());
      return DateFormat('dd/MM • HH:mm', 'pt_BR').format(dt);
    } catch (_) {
      return '—';
    }
  }

  String _joinNotEmpty(List<String?> parts, {String sep = ' • '}) {
    return parts
        .where((p) => p != null && p.trim().isNotEmpty)
        .map((p) => p!.trim())
        .join(sep);
  }

  String _formatarValor(num v) => 'R\$ ${v.toStringAsFixed(2)}';

  Widget _metricCard(
    BuildContext context, {
    required Color chipBg,
    required Color chipFg,
    required Widget count,
    required String big, // (2) "Concluídos"/"Pendentes" GRANDE
    required String small, // (2) "Agendamentos" PEQUENO
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: chipBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: DefaultTextStyle(
                style: FlutterFlowTheme.of(context)
                    .titleLarge
                    .override(color: chipFg, fontWeight: FontWeight.w800),
                child: count,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // (2) pequeno
              Text(
                small,
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              // (2) grande
              Text(
                big,
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          children: [
            // (1) CARD "Olá / Bem Vindo(a)!" igual ao mock
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(29),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 10,
                      offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, ${user?.nome ?? 'TestePrestador'}!',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  Text(
                    'Bem Vindo(a)!',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // (2) CARDS DE STATUS (texto invertido como pedido)
            _metricCard(
              context,
              chipBg: const Color(0xFFD7E6FF),
              chipFg: const Color(0xFF1976D2),
              count: FutureBuilder<int>(
                future: _contarConcluidos(),
                builder: (_, s) => Text('${s.data ?? 0}'),
              ),
              big: 'Concluídos',
              small: 'Agendamentos',
            ),
            _metricCard(
              context,
              chipBg: const Color(0xFFE5F7E7),
              chipFg: const Color(0xFF2E7D32),
              count: FutureBuilder<int>(
                future: _contarPendentes(),
                builder: (_, s) => Text('${s.data ?? 0}'),
              ),
              big: 'Pendentes',
              small: 'Agendamentos',
            ),

            const SizedBox(height: 8),

            // Título
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Solicitações de Agendamento',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),

            const SizedBox(height: 12),

            // LISTA
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _buscarSolicitacoesPendentes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                  );
                }

                final itens = snapshot.data ?? [];
                if (itens.isEmpty) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        'Nenhuma solicitação pendente',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: itens.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final it = itens[i];

                    // (4) endereço completo com UF
                    final enderecoLinha = _joinNotEmpty([
                      it['logradouro'],
                      it['numero'],
                    ], sep: ', ');
                    final complementoLinha = _joinNotEmpty([
                      it['bairro'],
                      _joinNotEmpty([it['cidade'], it['estado']], sep: ', '),
                    ]);

                    return Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 4,
                              offset: Offset(0, 2)),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              // (3) centraliza avatar na linha
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 3,
                                  height: 80,
                                  color: const Color(0xFF6F35A5),
                                ),
                                const SizedBox(width: 10),
                                // avatar
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle),
                                    child: Image.network(
                                      'https://picsum.photos/seed/${it['contratante_id']}/150',
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Icon(
                                        Icons.person,
                                        size: 28,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // infos
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        it['contratante_nome'] ?? 'Cliente',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      Text(
                                        _formatarDataHora(it['data_hora']),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 12,
                                            ),
                                      ),
                                      Text(
                                        it['servico_titulo'] ?? 'Serviço',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      // (4) endereço + UF
                                      Text(
                                        _joinNotEmpty(
                                          [enderecoLinha, complementoLinha],
                                          sep: ' • ',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 12,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // preço à direita (5)
                                Text(
                                  _formatarValor(it['servico_preco'] ?? 0.0),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Ações
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _aceitarAgendamento(
                                        it['id'].toString()),
                                    child: SizedBox(
                                      height: 36,
                                      child: Center(
                                        child: Text(
                                          'Aceitar',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                color: const Color(0xFF00C853),
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 20,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText
                                      .withOpacity(0.3),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _recusarAgendamento(
                                        it['id'].toString()),
                                    child: SizedBox(
                                      height: 36,
                                      child: Center(
                                        child: Text(
                                          'Recusar',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                color: const Color(0xFFFF5722),
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
}
