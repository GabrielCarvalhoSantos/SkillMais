// lib/pages/telas_cliente/tabs/home_tab_cliente_widget.dart

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

class HomeTabClienteWidget extends StatelessWidget {
  final UsuariosRow? user;
  final Function(String) onCategoriaSelected;

  const HomeTabClienteWidget({
    Key? key,
    this.user,
    required this.onCategoriaSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildWelcomeHeader(context, user),
        Expanded(
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildAgendamentosCard(context),
                const SizedBox(height: 20.0),
                _buildCategoriasSection(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, UsuariosRow? user) {
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

  // Modificado: Card de agendamentos agora busca dados reais
  Widget _buildAgendamentosCard(BuildContext context) {
    return FutureBuilder<int>(
      future: _buscarQuantidadeAgendamentosHoje(),
      builder: (context, snapshot) {
        int quantidade = 0;
        
        if (snapshot.hasData) {
          quantidade = snapshot.data ?? 0;
        }

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
                    child: snapshot.connectionState == ConnectionState.waiting
                        ? const CircularProgressIndicator(strokeWidth: 2.0)
                        : Text(
                            '$quantidade',
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
      },
    );
  }

  // Função para buscar quantidade de agendamentos hoje
  Future<int> _buscarQuantidadeAgendamentosHoje() async {
    try {
      final userId = currentUserUid;

      final hoje = DateTime.now();
      final inicioDoDia = DateTime(hoje.year, hoje.month, hoje.day);
      final fimDoDia = inicioDoDia.add(const Duration(days: 1));

      final agendamentos = await Supabase.instance.client
          .from('agendamentos')
          .select('id')
          .eq('contratante_id', userId)
          .gte('data_hora', inicioDoDia.toIso8601String())
          .lt('data_hora', fimDoDia.toIso8601String());

      return agendamentos.length;
    } catch (e) {
      debugPrint('Erro ao buscar agendamentos hoje: $e');
      return 0;
    }
  }

  Widget _buildCategoriasSection(BuildContext context) {
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
                  _buildCategoriaRow(context, limit: 3),
                  const SizedBox(height: 24.0),
                  _buildCategoriaRowWithImages(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriaRow(BuildContext context, {int limit = 3}) {
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
            return _buildCategoriaCard(context, categoria);
          }).toList(),
        );
      },
    );
  }

  Widget _buildCategoriaCard(BuildContext context, CategoriasRow categoria) {
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
        onTap: () => onCategoriaSelected(categoria.nome),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50.0,
              height: 50.0,
              child: _getCategoriaIcon(categoria.nome),
            ),
            const SizedBox(height: 8.0),
            Text(
              categoria.nome,
              style: FlutterFlowTheme.of(context).bodyMedium.override(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Modificado: Segunda linha de categorias com imagens específicas
  Widget _buildCategoriaRowWithImages(BuildContext context) {
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
            return _buildCategoriaCardWithSpecificImage(context, categoria);
          }).toList(),
        );
      },
    );
  }

  // Função para obter ícone específico baseado no nome da categoria
  Widget _getCategoriaIcon(String nomeCategoria) {
    switch (nomeCategoria.toLowerCase()) {
      case 'automobilística':
      case 'automobilistica':
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 98, 89, 255), // Verde para automobilística
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Icon(
            Icons.directions_car,
            color: Colors.white,
            size: 24.0,
          ),
        );
      case 'costura':
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 98, 89, 255), // Verde para costura
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Icon(
            Icons.content_cut,
            color: Colors.white,
            size: 24.0,
          ),
        );
      case 'elétrica':
      case 'eletrica':
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 98, 89, 255), // Verde para elétrica
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Icon(
            Icons.electrical_services,
            color: Colors.white,
            size: 24.0,
          ),
        );
      case 'tecnologia':
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 98, 89, 255),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Icon(
            Icons.computer,
            color: Colors.white,
            size: 24.0,
          ),
        );
      case 'pintura':
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 98, 89, 255),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Icon(
            Icons.brush,
            color: Colors.white,
            size: 24.0,
          ),
        );
      case 'marcenaria':
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 98, 89, 255),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Icon(
            Icons.handyman,
            color: Colors.white,
            size: 24.0,
          ),
        );
      default:
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE8E2F4),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Icon(
            Icons.category,
            color: Color(0xFF7A42E4),
            size: 24.0,
          ),
        );
    }
  }

  Widget _buildCategoriaCardWithSpecificImage(BuildContext context, CategoriasRow categoria) {
    return InkWell(
      onTap: () => onCategoriaSelected(categoria.nome),
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
              child: _getCategoriaIcon(categoria.nome),
            ),
            const SizedBox(height: 8.0),
            Text(
              categoria.nome,
              style: FlutterFlowTheme.of(context).bodyMedium.override(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}