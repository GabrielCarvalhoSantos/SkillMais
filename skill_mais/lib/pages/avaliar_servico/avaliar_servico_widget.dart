import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AvaliarServicoWidget extends StatefulWidget {
  // Parâmetros recebidos da navegação
  final String? agendamentoId;
  final String? servicoId;
  final String? prestadorId;

  const AvaliarServicoWidget({
    Key? key,
    this.agendamentoId,
    this.servicoId,
    this.prestadorId,
  }) : super(key: key);

  static String routeName = 'AvaliarServico';
  static String routePath = '/avaliarServico';

  @override
  State<AvaliarServicoWidget> createState() => _AvaliarServicoWidgetState();
}

class _AvaliarServicoWidgetState extends State<AvaliarServicoWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Controladores do formulário
  double ratingValue = 0.0;
  final TextEditingController comentarioController = TextEditingController();
  final FocusNode comentarioFocusNode = FocusNode();
  
  // Estado de loading
  bool isLoading = false;
  
  // Dados do serviço
  Map<String, dynamic>? dadosServico;
  Map<String, dynamic>? dadosPrestador;
  Map<String, dynamic>? dadosAgendamento;

  @override
  void initState() {
    super.initState();
    _carregarDadosServico();
  }

  @override
  void dispose() {
    comentarioController.dispose();
    comentarioFocusNode.dispose();
    super.dispose();
  }

  // Carregar dados do serviço e prestador
  Future<void> _carregarDadosServico() async {
    try {
      print('Carregando dados - AgendamentoId: ${widget.agendamentoId}, ServicoId: ${widget.servicoId}, PrestadorId: ${widget.prestadorId}');
      
      if (widget.agendamentoId != null) {
        final agendamento = await Supabase.instance.client
            .from('agendamentos')
            .select('*')
            .eq('id', widget.agendamentoId!)
            .maybeSingle();
        
        setState(() {
          dadosAgendamento = agendamento;
        });
        
        print('Agendamento carregado: $agendamento');
      }

      if (widget.servicoId != null) {
        final servico = await Supabase.instance.client
            .from('servicos')
            .select('titulo, descricao')
            .eq('id', widget.servicoId!)
            .maybeSingle();
        
        setState(() {
          dadosServico = servico;
        });
        
        print('Serviço carregado: $servico');
      }

      if (widget.prestadorId != null) {
        final prestador = await Supabase.instance.client
            .from('usuarios')
            .select('nome')
            .eq('user_id', widget.prestadorId!)
            .maybeSingle();
        
        setState(() {
          dadosPrestador = prestador;
        });
        
        print('Prestador carregado: $prestador');
      }
    } catch (e) {
      print('Erro ao carregar dados: $e');
    }
  }

  // Salvar avaliação no banco
  Future<void> _salvarAvaliacao() async {
    if (ratingValue == 0) {
      _mostrarSnackBar('Por favor, selecione uma avaliação', Colors.orange);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final clienteId = currentUserUid;

      print('Tentando salvar avaliação:');
      print('- contratante_id: $clienteId');
      print('- prestador_id: ${widget.prestadorId}');
      print('- servico_id: ${widget.servicoId}');
      print('- agendamento_id: ${widget.agendamentoId}');
      print('- nota: ${ratingValue.toInt()}');
      print('- comentario: ${comentarioController.text.trim()}');

      // Inserir avaliação na tabela avaliacoes
      final response = await Supabase.instance.client.from('avaliacoes').insert({
        'contratante_id': clienteId,
        'prestador_id': widget.prestadorId,
        'servico_id': widget.servicoId,
        'agendamento_id': widget.agendamentoId,
        'nota': ratingValue.toInt(),
        'comentario': comentarioController.text.trim().isEmpty 
            ? null 
            : comentarioController.text.trim(),
        'data': DateTime.now().toIso8601String(),
      });

      print('Resposta do Supabase: $response');

      _mostrarSnackBar('Avaliação enviada com sucesso!', Colors.green);
      
      // Aguardar um pouco e voltar para a tela anterior
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        Navigator.of(context).pop();
      }

    } catch (e) {
      print('Erro detalhado ao salvar avaliação: $e');
      _mostrarSnackBar('Erro ao enviar avaliação: $e', Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Mostrar mensagem para o usuário
  void _mostrarSnackBar(String mensagem, Color cor) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: cor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: false,
        leading: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 30.0,
          ),
        ),
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Container branco com título "Avaliar Serviço"
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
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
                  'Avaliar Serviço',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontSize: 20.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const SizedBox(height: 20.0),
              
              // Card com informações do prestador e serviço
              Expanded(
                child: Container(
                  width: double.infinity,
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
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Avatar e informações do prestador
                        Row(
                          children: [
                            // Avatar do prestador
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).accent1,
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  'https://picsum.photos/seed/${widget.prestadorId}/150',
                                  width: 50.0,
                                  height: 50.0,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.person,
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      size: 30.0,
                                    );
                                  },
                                ),
                              ),
                            ),
                            
                            const SizedBox(width: 12.0),
                            
                            // Nome do prestador e informações
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dadosPrestador?['nome'] ?? 'João Carlos Silva',
                                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    dadosServico?['titulo'] ?? 'Instalação de torneira',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                  Text(
                                    'Concluído em ${dadosAgendamento != null ? DateFormat('dd/MM/yyyy').format(DateTime.parse(dadosAgendamento!['data_hora'])) : '09/06/2025'}',
                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32.0),
                        
                        // Título "Como foi o Serviço"
                        Text(
                          'Como foi o Serviço',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        const SizedBox(height: 16.0),
                        
                        // Rating Bar (1 a 5 estrelas)
                        RatingBar.builder(
                          onRatingUpdate: (newValue) {
                            setState(() {
                              ratingValue = newValue;
                            });
                          },
                          itemBuilder: (context, index) => Icon(
                            Icons.star_rounded,
                            color: Colors.orange,
                          ),
                          direction: Axis.horizontal,
                          initialRating: ratingValue,
                          unratedColor: const Color(0xFFE0E0E0),
                          itemCount: 5,
                          itemSize: 40.0,
                          glowColor: Colors.orange,
                          allowHalfRating: false,
                          minRating: 1,
                        ),
                        
                        const SizedBox(height: 32.0),
                        
                        // Campo de comentário
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Deixe um comentário (Opcional)',
                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 12.0),
                        
                        TextFormField(
                          controller: comentarioController,
                          focusNode: comentarioFocusNode,
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'Digite seu nome completo',
                            hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                            contentPadding: const EdgeInsets.all(16.0),
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            letterSpacing: 0.0,
                          ),
                          maxLines: 4,
                          maxLength: 500,
                        ),
                        
                        const Spacer(),
                        
                        // Botão Avaliar Serviço (azul)
                        FFButtonWidget(
                          onPressed: isLoading ? null : _salvarAvaliacao,
                          text: isLoading ? 'Enviando...' : 'Avaliar Serviço',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 50.0,
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            iconPadding: const EdgeInsets.all(0.0),
                            color: const Color(0xFF4A90E2), // Azul como na imagem
                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                              color: Colors.white,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                            elevation: 3.0,
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                            disabledColor: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}