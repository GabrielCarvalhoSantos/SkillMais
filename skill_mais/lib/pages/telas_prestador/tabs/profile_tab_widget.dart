// lib/pages/telas_prestador/tabs/profile_tab_widget.dart

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileTabWidget extends StatefulWidget {
  final UsuariosRow? user;
  final bool? switchValue;
  final Function(bool?) onSwitchChanged;

  const ProfileTabWidget({
    Key? key,
    this.user,
    this.switchValue,
    required this.onSwitchChanged,
  }) : super(key: key);

  @override
  State<ProfileTabWidget> createState() => _ProfileTabWidgetState();
}

class _ProfileTabWidgetState extends State<ProfileTabWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.sizeOf(context).height * 0.2,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Image.network(
                  'https://picsum.photos/seed/404/600',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.user?.nome ?? 'null',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Roboto Condensed',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                'Encanador',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Prestador desde ',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  Text(
                    dateTimeFormat("d/M/y", widget.user?.createdAt),
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildProfileStatCard(context, '4.8', 'Avaliações', secondaryValue: '92 Avaliações'),
                    _buildProfileStatCard(context, '156', 'Serviços'),
                    _buildProfileStatCard(context, '12.5K', 'Ganhos'),
                  ],
                ),
                SizedBox(height: 16),
                _buildProfileOptionCard(
                  context,
                  'Modo Escuro',
                  Icons.nights_stay,
                  Color(0xFFA7BAFF),
                  isSwitch: true,
                ),
                SizedBox(height: 16),
                InkWell(
                  onTap: () => context.pushNamed(EnderecosWidget.routeName),
                  child: _buildProfileOptionCard(
                    context,
                    'Meus Endereços',
                    Icons.add_home_work,
                    Color(0xFFFFF1CD),
                  ),
                ),
                SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    GoRouter.of(context).prepareAuthEvent();
                    await authManager.signOut();
                    GoRouter.of(context).clearRedirectLocation();
                    context.goNamedAuth(LoginPageWidget.routeName, context.mounted);
                  },
                  child: _buildProfileOptionCard(
                    context,
                    'Sair',
                    Icons.login_sharp,
                    Color(0xFFFFB8B8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileStatCard(BuildContext context, String value, String label, {String? secondaryValue}) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.28,
      height: 85,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label == 'Ganhos' ? 'R\$ $value' : value,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(
            label,
            style: FlutterFlowTheme.of(context).bodyMedium,
          ),
          if (secondaryValue != null)
            Text(
              secondaryValue,
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
        ],
      ),
    );
  }

  Widget _buildProfileOptionCard(BuildContext context, String text, IconData icon, Color iconBgColor, {bool isSwitch = false}) {
    return Container(
      width: double.infinity,
      height: 60,
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
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 30,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(
                icon,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 20.0,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (isSwitch)
              Switch.adaptive(
                value: widget.switchValue ?? false,
                onChanged: widget.onSwitchChanged,
                activeColor: FlutterFlowTheme.of(context).primary,
              )
            else
              Icon(
                Icons.arrow_forward,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 20.0,
              ),
          ],
        ),
      ),
    );
  }
}