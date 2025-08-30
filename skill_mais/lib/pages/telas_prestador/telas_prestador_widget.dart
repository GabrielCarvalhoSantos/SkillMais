// lib/pages/telas_prestador/telas_prestador_widget.dart

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'telas_prestador_model.dart';
import 'tabs/home_tab_widget.dart';
import 'tabs/agenda_tab_widget.dart';
import 'tabs/services_tab_widget.dart';
import 'tabs/profile_tab_widget.dart';
export 'telas_prestador_model.dart';

class TelasPrestadorWidget extends StatefulWidget {
  const TelasPrestadorWidget({super.key});

  static String routeName = 'TelasPrestador';
  static String routePath = '/telasPrestador';

  @override
  State<TelasPrestadorWidget> createState() => _TelasPrestadorWidgetState();
}

class _TelasPrestadorWidgetState extends State<TelasPrestadorWidget>
    with TickerProviderStateMixin {
  late TelasPrestadorModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TelasPrestadorModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 4,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.switchValue = false;
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  void _refreshPage() {
    setState(() {});
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

        final telasPrestadorUsuariosRow = snapshot.data!.isNotEmpty
            ? snapshot.data!.first
            : null;

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
                              HomeTabWidget(
                                user: telasPrestadorUsuariosRow,
                                onShowMessage: _showMessage,
                                onRefresh: _refreshPage,
                              ),
                              
                              // Aba Agenda
                              AgendaTabPrestadorWidget(),
                              
                              // Aba Serviços
                              ServicesTabWidget(
                                user: telasPrestadorUsuariosRow,
                              ),
                              
                              // Aba Perfil
                              ProfileTabWidget(
                                user: telasPrestadorUsuariosRow,
                                switchValue: _model.switchValue,
                                onSwitchChanged: (newValue) {
                                  setState(() {
                                    _model.switchValue = newValue;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        
                        // TabBar na parte inferior
                        Align(
                          alignment: Alignment(0.0, 0),
                          child: TabBar(
                            labelColor: FlutterFlowTheme.of(context).primaryText,
                            unselectedLabelColor:
                                FlutterFlowTheme.of(context).secondaryText,
                            labelStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: 'Inter Tight',
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                ),
                            unselectedLabelStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: 'Inter Tight',
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                ),
                            tabs: [
                              Tab(text: 'Inicio', icon: Icon(Icons.home)),
                              Tab(text: 'Agenda', icon: Icon(Icons.edit_calendar)),
                              Tab(text: 'Serviços', icon: Icon(Icons.home_repair_service)),
                              Tab(text: 'Perfil', icon: Icon(Icons.person)),
                            ],
                            controller: _model.tabBarController,
                            onTap: (i) async {},
                          ),
                        ),
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
}