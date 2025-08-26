import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'telas_cliente_model.dart';
export 'telas_cliente_model.dart';
import '/custom_code/actions/servico_actions.dart'; // Modificação para categoria id

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
  bool _mostrarSugestoes = false;
  String _ultimaBusca = '';

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

    // Listeners do campo de texto/foco
    _model.textFieldTextController!.addListener(_onTextChanged);
    _model.textFieldFocusNode!.addListener(_onFocusChanged);
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
      // print para debug
      // ignore: avoid_print
      print('Categorias carregadas: ${categorias.map((c) => c.nome).toList()}');
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao carregar categorias: $e');
    }
  }

  // Filtrar categorias conforme o usuário digita
  void _onTextChanged() {
    final texto = _model.textFieldTextController!.text.trim();

    if (texto.isEmpty || texto.length < 2) {
      setState(() {
        _categoriasFiltradas = [];
        _mostrarSugestoes = false;
        _ultimaBusca = texto;
      });
      return;
    }

    final filtradas = _todasCategorias
        .where((categoria) {
          final nomeCategoria = categoria.nome.toLowerCase();
          final textoBusca = texto.toLowerCase();
          return nomeCategoria.contains(textoBusca);
        })
        .take(5)
        .toList();

    // ignore: avoid_print
    print('Texto digitado: $texto');
    // ignore: avoid_print
    print('Categorias filtradas: ${filtradas.map((c) => c.nome).toList()}');

    setState(() {
      _categoriasFiltradas = filtradas;
      _mostrarSugestoes = filtradas.isNotEmpty || texto.length >= 2;
      _ultimaBusca = texto;
    });
  }

  // Controlar quando mostrar sugestões baseado no foco
  void _onFocusChanged() {
    if (!_model.textFieldFocusNode!.hasFocus) {
      // Pequeno delay para permitir clique na sugestão
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          setState(() {
            _mostrarSugestoes = false;
          });
        }
      });
    }
  }

  // Selecionar categoria e navegar
  void _selecionarCategoria(String nomeCategoria) {
    // Limpar o campo e esconder sugestões
    _model.textFieldTextController!.text = '';
    setState(() {
      _mostrarSugestoes = false;
      _categoriasFiltradas = [];
    });

    // Remover foco do campo de texto
    FocusScope.of(context).unfocus();

    // ignore: avoid_print
    print('Selecionada categoria: $nomeCategoria');

    // Navegar para tela de prestadores com pequeno delay
    Future.delayed(const Duration(milliseconds: 100), () {
      context.pushNamed(
        'profissionais22',
        queryParameters: {
          'categoriaSelecionada': nomeCategoria,
        },
      );
    });
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
      // ignore: avoid_print
      print('Navegando para categoria: ${categoriaExata.nome}');
      _selecionarCategoria(categoriaExata.nome);
    } else {
      // Mostrar mensagem de categoria não encontrada
      // ignore: avoid_print
      print('Categoria não encontrada: $texto');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Categoria "$texto" não encontrada.'),
          backgroundColor: FlutterFlowTheme.of(context).error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // ===== Navegação comum para qualquer categoria =====
  void _onCategoriaTap(String nomeCategoria) {
    context.pushNamed(
      Profissionais22Widget.routeName,
      queryParameters: {
        'categoriaSelecionada': serializeParam(nomeCategoria, ParamType.String),
      }.withoutNulls,
    );
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
                              _buildHomeTab(telasClienteUsuariosRow),
                              _buildSearchTab(),
                              _buildAgendaTab(),
                              _buildProfileTab(telasClienteUsuariosRow),
                            ],
                          ),
                        ),
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

  // ================ TAB HOME ================
  Widget _buildHomeTab(UsuariosRow? user) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildWelcomeHeader(user),
        Expanded(
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildAgendamentosCard(),
                const SizedBox(height: 20.0),
                _buildCategoriasSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeHeader(UsuariosRow? user) {
    return Container(
      height: 100.0,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          ),
        ],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Olá, ', style: FlutterFlowTheme.of(context).bodyMedium),
                    Text(
                      user?.nome ?? 'Usuário',
                      style: FlutterFlowTheme.of(context)
                          .bodyMedium
                          .override(fontWeight: FontWeight.bold),
                    ),
                    Text('!', style: FlutterFlowTheme.of(context).bodyMedium),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Bem Vindo(a)!',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
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
    );
  }

  Widget _buildAgendamentosCard() {
    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.1,
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width * 0.15,
              height: MediaQuery.sizeOf(context).height * 0.07,
              decoration: BoxDecoration(
                color: const Color(0xFFBCD4FF),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  '2',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Agendamentos',
                    style: FlutterFlowTheme.of(context).bodyMedium),
                Text(
                  'Hoje',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriasSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categorias Principais',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildCategoriaRow(limit: 3),
                  const SizedBox(height: 24.0),
                  _buildCategoriaRowStatic(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriaRow({int limit = 3}) {
    return FutureBuilder<List<CategoriasRow>>(
      future: CategoriasTable().queryRows(
        queryFn: (q) => q.order('nome', ascending: true),
        limit: limit,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: snapshot.data!.map((categoria) {
            return _buildCategoriaCard(categoria);
          }).toList(),
        );
      },
    );
  }

  Widget _buildCategoriaCard(CategoriasRow categoria) {
    return Container(
      width: 105.0,
      height: 100.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          ),
        ],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () => _onCategoriaTap(categoria.nome),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: const Color(0x4A6FD071),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  categoria.icone ?? '',
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.category, size: 24.0);
                  },
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              categoria.nome,
              style:
                  FlutterFlowTheme.of(context).bodyMedium.override(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriaRowStatic() {
    return FutureBuilder<List<CategoriasRow>>(
      future: CategoriasTable().queryRows(
        queryFn: (q) => q.neqOrNull('nome', 'Outros').order('nome'),
        limit: 3,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: snapshot.data!.map((categoria) {
            return InkWell(
              onTap: () => _onCategoriaTap(categoria.nome),
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: 105.0,
                height: 100.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4.0,
                      color: Color(0x33000000),
                      offset: Offset(0.0, 2.0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E2F4),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Icon(
                        Icons.plumbing,
                        color: Color(0xFF7A42E4),
                        size: 24.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      categoria.nome,
                      style: FlutterFlowTheme.of(context).bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // ================ TAB SEARCH ================
  Widget _buildSearchTab() {
    return Column(
      children: [
        _buildSearchHeader(),
        // Importante: toda a área abaixo vira um Stack EXPANDIDO
        Expanded(
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.9,
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                // Conteúdo base (sempre renderizado)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchField(),
                    const SizedBox(height: 16.0),
                    _buildRecentSearchesHeader(),
                    const SizedBox(height: 8.0),
                    // Mantemos a lista sempre presente (atrás das sugestões)
                    Expanded(child: _buildRecentSearchesList()),
                  ],
                ),

                // Sugestões de categorias (sobrepõe o conteúdo, sem empurrar layout)
                if (_mostrarSugestoes)
                  Positioned(
                    // Logo abaixo do campo de busca
                    top: 60.0,
                    left: 0,
                    right: 0,
                    child: IgnorePointer(
                      ignoring: !_mostrarSugestoes,
                      child: _buildSugestoesCategorias(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      height: 100.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pesquisar',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Ache os melhores profissionais',
                style: FlutterFlowTheme.of(context)
                    .bodyMedium
                    .override(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextFormField(
      controller: _model.textFieldTextController,
      focusNode: _model.textFieldFocusNode,
      autofocus: false,
      obscureText: false,
      onFieldSubmitted: (value) => _executarBusca(),
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Buscar por Categoria..',
        hintStyle: FlutterFlowTheme.of(context)
            .labelMedium
            .override(color: const Color(0xFF9DA3AD)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF9DA3AD), width: 0.5),
          borderRadius: BorderRadius.circular(100.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primary, width: 0.5),
          borderRadius: BorderRadius.circular(100.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: FlutterFlowTheme.of(context).error, width: 0.5),
          borderRadius: BorderRadius.circular(100.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: FlutterFlowTheme.of(context).error, width: 0.5),
          borderRadius: BorderRadius.circular(100.0),
        ),
        filled: true,
        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _model.textFieldTextController!.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.send),
                onPressed: _executarBusca,
              )
            : null,
      ),
      style: FlutterFlowTheme.of(context).bodyMedium,
      cursorColor: FlutterFlowTheme.of(context).primaryText,
      validator: _model.textFieldTextControllerValidator?.asValidator(context),
    );
  }

  // Widget para mostrar sugestões de categorias (sobreposição)
  Widget _buildSugestoesCategorias() {
    if (_categoriasFiltradas.isEmpty && _ultimaBusca.length >= 2) {
      return Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.only(top: 8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_off,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 20.0,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  'Nenhuma categoria encontrada para "$_ultimaBusca".',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_categoriasFiltradas.isEmpty) {
      return const SizedBox.shrink();
    }

    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        margin: const EdgeInsets.only(top: 8.0),
        constraints: const BoxConstraints(
          maxHeight: 250.0,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: _categoriasFiltradas.length,
          itemBuilder: (context, index) {
            final categoria = _categoriasFiltradas[index];
            return InkWell(
              onTap: () {
                // ignore: avoid_print
                print('Categoria selecionada: ${categoria.nome}');
                _selecionarCategoria(categoria.nome);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  border: index < _categoriasFiltradas.length - 1
                      ? Border(
                          bottom: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 0.5,
                          ),
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.category_outlined,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 20.0,
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Text(
                        categoria.nome,
                        style: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .override(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Icon(
                      Icons.search,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 16.0,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRecentSearchesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Pesquisar Recentes',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontSize: 16.0,
                fontWeight: FontWeight.w800,
              ),
        ),
        Text(
          'Limpar',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                color: FlutterFlowTheme.of(context).error,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildRecentSearchesList() {
    final categoriasRecentes = _todasCategorias.take(4).toList();

    if (categoriasRecentes.isEmpty) {
      return Center(
        child: Text(
          'Carregando categorias...',
          style: FlutterFlowTheme.of(context).bodyMedium
              .override(color: FlutterFlowTheme.of(context).secondaryText),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: categoriasRecentes.map((categoria) {
          return InkWell(
            onTap: () {
              // ignore: avoid_print
              print('Selecionando categoria do histórico: ${categoria.nome}');
              _selecionarCategoria(categoria.nome);
            },
            child: Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.07,
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4.0,
                    color: Color(0x33000000),
                    offset: Offset(0.0, 2.0),
                  ),
                ],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.history,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 20.0,
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Text(
                        categoria.nome,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 16.0,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ================ TAB AGENDA ================
  Widget _buildAgendaTab() {
    return Column(
      children: [
        _buildAgendaHeader(),
        Expanded(
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.9,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildResultsHeader(),
                const SizedBox(height: 20.0),
                Expanded(child: _buildAgendamentosList()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgendaHeader() {
    return Container(
      height: 100.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          ),
        ],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
        child: Text(
          'Meus Agendamentos',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
        ),
      ),
    );
  }

  Widget _buildResultsHeader() {
    return Row(
      children: [
        Text(
          'Resultados',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
        ),
        const Spacer(),
        FlutterFlowDropDown<String>(
          controller: _model.dropDownValueController ??=
              FormFieldController<String>(null),
          options: const ['Próximos', 'Concluídos', 'Cancelados'],
          onChanged: (val) => safeSetState(() => _model.dropDownValue = val),
          width: MediaQuery.sizeOf(context).width * 0.24,
          height: 40.0,
          textStyle: FlutterFlowTheme.of(context).bodyMedium,
          hintText: 'Filtro',
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 24.0,
          ),
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
          elevation: 2.0,
          borderColor: FlutterFlowTheme.of(context).alternate,
          borderWidth: 2.0,
          borderRadius: 8.0,
          margin: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
          hidesUnderline: true,
          isOverButton: false,
          isSearchable: false,
          isMultiSelect: false,
        ),
      ],
    );
  }

  Widget _buildAgendamentosList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildAgendamentoCard(
            data: 'Hoje',
            hora: '08:00',
            titulo: 'Pintura de quarto',
            prestador: 'Pedro Oliveira',
            categoria: 'Pintor',
            valor: '80',
            status: 'Agendado',
            corStatus: const Color(0x926078FF),
            corBorda: const Color(0x926078FF),
          ),
          const SizedBox(height: 16.0),
          _buildAgendamentoCard(
            data: 'Hoje',
            hora: '08:00',
            titulo: 'Pintura de quarto',
            prestador: 'Pedro Oliveira',
            categoria: 'Pintor',
            valor: '80',
            status: 'Agendado',
            corStatus: const Color(0x926078FF),
            corBorda: const Color(0x926078FF),
          ),
          const SizedBox(height: 16.0),
          _buildAgendamentoCard(
            data: 'Amanhã',
            hora: '14:00',
            titulo: 'Instalação de Torneira',
            prestador: 'João Carlos',
            categoria: 'Eletricista',
            valor: '80',
            status: 'Pendente',
            corStatus: const Color(0xA5FFDC86),
            corBorda: FlutterFlowTheme.of(context).warning,
          ),
        ],
      ),
    );
  }

  Widget _buildAgendamentoCard({
    required String data,
    required String hora,
    required String titulo,
    required String prestador,
    required String categoria,
    required String valor,
    required String status,
    required Color corStatus,
    required Color corBorda,
  }) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.14,
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Container(width: 3.0, height: 80.0, color: corBorda),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        data,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              color:
                                  FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 12.0,
                            ),
                      ),
                      Text(' • ',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryText,
                                fontSize: 12.0,
                              )),
                      Text(
                        hora,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              color:
                                  FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 12.0,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    titulo,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        prestador,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              color:
                                  FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 12.0,
                            ),
                      ),
                      Text(' • ',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryText,
                                fontSize: 12.0,
                              )),
                      Text(
                        categoria,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              color:
                                  FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 12.0,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.23,
                    height: MediaQuery.sizeOf(context).height * 0.025,
                    decoration: BoxDecoration(
                      color: corStatus,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Center(
                      child: Text(
                        status,
                        style:
                            FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  valor,
                  style: FlutterFlowTheme.of(context)
                      .bodyMedium
                      .override(fontWeight: FontWeight.w800),
                ),
                Text(
                  'R\$ / hora',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================ TAB PROFILE ================
  Widget _buildProfileTab(UsuariosRow? user) {
    return Column(
      children: [
        _buildProfileHeader(user),
        Expanded(
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.88,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 16.0),
                _buildProfileOption(
                  icon: Icons.add_home_work,
                  iconColor: FlutterFlowTheme.of(context).primaryText,
                  backgroundColor: const Color(0xFFFFF1CD),
                  title: 'Meus Endereços',
                  onTap: () => context.pushNamed(EnderecosWidget.routeName),
                  trailing: Icon(
                    Icons.arrow_forward,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 20.0,
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildProfileOption(
                  icon: Icons.login_sharp,
                  iconColor: FlutterFlowTheme.of(context).primaryText,
                  backgroundColor: const Color(0xFFFFB8B8),
                  title: 'Sair',
                  onTap: () async {
                    GoRouter.of(context).prepareAuthEvent();
                    await authManager.signOut();
                    GoRouter.of(context).clearRedirectLocation();
                    context.goNamedAuth(
                        LoginPageWidget.routeName, context.mounted);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(UsuariosRow? user) {
    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.2,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width * 0.18,
            height: MediaQuery.sizeOf(context).width * 0.18,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Image.network(
              'https://picsum.photos/seed/404/600',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            user?.nome ?? 'Usuário',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
          ),
          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Cliente desde ',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
              ),
              Text(
                user?.createdAt != null
                    ? dateTimeFormat("d/M/y", user!.createdAt)
                    : 'N/A',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height * 0.08,
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 0.1,
                height: MediaQuery.sizeOf(context).height * 0.04,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(icon, color: iconColor, size: 20.0),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .override(fontWeight: FontWeight.w600)),
                    if (trailing != null) trailing,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================ TAB BAR ================
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
