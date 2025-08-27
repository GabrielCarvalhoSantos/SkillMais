// lib/pages/telas_prestador/tabs/services_tab_widget.dart

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';

class ServicesTabWidget extends StatelessWidget {
  final UsuariosRow? user;

  const ServicesTabWidget({Key? key, this.user}) : super(key: key);

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
                  'Meus Serviços',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                ),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(1.0, 0.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        context.pushNamed(NovoServicoWidget.routeName);
                      },
                      text: 'Novo',
                      icon: Icon(Icons.add, size: 20.0),
                      options: FFButtonOptions(
                        height: 40.0,
                        padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: FlutterFlowTheme.of(context).titleSmall,
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.9,
            child: FutureBuilder<List<ServicosRow>>(
              future: ServicosTable().queryRows(
                queryFn: (q) => q.eqOrNull('prestador_id', user?.userId),
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final services = snapshot.data!;
                return ListView.separated(
                  padding: EdgeInsets.all(16),
                  itemCount: services.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16.0),
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return _buildServiceCard(
                      context,
                      service.titulo ?? 'Sem Título',
                      service.descricao ?? 'Sem descrição',
                      service.precoBase?.toString() ?? '0.0'
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context, String title, String description, String price) {
    return Container(
      width: double.infinity,
      height: 120,
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
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                FFButtonWidget(
                  onPressed: () {},
                  text: 'Editar',
                  options: FFButtonOptions(
                    height: 30,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    color: Color(0x00FFFFFF),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Inter Tight',
                      color: FlutterFlowTheme.of(context).success,
                      fontSize: 14.0,
                    ),
                    elevation: 0.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              description,
              style: FlutterFlowTheme.of(context).bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Text(
              'R\$ $price',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}