// lib/pages/telas_cliente/tabs/search_tab_cliente_widget.dart

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/services/search_manager_service.dart';
import 'package:flutter/material.dart';

class SearchTabClienteWidget extends StatefulWidget {
  final TextEditingController? textController;
  final FocusNode? focusNode;
  final Function(String) onCategoriaSelected;
  final VoidCallback onSearch;

  const SearchTabClienteWidget({
    Key? key,
    this.textController,
    this.focusNode,
    required this.onCategoriaSelected,
    required this.onSearch,
  }) : super(key: key);

  @override
  State<SearchTabClienteWidget> createState() => _SearchTabClienteWidgetState();
}

class _SearchTabClienteWidgetState extends State<SearchTabClienteWidget> {
  List<CategoriasRow> _todasCategorias = [];
  List<CategoriasRow> _categoriasFiltradas = [];
  List<String> _pesquisasRecentes = [];
  bool _mostrarSugestoes = false;
  String _ultimaBusca = '';
  final SearchManagerService _searchManager = SearchManagerService();

  @override
  void initState() {
    super.initState();
    _carregarCategorias();
    _carregarPesquisasRecentes();
    widget.textController?.addListener(_onTextChanged);
    widget.focusNode?.addListener(_onFocusChanged);
  }

  Future<void> _carregarPesquisasRecentes() async {
    final recentes = await _searchManager.getRecentSearches();
    setState(() {
      _pesquisasRecentes = recentes;
    });
  }

  Future<void> _adicionarPesquisaRecente(String categoria) async {
    await _searchManager.addRecentSearch(categoria);
    await _carregarPesquisasRecentes();
  }

  Future<void> _limparPesquisasRecentes() async {
    await _searchManager.clearRecentSearches();
    setState(() {
      _pesquisasRecentes = [];
    });
  }

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

  void _onTextChanged() {
    final texto = widget.textController?.text.trim() ?? '';

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

    setState(() {
      _categoriasFiltradas = filtradas;
      _mostrarSugestoes = filtradas.isNotEmpty || texto.length >= 2;
      _ultimaBusca = texto;
    });
  }

  void _onFocusChanged() {
    if (!(widget.focusNode?.hasFocus ?? false)) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          setState(() {
            _mostrarSugestoes = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchHeader(context),
        Expanded(
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.9,
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchField(context),
                    const SizedBox(height: 16.0),
                    _buildRecentSearchesHeader(context),
                    const SizedBox(height: 8.0),
                    Expanded(child: _buildRecentSearchesList(context)),
                  ],
                ),
                if (_mostrarSugestoes)
                  Positioned(
                    top: 60.0,
                    left: 0,
                    right: 0,
                    child: IgnorePointer(
                      ignoring: !_mostrarSugestoes,
                      child: _buildSugestoesCategorias(context),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchHeader(BuildContext context) {
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

  Widget _buildSearchField(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      focusNode: widget.focusNode,
      autofocus: false,
      obscureText: false,
      onFieldSubmitted: (value) => widget.onSearch(),
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
        suffixIcon: (widget.textController?.text.isNotEmpty ?? false)
            ? IconButton(
                icon: const Icon(Icons.send),
                onPressed: widget.onSearch,
              )
            : null,
      ),
      style: FlutterFlowTheme.of(context).bodyMedium,
      cursorColor: FlutterFlowTheme.of(context).primaryText,
    );
  }

  Widget _buildSugestoesCategorias(BuildContext context) {
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
                widget.onCategoriaSelected(categoria.nome);
                // Salvar como pesquisa recente
                _adicionarPesquisaRecente(categoria.nome);
                setState(() {
                  _mostrarSugestoes = false;
                });
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

  Widget _buildRecentSearchesHeader(BuildContext context) {
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
        InkWell(
          onTap: _limparPesquisasRecentes,
          child: Text(
            'Limpar',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  color: FlutterFlowTheme.of(context).error,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSearchesList(BuildContext context) {
    if (_pesquisasRecentes.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma pesquisa recente',
          style: FlutterFlowTheme.of(context).bodyMedium
              .override(color: FlutterFlowTheme.of(context).secondaryText),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: _pesquisasRecentes.map((categoria) {
          return InkWell(
            onTap: () {
              widget.onCategoriaSelected(categoria);
              // Reordena a pesquisa para o topo
              _adicionarPesquisaRecente(categoria);
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
                        categoria,
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
}