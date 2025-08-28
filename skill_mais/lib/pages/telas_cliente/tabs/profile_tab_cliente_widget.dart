// lib/pages/telas_cliente/tabs/profile_tab_cliente_widget.dart

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileTabClienteWidget extends StatelessWidget {
  final UsuariosRow? user;

  const ProfileTabClienteWidget({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildProfileHeader(context, user),
        Expanded(
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.88,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 16.0),

                // ÚNICA opção: Sair
                _buildProfileOption(
                  context,
                  icon: Icons.login_sharp,
                  iconColor: FlutterFlowTheme.of(context).primaryText,
                  backgroundColor: const Color(0xFFFFB8B8),
                  title: 'Sair',
                  onTap: () async {
                    final confirmou = await _confirmarSaida(context);
                    if (confirmou == true) {
                      GoRouter.of(context).prepareAuthEvent();
                      await authManager.signOut();
                      GoRouter.of(context).clearRedirectLocation();
                      if (context.mounted) {
                        context.goNamedAuth(
                          LoginPageWidget.routeName,
                          context.mounted,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ======= Header =======
  Widget _buildProfileHeader(BuildContext context, UsuariosRow? user) {
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

  // ======= Option Card =======
  Widget _buildProfileOption(
      BuildContext context, {
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
                    Text(
                      title,
                      style: FlutterFlowTheme.of(context)
                          .bodyMedium
                          .override(fontWeight: FontWeight.w600),
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

  // ======= Modal de confirmação =======
  Future<bool?> _confirmarSaida(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Sair'),
          content: const Text('Tem certeza que deseja sair?'),
          actionsPadding: const EdgeInsets.only(right: 12, bottom: 8),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Não'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                foregroundColor: theme.primaryText, // Corrigido aqui
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
  }
}