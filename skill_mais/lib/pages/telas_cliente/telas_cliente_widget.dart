// lib/pages/telas_cliente/telas_cliente_widget.dart

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'telas_cliente_model.dart';
import 'tabs/home_tab_cliente_widget.dart';
import 'tabs/search_tab_cliente_widget.dart';
import 'tabs/agenda_tab_cliente_widget.dart';
import 'tabs/profile_tab_cliente_widget.dart';
export 'telas_cliente_model.dart';

class TelasClienteWidget extends StatefulWidget {
  const TelasClienteWidget({super.key});

  static String routeName = 'TelasCliente';
  static String routePath = '/telasCliente';

  @override
  State<TelasClienteWidget> createState() => _TelasClienteWidgetState();
}

class _TelasClienteWidgetState extends State<TelasClienteWidget>
    with TickerProviderStateMixin {
  late TelasClienteModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Variáveis para busca de categorias
  List<CategoriasRow> _todasCategorias = [];
  List<CategoriasRow> _categoriasFiltradas = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TelasClienteModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 4,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.textFieldTextController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    // Carregar todas as categorias na inicialização
    _carregarCategorias();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Carregar todas as categorias do banco
  Future<void> _carregarCategorias() async {
    try {
      final categorias = await CategoriasTable().queryRows(
        queryFn: (q) => q.eq('ativo', true).order('nome', ascending: true),
      );
      setState(() {
        _todasCategorias = categorias;
      });
    } catch (e) {
      print('Erro ao carregar categorias: $e');
    }
  }

  // Executar busca ao pressionar Enter ou botão de busca
  void _executarBusca() {
    final texto = _model.textFieldTextController!.text.trim();
    if (texto.isEmpty) return;

    CategoriasRow? categoriaExata =
        _todasCategorias.cast<CategoriasRow?>().firstWhere(
              (categoria) => categoria?.nome.toLowerCase() == texto.toLowerCase(),
              orElse: () => null,
            );

    if (categoriaExata == null && _categoriasFiltradas.isNotEmpty) {
      categoriaExata = _categoriasFiltradas.first;
    }

    if (categoriaExata != null) {
      _selecionarCategoria(categoriaExata.nome);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Categoria "$texto" não encontrada.'),
          backgroundColor: FlutterFlowTheme.of(context).error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Selecionar categoria e navegar
  void _selecionarCategoria(String nomeCategoria) {
    // Limpar o campo e esconder sugestões
    _model.textFieldTextController!.text = '';

    // Remover foco do campo de texto
    FocusScope.of(context).unfocus();

    // Navegar para tela de prestadores com pequeno delay
    Future.delayed(const Duration(milliseconds: 100), () {
      context.pushNamed(
        Profissionais22Widget.routeName,
        queryParameters: {
          'categoriaSelecionada': serializeParam(nomeCategoria, ParamType.String),
        }.withoutNulls,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UsuariosRow>>(
      future: UsuariosTable().querySingleRow(
        queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }

        final telasClienteUsuariosRow =
            snapshot.data!.isNotEmpty ? snapshot.data!.first : null;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: SafeArea(
              top: true,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: TabBarView(
                            controller: _model.tabBarController,
                            children: [
                              // Aba Home
                              HomeTabClienteWidget(
                                user: telasClienteUsuariosRow,
                                onCategoriaSelected: _selecionarCategoria,
                              ),
                              
                              // Aba Search
                              SearchTabClienteWidget(
                                textController: _model.textFieldTextController,
                                focusNode: _model.textFieldFocusNode,
                                onCategoriaSelected: _selecionarCategoria,
                                onSearch: _executarBusca,
                              ),
                              
                              // Aba Agenda
                              AgendaTabClienteWidget(),
                              
                              // Aba Profile
                              ProfileTabClienteWidget(
                                user: telasClienteUsuariosRow,
                              ),
                            ],
                          ),
                        ),
                        
                        // TabBar na parte inferior
                        _buildTabBar(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      labelColor: FlutterFlowTheme.of(context).primaryText,
      unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
      labelStyle:
          FlutterFlowTheme.of(context).titleMedium.override(fontSize: 16.0),
      unselectedLabelStyle:
          FlutterFlowTheme.of(context).titleMedium.override(fontSize: 16.0),
      tabs: const [
        Tab(text: 'Inicio', icon: Icon(Icons.home)),
        Tab(text: 'Pesquisar', icon: Icon(Icons.search)),
        Tab(text: 'Agenda', icon: Icon(Icons.edit_calendar)),
        Tab(text: 'Perfil', icon: Icon(Icons.person)),
      ],
      controller: _model.tabBarController,
      onTap: (i) async {
        // Espaço para ações específicas por aba, se necessário
      },
    );
  }
}