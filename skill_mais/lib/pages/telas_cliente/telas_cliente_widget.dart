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
    _model.switchValue = false;
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UsuariosRow>>(
      future: UsuariosTable().querySingleRow(
        queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
      ),
      builder: (context, snapshot) {
        // Loading state
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
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildAgendamentosCard(),
                SizedBox(height: 20.0),
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
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          ),
        ],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Olá, ',
                      style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                    Text(
                      user?.nome ?? 'Usuário',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text('!', style: FlutterFlowTheme.of(context).bodyMedium),
                  ],
                ),
                SizedBox(height: 4.0),
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
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          ),
        ],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width * 0.15,
              height: MediaQuery.sizeOf(context).height * 0.07,
              decoration: BoxDecoration(
                color: Color(0xFFBCD4FF),
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
            SizedBox(width: 16.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Agendamentos',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
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
          SizedBox(height: 16.0),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildCategoriaRow(limit: 3),
                  SizedBox(height: 24.0),
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
          return Center(child: CircularProgressIndicator());
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
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          ),
        ],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            Profissionais22Widget.routeName,
            queryParameters: {
              'categoriaSelecionada': serializeParam(
                categoria.nome,
                ParamType.String,
              ),
            }.withoutNulls,
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: Color(0x4A6FD071),
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
                    return Icon(Icons.category, size: 24.0);
                  },
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              categoria.nome,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontSize: 13.0,
                  ),
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
          return Center(child: CircularProgressIndicator());
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: snapshot.data!.map((categoria) {
            return Container(
              width: 105.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                boxShadow: [
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
                      color: Color(0xFFE8E2F4),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Icon(
                      Icons.plumbing,
                      color: Color(0xFF7A42E4),
                      size: 24.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    categoria.nome,
                    style: FlutterFlowTheme.of(context).bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
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
        Expanded(
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.9,
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSearchField(),
                SizedBox(height: 16.0),
                _buildRecentSearchesHeader(),
                SizedBox(height: 8.0),
                Expanded(
                  child: _buildRecentSearchesList(),
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
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
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
              SizedBox(height: 4.0),
              Text(
                'Ache os melhores profissionais',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontStyle: FontStyle.italic,
                    ),
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
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Buscar por Categoria..',
        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
              color: Color(0xFF9DA3AD),
            ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF9DA3AD),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(100.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).primary,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(100.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(100.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(100.0),
        ),
        filled: true,
        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
        prefixIcon: Icon(Icons.search),
      ),
      style: FlutterFlowTheme.of(context).bodyMedium,
      cursorColor: FlutterFlowTheme.of(context).primaryText,
      validator: _model.textFieldTextControllerValidator?.asValidator(context),
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
    final searchItems = ['Eletricista', 'Encanador', 'Pintor', 'Jardineiro'];

    return Column(
      children: searchItems.map((item) {
        return Container(
          width: double.infinity,
          height: MediaQuery.sizeOf(context).height * 0.07,
          margin: EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 4.0,
                color: Color(0x33000000),
                offset: Offset(0.0, 2.0),
              ),
            ],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(
                  Icons.search_sharp,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                SizedBox(width: 16.0),
                Text(
                  item,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Spacer(),
                Icon(
                  Icons.clear_sharp,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
              ],
            ),
          ),
        );
      }).toList(),
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
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildResultsHeader(),
                SizedBox(height: 20.0),
                Expanded(
                  child: _buildAgendamentosList(),
                ),
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
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
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
        Spacer(),
        FlutterFlowDropDown<String>(
          controller: _model.dropDownValueController ??=
              FormFieldController<String>(null),
          options: ['Próximos', 'Concluídos', 'Cancelados'],
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
          margin: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
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
            corStatus: Color(0x926078FF),
            corBorda: Color(0x926078FF),
          ),
          SizedBox(height: 16.0),
          _buildAgendamentoCard(
            data: 'Hoje',
            hora: '08:00',
            titulo: 'Pintura de quarto',
            prestador: 'Pedro Oliveira',
            categoria: 'Pintor',
            valor: '80',
            status: 'Agendado',
            corStatus: Color(0x926078FF),
            corBorda: Color(0x926078FF),
          ),
          SizedBox(height: 16.0),
          _buildAgendamentoCard(
            data: 'Amanhã',
            hora: '14:00',
            titulo: 'Instalação de Torneira',
            prestador: 'João Carlos',
            categoria: 'Eletricista',
            valor: '80',
            status: 'Pendente',
            corStatus: Color(0xA5FFDC86),
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
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          ),
        ],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Container(
              width: 3.0,
              height: 80.0,
              color: corBorda,
            ),
            SizedBox(width: 16.0),
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
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 12.0,
                            ),
                      ),
                      Text(' • ',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 12.0,
                              )),
                      Text(
                        hora,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 12.0,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    titulo,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        prestador,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 12.0,
                            ),
                      ),
                      Text(' • ',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 12.0,
                              )),
                      Text(
                        categoria,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 12.0,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
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
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontWeight: FontWeight.w800,
                      ),
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
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildProfileOption(
                  icon: Icons.nights_stay,
                  iconColor: FlutterFlowTheme.of(context).primaryText,
                  backgroundColor: Color(0xFFA7BAFF),
                  title: 'Modo Escuro',
                  trailing: Switch.adaptive(
                    value: _model.switchValue!,
                    onChanged: (newValue) async {
                      safeSetState(() => _model.switchValue = newValue);
                    },
                    activeColor: FlutterFlowTheme.of(context).primary,
                    activeTrackColor: FlutterFlowTheme.of(context).primary,
                    inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
                    inactiveThumbColor:
                        FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                ),
                SizedBox(height: 16.0),
                _buildProfileOption(
                  icon: Icons.add_home_work,
                  iconColor: FlutterFlowTheme.of(context).primaryText,
                  backgroundColor: Color(0xFFFFF1CD),
                  title: 'Meus Endereços',
                  onTap: () => context.pushNamed(EnderecosWidget.routeName),
                  trailing: Icon(
                    Icons.arrow_forward,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 20.0,
                  ),
                ),
                SizedBox(height: 16.0),
                _buildProfileOption(
                  icon: Icons.login_sharp,
                  iconColor: FlutterFlowTheme.of(context).primaryText,
                  backgroundColor: Color(0xFFFFB8B8),
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
        boxShadow: [
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
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Image.network(
              'https://picsum.photos/seed/404/600',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            user?.nome ?? 'Usuário',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
          ),
          SizedBox(height: 4.0),
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
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x33000000),
              offset: Offset(0.0, 2.0),
            ),
          ],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 0.1,
                height: MediaQuery.sizeOf(context).height * 0.04,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20.0,
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
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
      labelStyle: FlutterFlowTheme.of(context).titleMedium.override(
            fontSize: 16.0,
          ),
      unselectedLabelStyle: FlutterFlowTheme.of(context).titleMedium.override(
            fontSize: 16.0,
          ),
      tabs: [
        Tab(
          text: 'Inicio',
          icon: Icon(Icons.home),
        ),
        Tab(
          text: 'Pesquisar',
          icon: Icon(Icons.search),
        ),
        Tab(
          text: 'Agenda',
          icon: Icon(Icons.edit_calendar),
        ),
        Tab(
          text: 'Perfil',
          icon: Icon(Icons.person),
        ),
      ],
      controller: _model.tabBarController,
      onTap: (i) async {
        // Ações específicas para cada aba se necessário
        switch (i) {
          case 0:
            // Aba Início
            break;
          case 1:
            // Aba Pesquisar
            break;
          case 2:
            // Aba Agenda
            break;
          case 3:
            // Aba Perfil
            break;
        }
      },
    );
  }
}
