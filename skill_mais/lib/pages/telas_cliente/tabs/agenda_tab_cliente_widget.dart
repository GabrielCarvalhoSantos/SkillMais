// lib/pages/telas_cliente/tabs/agenda_tab_cliente_widget.dart

import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';

class AgendaTabClienteWidget extends StatefulWidget {
  const AgendaTabClienteWidget({Key? key}) : super(key: key);

  @override
  State<AgendaTabClienteWidget> createState() => _AgendaTabClienteWidgetState();
}

class _AgendaTabClienteWidgetState extends State<AgendaTabClienteWidget> {
  FormFieldController<String>? dropDownValueController;
  String? dropDownValue;

  @override
  void initState() {
    super.initState();
    dropDownValueController = FormFieldController<String>(null);
  }

  @override
  void dispose() {
    dropDownValueController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAgendaHeader(context),
        Expanded(
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.9,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildResultsHeader(context),
                const SizedBox(height: 20.0),
                Expanded(child: _buildAgendamentosList(context)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgendaHeader(BuildContext context) {
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

  Widget _buildResultsHeader(BuildContext context) {
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
          controller: dropDownValueController,
          options: const ['Próximos', 'Concluídos', 'Cancelados'],
          onChanged: (val) => setState(() => dropDownValue = val),
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

  Widget _buildAgendamentosList(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildAgendamentoCard(
            context,
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
            context,
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
            context,
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

  Widget _buildAgendamentoCard(
    BuildContext context, {
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
                              color: FlutterFlowTheme.of(context).secondaryText,
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
                              color: FlutterFlowTheme.of(context).secondaryText,
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
                              color: FlutterFlowTheme.of(context).secondaryText,
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
                              color: FlutterFlowTheme.of(context).secondaryText,
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
}