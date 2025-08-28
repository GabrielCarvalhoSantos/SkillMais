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
                      service,
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

  Widget _buildServiceCard(BuildContext context, ServicosRow service) {
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
                    service.titulo ?? 'Sem Título',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
                FFButtonWidget(
                  onPressed: () async {
                    _showEditServiceModal(context, service);
                  },
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
              service.descricao ?? 'Sem descrição',
              style: FlutterFlowTheme.of(context).bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Text(
              'R\$ ${service.precoBase?.toString() ?? '0.0'}',
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

  void _showEditServiceModal(BuildContext context, ServicosRow service) {
    final theme = FlutterFlowTheme.of(context);
    final titleController = TextEditingController(text: service.titulo);
    final descriptionController = TextEditingController(text: service.descricao);
    final priceController = TextEditingController(text: service.precoBase?.toString() ?? '0.0');

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Editar Serviço',
                  style: theme.headlineSmall.override(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                Text('Título', style: theme.bodyMedium),
                TextFormField(
                  controller: titleController,
                ),
                SizedBox(height: 16),
                Text('Descrição', style: theme.bodyMedium),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                Text('Valor', style: theme.bodyMedium),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancelar'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await Supabase.instance.client
                              .from('servicos')
                              .update({
                                'titulo': titleController.text,
                                'descricao': descriptionController.text,
                                'preco_base': double.tryParse(priceController.text) ?? 0.0,
                              })
                              .eq('id', service.id);

                          Navigator.of(context).pop();
                          (context as Element).reassemble(); 

                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro ao atualizar o serviço: $e')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                        foregroundColor: theme.primaryText,
                      ),
                      child: Text('Salvar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}