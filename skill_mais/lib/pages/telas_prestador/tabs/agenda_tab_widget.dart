// lib/pages/telas_prestador/tabs/agenda_tab_widget.dart

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

class AgendaTabWidget extends StatelessWidget {
  const AgendaTabWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
            child: Row(
              children: [
                Text(
                  'Próximos Agendamentos',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.9,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                  child: Text(
                    'Agendamentos de Hoje',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildAppointmentCard(context, 'Luana Rios', '08:00', '09:30',
                            'Desentupimento', 'Rua das Flores, 127', '120'),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                  child: Text(
                    'Próximos 7 dias',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildUpcomingAppointmentCard(context, '17/08', '09:30',
                            'Instalação de torneiras', 'Marcos Santos', '120'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentCard(BuildContext context, String name, String startTime, String endTime, String service, String address, String price) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 70,
              decoration: BoxDecoration(
                color: Color(0xFF335687),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: 8),
            Container(
              width: 30,
              height: 30,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Image.network(
                'https://picsum.photos/seed/248/600',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    '$startTime • $endTime',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  Text(
                    service,
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  Text(
                    '$address • 2,1 Km',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'R\$ $price',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                FFButtonWidget(
                  onPressed: () {},
                  text: 'Concluir',
                  options: FFButtonOptions(
                    height: 20,
                    padding: EdgeInsets.zero,
                    color: Color(0x00FFFFFF),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Inter Tight',
                      color: FlutterFlowTheme.of(context).success,
                      fontSize: 12.0,
                    ),
                    elevation: 0.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingAppointmentCard(BuildContext context, String date, String time, String service, String client, String price) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 70,
              decoration: BoxDecoration(
                color: Color(0xFF335687),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$date • $time',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  Text(
                    service,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    client,
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ],
              ),
            ),
            Text(
              'R\$ $price',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}