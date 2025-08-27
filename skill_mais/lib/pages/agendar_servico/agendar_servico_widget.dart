import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'agendar_servico_model.dart';
export 'agendar_servico_model.dart';

class AgendarServicoWidget extends StatefulWidget {
  const AgendarServicoWidget({
    super.key,
    required this.prestadorId,
  });

  final String prestadorId;

  static String routeName = 'AgendarServico';
  static String routePath = '/agendarServico';

  @override
  State<AgendarServicoWidget> createState() => _AgendarServicoWidgetState();
}

class _AgendarServicoWidgetState extends State<AgendarServicoWidget> {
  late AgendarServicoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AgendarServicoModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Função para carregar dados do prestador e serviços
  Future<Map<String, dynamic>> _loadPrestadorData() async {
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

  String _fmtPreco(dynamic v) {
    if (v == null) return '0,00';
    final n = (v is num) ? v : num.tryParse(v.toString()) ?? 0;
    return n.toStringAsFixed(2).replaceAll('.', ',');
  }

  // Função para selecionar data
  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _model.dataSelecionada ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: FlutterFlowTheme.of(context).primary,
              onPrimary: Colors.white,
              surface: FlutterFlowTheme.of(context).secondaryBackground,
              onSurface: FlutterFlowTheme.of(context).primaryText,
            ),
            dialogBackgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _model.dataSelecionada = picked;
      });
    }
  }

  // Função para agendar serviço
  Future<void> _agendarServico() async {
    final th = FlutterFlowTheme.of(context);
    
    try {
      // Validações obrigatórias - parar no primeiro erro encontrado
      if (_model.servicosSelecionados.isEmpty) {
        _mostrarErro('Por favor, selecione pelo menos um serviço para continuar.');
        return;
      }

      if (_model.dataSelecionada == null) {
        _mostrarErro('Selecione uma data para o agendamento.');
        return;
      }

      if (_model.horarioSelecionado == null) {
        _mostrarErro('Escolha um horário disponível para o serviço.');
        return;
      }

      // Verificar se a data não é no passado
      final hoje = DateTime.now();
      final dataComparacao = DateTime(hoje.year, hoje.month, hoje.day);
      final dataSelecionadaComparacao = DateTime(
        _model.dataSelecionada!.year, 
        _model.dataSelecionada!.month, 
        _model.dataSelecionada!.day
      );
      
      if (dataSelecionadaComparacao.isBefore(dataComparacao)) {
        _mostrarErro('A data selecionada não pode ser anterior à data atual.');
        return;
      }

      // Preparar data e hora
      final horario = _model.horarioSelecionado!.split(':');
      final dataHora = DateTime(
        _model.dataSelecionada!.year,
        _model.dataSelecionada!.month,
        _model.dataSelecionada!.day,
        int.parse(horario[0]),
        int.parse(horario[1]),
      );

      // Verificar se a data/hora não é no passado (para hoje)
      if (dataSelecionadaComparacao.isAtSameMomentAs(dataComparacao) && dataHora.isBefore(DateTime.now())) {
        _mostrarErro('Para hoje, selecione um horário posterior ao atual.');
        return;
      }

      // Obter usuário logado
      final currentUser = currentUserUid;
      if (currentUser == null) {
        _mostrarErro('Usuário não está logado. Faça login para continuar.');
        return;
      }

      // Mostrar loading com context válido
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) => WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: th.secondaryBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(th.primary),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Agendando serviço...',
                    style: th.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Inserir agendamentos para cada serviço selecionado
      for (String servicoId in _model.servicosSelecionados) {
        await Supabase.instance.client.from('agendamentos').insert({
          'contratante_id': currentUser,
          'servico_id': servicoId,
          'data_hora': dataHora.toIso8601String(),
          'status': 'pendente',
          'observacoes': _model.observacoesController.text.trim().isEmpty 
              ? null 
              : _model.observacoesController.text.trim(),
        });
      }

      // Aguardar um pouco para garantir que o salvamento foi processado
      await Future.delayed(const Duration(milliseconds: 500));

      // Fechar loading apenas se o context ainda for válido
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // Aguardar mais um pouco antes de mostrar a confirmação
      await Future.delayed(const Duration(milliseconds: 300));

      // Mostrar confirmação apenas se o context ainda for válido
      if (mounted) {
        _mostrarConfirmacao();
      }

    } catch (e) {
      // Fechar loading se estiver aberto e o context for válido
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      
      if (mounted) {
        _mostrarErro('Erro ao processar agendamento. Tente novamente.');
      }
    }
  }

  // Função para mostrar mensagens de erro padronizadas
  void _mostrarErro(String mensagem) {
    final th = FlutterFlowTheme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: th.secondaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: th.error,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Ops! Algo está faltando',
                textAlign: TextAlign.center,
                style: th.headlineSmall.override(
                  font: GoogleFonts.robotoCondensed(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),
                  color: th.error,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                mensagem,
                textAlign: TextAlign.center,
                style: th.bodyMedium.override(
                  font: GoogleFonts.inter(),
                  color: th.secondaryText,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FFButtonWidget(
                  onPressed: () => Navigator.of(context).pop(),
                  text: 'Entendi',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50,
                    color: th.error,
                    textStyle: th.titleSmall.override(
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
            ],
          ),
        ),
      ),
    );
  }

  // Função para mostrar confirmação
  void _mostrarConfirmacao() {
    final th = FlutterFlowTheme.of(context);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: th.secondaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF142A7B), // Cor primária do app
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Agendamento Realizado!',
                textAlign: TextAlign.center,
                style: th.headlineSmall.override(
                  font: GoogleFonts.robotoCondensed(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),
                  color: th.primaryText,
                  fontSize: 22.0,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Seu serviço foi agendado com sucesso para ${DateFormat('dd/MM/yyyy').format(_model.dataSelecionada!)} às ${_model.horarioSelecionado}.',
                textAlign: TextAlign.center,
                style: th.bodyMedium.override(
                  font: GoogleFonts.inter(),
                  color: th.secondaryText,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FFButtonWidget(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fechar dialog
                    // Navegar para a tela de cliente (início) e limpar o stack
                    context.goNamed('TelasCliente');
                  },
                  text: 'OK',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50,
                    color: const Color(0xFF142A7B), // Mesma cor do botão principal
                    textStyle: th.titleSmall.override(
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
            ],
          ),
        ),
      ),
    );
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
            future: _loadPrestadorData(),
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

              return Column(
                children: [
                  // ===== HEADER =====
                  Container(
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: th.secondaryBackground,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          10.0, 0.0, 10.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 28,
                            buttonSize: 48,
                            icon: Icon(Icons.arrow_back, color: th.primaryText),
                            onPressed: () => context.safePop(),
                          ),
                          const SizedBox(width: 10),
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              'Agendar Serviço',
                              style: th.bodyMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w800,
                                ),
                                color: th.primaryText,
                                fontSize: 22.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ===== CARD DO PRESTADOR =====
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.88,
                    height: 90.0,
                    decoration: BoxDecoration(
                      color: th.secondaryBackground,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          10.0, 0.0, 10.0, 0.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: const NetworkImage(
                                'https://picsum.photos/seed/16/600'),
                            backgroundColor: th.alternate,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nome.isEmpty ? 'Profissional' : nome,
                                style: th.bodyMedium.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  color: th.primaryText,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                categoriaNome ?? 'Profissional',
                                style: th.bodyMedium.override(
                                  font: GoogleFonts.inter(),
                                  color: th.secondaryText,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ===== CONTEÚDO PRINCIPAL =====
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.sizeOf(context).width * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ===== SELEÇÃO DE SERVIÇOS =====
                          Text(
                            'Selecione o Serviço',
                            style: th.bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Lista de serviços dinâmica
                          if (servicos.isEmpty)
                            Container(
                              height: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: th.secondaryBackground,
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: th.alternate,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'Nenhum serviço disponível',
                                style: th.bodyMedium.override(
                                  color: th.secondaryText,
                                ),
                              ),
                            )
                          else
                            ...servicos.map((servico) {
                              final titulo = (servico['titulo'] ??
                                      servico['nome'] ??
                                      '')
                                  .toString();
                              final precoNum = servico['preco'] ??
                                  servico['preco_base'] ??
                                  servico['valor'];
                              final preco = _fmtPreco(precoNum);

                              return Container(
                                height: 70,
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: th.secondaryBackground,
                                  borderRadius: BorderRadius.circular(16.0),
                                  border: Border.all(
                                    color: _model.servicosSelecionados
                                            .contains(servico['id'].toString())
                                        ? th.primary
                                        : th.alternate,
                                    width: _model.servicosSelecionados
                                            .contains(servico['id'].toString())
                                        ? 2
                                        : 1,
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16.0),
                                    onTap: () {
                                      setState(() {
                                        final servicoId =
                                            servico['id'].toString();
                                        if (_model.servicosSelecionados
                                            .contains(servicoId)) {
                                          _model.servicosSelecionados
                                              .remove(servicoId);
                                        } else {
                                          _model.servicosSelecionados
                                              .add(servicoId);
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _model.servicosSelecionados
                                                      .contains(servico['id']
                                                          .toString())
                                                  ? th.primary
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: _model.servicosSelecionados
                                                        .contains(servico['id']
                                                            .toString())
                                                    ? th.primary
                                                    : th.alternate,
                                                width: 2,
                                              ),
                                            ),
                                            child: _model.servicosSelecionados
                                                    .contains(servico['id']
                                                        .toString())
                                                ? const Icon(
                                                    Icons.check,
                                                    size: 14,
                                                    color: Colors.white,
                                                  )
                                                : null,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  titulo.isEmpty
                                                      ? 'Serviço'
                                                      : titulo,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: th.bodyMedium.override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    color: th.primaryText,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'R\$ $preco',
                                                style: th.bodyMedium.override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                  color: th.primary,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),

                          const SizedBox(height: 24),

                          // ===== SELEÇÃO DE DATA =====
                          Text(
                            'Escolha a Data',
                            style: th.bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              color: th.secondaryBackground,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: th.alternate),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => _selecionarData(context),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today,
                                          color: th.primary, size: 24),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _model.dataSelecionada == null
                                              ? 'Selecionar data'
                                              : DateFormat('dd/MM/yyyy')
                                                  .format(_model.dataSelecionada!),
                                          style: th.bodyMedium.override(
                                            font: GoogleFonts.inter(),
                                            color: _model.dataSelecionada == null
                                                ? th.secondaryText
                                                : th.primaryText,
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios,
                                          color: th.secondaryText, size: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ===== SELEÇÃO DE HORÁRIO =====
                          Text(
                            'Escolha o Horário',
                            style: th.bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: ['08:00', '10:00', '14:00', '16:00']
                                .map((horario) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _model.horarioSelecionado = horario;
                                        });
                                      },
                                      child: Container(
                                        width: (MediaQuery.sizeOf(context).width *
                                                0.9 -
                                            12) /
                                            2,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: _model.horarioSelecionado ==
                                                  horario
                                              ? th.primary
                                              : th.secondaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color:
                                                _model.horarioSelecionado ==
                                                        horario
                                                    ? th.primary
                                                    : th.alternate,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            horario,
                                            style: th.bodyMedium.override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                              ),
                                              color:
                                                  _model.horarioSelecionado ==
                                                          horario
                                                      ? Colors.white
                                                      : th.primaryText,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),

                          const SizedBox(height: 24),

                          // ===== OBSERVAÇÕES =====
                          Text(
                            'Observações (Opcional)',
                            style: th.bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: th.secondaryBackground,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: th.alternate),
                            ),
                            child: TextFormField(
                              controller: _model.observacoesController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText:
                                    'Adicione detalhes sobre o serviço...',
                                hintStyle: th.bodyMedium.override(
                                  font: GoogleFonts.inter(),
                                  color: th.secondaryText,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              style: th.bodyMedium.override(
                                font: GoogleFonts.inter(),
                                color: th.primaryText,
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // ===== BOTÃO AGENDAR =====
                          FFButtonWidget(
                            onPressed: _agendarServico,
                            text: 'Agendar Serviço',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 56,
                              color: const Color(0xFF142A7B),
                              textStyle: th.titleSmall.override(
                                font: GoogleFonts.interTight(
                                  fontWeight: FontWeight.w700,
                                ),
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}