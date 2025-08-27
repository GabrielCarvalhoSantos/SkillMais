import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'descricao_profissional_model.dart';
export 'descricao_profissional_model.dart';

class DescricaoProfissionalWidget extends StatefulWidget {
  const DescricaoProfissionalWidget({
    super.key,
    required this.prestadorId, // recebido da Profissionais22
  });

  final String prestadorId;

  static String routeName = 'DescricaoProfissional';
  static String routePath = '/descricaoProfissional';

  @override
  State<DescricaoProfissionalWidget> createState() =>
      _DescricaoProfissionalWidgetState();
}

class _DescricaoProfissionalWidgetState
    extends State<DescricaoProfissionalWidget> {
  static const double _serviceRowHeight = 56.0;

  late DescricaoProfissionalModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DescricaoProfissionalModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _loadData() async {
    final user = await Supabase.instance.client
        .from('usuarios')
        .select('*')
        .eq('user_id', widget.prestadorId)
        .maybeSingle();

    if (user == null) {
      return {
        'user': null,
        'categoriaNome': null,
        'servicos': <Map<String, dynamic>>[],
      };
    }

    String? categoriaNome;
    final categoriaId = user['categoria_id'];
    if (categoriaId != null) {
      final cat = await Supabase.instance.client
          .from('categorias')
          .select('nome')
          .eq('id', categoriaId)
          .maybeSingle();
      categoriaNome = cat?['nome'] as String?;
    }

    final servicos = await Supabase.instance.client
        .from('servicos')
        .select('*')
        .eq('prestador_id', widget.prestadorId)
        .order('created_at', ascending: true);

    return {
      'user': user,
      'categoriaNome': categoriaNome,
      'servicos': servicos,
    };
  }

  int _anosDesde(DateTime inicio) {
    final agora = DateTime.now();
    var anos = agora.year - inicio.year;
    final passou = (agora.month > inicio.month) ||
        (agora.month == inicio.month && agora.day >= inicio.day);
    if (!passou) anos--;
    return anos < 0 ? 0 : anos;
  }

  String _fmtPreco(dynamic v) {
    if (v == null) return '0,00';
    final n = (v is num) ? v : num.tryParse(v.toString()) ?? 0;
    return n.toStringAsFixed(2).replaceAll('.', ',');
  }

  @override
  Widget build(BuildContext context) {
    final th = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: th.primaryBackground,
        body: SafeArea(
          top: true,
          child: FutureBuilder<Map<String, dynamic>>(
            future: _loadData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(th.primary),
                    ),
                  ),
                );
              }

              final data = snapshot.data!;
              final user = data['user'] as Map<String, dynamic>?;
              final categoriaNome = data['categoriaNome'] as String?;
              final servicos =
                  (data['servicos'] as List).cast<Map<String, dynamic>>();

              if (user == null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text('Profissional não encontrado.',
                        style: th.titleMedium),
                  ),
                );
              }

              final nome = (user['nome'] ?? '').toString();
              final sobre = (user['descricao'] ?? '').toString();
              final createdAtStr = (user['created_at'] ?? '').toString();
              final createdAt =
                  DateTime.tryParse(createdAtStr) ?? DateTime.now();
              final anos = _anosDesde(createdAt);

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== HEADER =====
                    Container(
                      color: th.secondaryBackground,
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 8, bottom: 16),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 28,
                              buttonSize: 48,
                              icon: Icon(Icons.arrow_back_rounded,
                                  color: th.primaryText),
                              onPressed: () => context.safePop(),
                            ),
                          ),
                          const SizedBox(height: 6),
                          CircleAvatar(
                            radius: 44,
                            backgroundImage: const NetworkImage(
                                'https://picsum.photos/seed/16/600'),
                            backgroundColor: th.alternate,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            nome.isEmpty ? 'Profissional' : nome,
                            textAlign: TextAlign.center,
                            style: th.headlineMedium.override(
                              font: GoogleFonts.robotoCondensed(
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            categoriaNome ?? 'Profissional',
                            textAlign: TextAlign.center,
                            style: th.bodySmall.override(
                              font: GoogleFonts.inter(
                                fontStyle: FontStyle.italic,
                              ),
                              color: th.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ===== PILLS FORA DO HEADER =====
                    Container(color: th.secondaryBackground, height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const _StatPill(
                            topText: '4.8',
                            bottomLeft: '92',
                            bottomRight: 'Avaliações',
                          ),
                          const SizedBox(width: 12),
                          const _StatPill(
                            topText: '156',
                            bottomLeft: 'Serviços',
                            bottomRight: '',
                          ),
                          const SizedBox(width: 12),
                          _StatPill(
                            topText: '$anos anos',
                            bottomLeft: 'Na Plataforma',
                            bottomRight: '',
                          ),
                        ],
                      ),
                    ),

                    // ===== SOBRE =====
                    const _SectionTitle(title: 'Sobre'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Container(
                        width: double.infinity,
                        constraints:
                            const BoxConstraints(minHeight: 80, maxHeight: 220),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: th.secondaryBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: th.alternate, width: 1),
                        ),
                        child: Text(
                          sobre.isEmpty
                              ? 'Profissional ainda não adicionou uma descrição.'
                              : sobre,
                          textAlign: TextAlign.justify,
                          style: th.bodyMedium.override(
                            font: GoogleFonts.inter(),
                            color: th.secondaryText,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),

                    // ===== SERVIÇOS =====
                    const _SectionTitle(title: 'Principais Serviços'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        children: servicos.isEmpty
                            ? [
                                Container(
                                  width: double.infinity,
                                  height: _serviceRowHeight,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: th.secondaryBackground,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: th.alternate, width: 1),
                                  ),
                                  child: Text('Nenhum serviço cadastrado.',
                                      style: th.bodyMedium),
                                ),
                              ]
                            : List.generate(servicos.length, (i) {
                                final s = servicos[i];
                                final titulo =
                                    (s['titulo'] ?? s['nome'] ?? '').toString();
                                final precoNum =
                                    s['preco'] ?? s['preco_base'] ?? s['valor'];
                                final preco = _fmtPreco(precoNum);

                                return Container(
                                  height: _serviceRowHeight,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: th.secondaryBackground,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: th.alternate, width: 1),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: th.success,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          titulo.isEmpty ? 'Serviço' : titulo,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: th.bodyMedium.override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            preco,
                                            style: th.bodyMedium.override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Reais',
                                            style: th.bodySmall.override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w700,
                                              ),
                                              color: th.secondaryText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                      ),
                    ),

                    const SizedBox(height: 8),
                    // ===== BOTÃO (NAVEGAÇÃO) =====
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: FFButtonWidget(
                        onPressed: () {
                          // >>> Direciona para a tela AgendarServico com o prestadorId <<<
                          context.pushNamed(
                            'AgendarServico', // ou AgendarServicoWidget.routeName se preferir importar a classe
                            queryParameters: {
                              'prestadorId': serializeParam(
                                widget.prestadorId,
                                ParamType.String,
                              ),
                            }.withoutNulls,
                          );
                        },
                        text: 'Agendar Serviço',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 50,
                          color: const Color(0xFF142A7B),
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FontWeight.w700,
                                    ),
                                    color: Colors.white,
                                  ),
                          elevation: 0,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ===== COMPONENTES =====

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final th = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: th.titleMedium.override(
            font: GoogleFonts.robotoCondensed(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.topText,
    required this.bottomLeft,
    required this.bottomRight,
  });

  final String topText;
  final String bottomLeft;
  final String bottomRight;

  @override
  Widget build(BuildContext context) {
    final th = FlutterFlowTheme.of(context);
    return Container(
      width: 112,
      height: 80,
      decoration: BoxDecoration(
        color: th.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: th.alternate.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            topText,
            textAlign: TextAlign.center,
            style: th.bodyMedium.override(
              font: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(bottomLeft, style: th.bodySmall),
              if (bottomRight.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(bottomRight, style: th.bodySmall),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
