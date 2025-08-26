import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'profissionais22_model.dart';
export 'profissionais22_model.dart';

class Profissionais22Widget extends StatefulWidget {
  const Profissionais22Widget({
    super.key,
    required this.categoriaSelecionada,
  });

  final String? categoriaSelecionada;

  static String routeName = 'profissionais22';
  static String routePath = '/profissionais22';

  @override
  State<Profissionais22Widget> createState() => _Profissionais22WidgetState();
}

class _Profissionais22WidgetState extends State<Profissionais22Widget> {
  late Profissionais22Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Profissionais22Model());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              // Header com título e subtítulo
              Container(
                width: double.infinity,
                height: 100.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context.safePop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            valueOrDefault<String>(
                              widget.categoriaSelecionada,
                              'Categoria',
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 22.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                          Text(
                            'Encontre o melhor profissional próximo a você.',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontStyle: FontStyle.italic,
                                  ),
                                  letterSpacing: 0.0,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        ].divide(SizedBox(height: 2.0)),
                      ),
                    ),
                  ]
                      .divide(SizedBox(width: 16.0))
                      .around(SizedBox(width: 16.0)),
                ),
              ),
              // Área principal com resultados
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0x19D2D4DE),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 10.0, 16.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Header com "Resultados" e botão "Filtro"
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Resultados',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            FFButtonWidget(
                              onPressed: () {
                                print('Button pressed ...');
                              },
                              text: 'Filtro',
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      font: GoogleFonts.interTight(),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                    ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        // Lista de prestadores
                        Expanded(
                          child: FutureBuilder<List<Map<String, dynamic>>>(
                            future: _buscarPrestadoresComEndereco(
                                widget.categoriaSelecionada),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        FlutterFlowTheme.of(context).primary,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              List<Map<String, dynamic>> listViewPrestadoresList =
                                  snapshot.data!;

                              if (listViewPrestadoresList.isEmpty) {
                                return Center(
                                  child: Text(
                                    'Nenhum prestador encontrado para esta categoria.',
                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                );
                              }

                              return ListView.separated(
                                padding: EdgeInsets.symmetric(vertical: 1.0),
                                itemCount: listViewPrestadoresList.length,
                                separatorBuilder: (_, __) => SizedBox(height: 16.0),
                                itemBuilder: (context, listViewIndex) {
                                  final listViewPrestador =
                                      listViewPrestadoresList[listViewIndex];

                                  return Container(
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 0.0, 10.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          // Foto do prestador
                                          Container(
                                            width: 60.0,
                                            height: 60.0,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context)
                                                  .secondary,
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Container(
                                              width: 200.0,
                                              height: 200.0,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image.network(
                                                'https://picsum.photos/seed/715/600',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                          // Informações do prestador
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  valueOrDefault<String>(
                                                    listViewPrestador['nome']
                                                        ?.toString(),
                                                    'Nome não informado',
                                                  ),
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 18.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                ),
                                                Text(
                                                  valueOrDefault<String>(
                                                    widget.categoriaSelecionada,
                                                    'Categoria',
                                                  ),
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                                Text(
                                                  valueOrDefault<String>(
                                                    listViewPrestador['telefone']
                                                        ?.toString(),
                                                    'Contato não informado',
                                                  ),
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                                Text(
                                                  _formatarCidadeEstado(
                                                    listViewPrestador['cidade'],
                                                    listViewPrestador['estado'],
                                                  ),
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ].divide(SizedBox(height: 3.0)),
                                            ),
                                          ),
                                          SizedBox(width: 8.0),
                                          // Botão Ver Mais
                                          FFButtonWidget(
                                            onPressed: () async {
                                              context.pushNamed(
                                                'DescricaoProfissional',
                                                queryParameters: {
                                                  'prestadorId': serializeParam(
                                                    listViewPrestador['user_id']
                                                        ?.toString(),
                                                    ParamType.String,
                                                  ),
                                                }.withoutNulls,
                                              );
                                            },
                                            text: 'Ver Mais',
                                            options: FFButtonOptions(
                                              height: 32.0,
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                      12.0, 0.0, 12.0, 0.0),
                                              iconPadding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                      0.0, 0.0, 0.0, 0.0),
                                              color: FlutterFlowTheme.of(context)
                                                  .primary,
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        color: Colors.white,
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                      ),
                                              elevation: 2.0,
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
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

  Future<List<Map<String, dynamic>>> _buscarPrestadoresComEndereco(String? nomeCategoria) async {
    if (nomeCategoria == null || nomeCategoria.isEmpty) {
      print('Nome da categoria está vazio ou nulo');
      return [];
    }

    try {
      print('Buscando categoria: $nomeCategoria');
      
      final categorias = await CategoriasTable().queryRows(
        queryFn: (q) => q.eq('nome', nomeCategoria).limit(1),
      );

      if (categorias.isEmpty) {
        print('Categoria não encontrada: $nomeCategoria');
        return [];
      }

      String categoriaId = categorias.first.id;
      print('ID da categoria encontrado: $categoriaId');

      final prestadores = await UsuariosTable().queryRows(
        queryFn: (q) => q
            .eq('tipo_usuario', 'prestador')
            .eq('categoria_id', categoriaId)
            .order('created_at', ascending: false),
      );

      print('Prestadores encontrados: ${prestadores.length}');

      if (prestadores.isEmpty) {
        return [];
      }

      List<Map<String, dynamic>> resultado = [];
      
      for (var prestador in prestadores) {
        Map<String, dynamic> dadosPrestador = {
          'user_id': prestador.userId,
          'nome': prestador.nome,
          'email': prestador.email,
          'telefone': prestador.telefone,
          'tipo_usuario': prestador.tipoUsuario,
          'categoria_id': prestador.categoriaId,
          'created_at': prestador.createdAt,
        };

        try {
          final enderecos = await EnderecosTable().queryRows(
            queryFn: (q) => q.eq('usuario_id', prestador.userId).limit(1),
          );

          if (enderecos.isNotEmpty) {
            dadosPrestador['cidade'] = enderecos.first.cidade;
            dadosPrestador['estado'] = enderecos.first.estado;
          } else {
            dadosPrestador['cidade'] = null;
            dadosPrestador['estado'] = null;
          }
        } catch (e) {
          print('Erro ao buscar endereço para ${prestador.nome}: $e');
          dadosPrestador['cidade'] = null;
          dadosPrestador['estado'] = null;
        }

        resultado.add(dadosPrestador);
      }

      print('Resultado final: ${resultado.length} prestadores processados');
      return resultado;

    } catch (e) {
      print('Erro ao buscar prestadores: $e');
      return [];
    }
  }

  String _formatarCidadeEstado(dynamic cidade, dynamic estado) {
    if (cidade != null && estado != null) {
      return '$cidade, $estado';
    } else if (cidade != null) {
      return cidade.toString();
    } else if (estado != null) {
      return estado.toString();
    } else {
      return 'Localização não informada';
    }
  }
}