// lib/custom_code/actions/prestador_actions.dart

import '/backend/supabase/supabase.dart';

// 1. Cadastrar prestador com categoria
Future<String?> cadastrarPrestadorComCategoria({
  required String userId,
  required String nome,
  required String email,
  required String telefone,
  required String categoriaId,
}) async {
  try {
    await UsuariosTable().insert({
      'user_id': userId,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'tipo_usuario': 'prestador',
      'categoria_id': categoriaId,
    });
    return null; // Sucesso
  } catch (e) {
    return 'Erro ao cadastrar prestador: ${e.toString()}';
  }
}

// 2. Buscar prestadores por categoria
Future<List<UsuariosRow>> buscarPrestadoresPorCategoria(
    String categoriaId) async {
  return await UsuariosTable().queryRows(
    queryFn: (q) => q
        .eq('tipo_usuario', 'prestador')
        .eq('categoria_id', categoriaId)
        .not('categoria_id', 'is', null)
        .order('created_at', ascending: false),
  );
}

// 3. Buscar prestadores com dados completos (usando a view)
Future<List<Map<String, dynamic>>> buscarPrestadoresCompletosPorCategoria(
    String categoriaId) async {
  final response = await Supabase.instance.client
      .from('vw_prestadores_por_categoria')
      .select('*')
      .eq('categoria_id', categoriaId)
      .order('media_avaliacoes', ascending: false);

  return List<Map<String, dynamic>>.from(response);
}

// 4. Buscar prestadores próximos por categoria (com distância)
Future<List<Map<String, dynamic>>> buscarPrestadoresProximosPorCategoria({
  required String categoriaId,
  required double latitude,
  required double longitude,
  double raioKm = 50.0,
}) async {
  final response = await Supabase.instance.client.rpc(
    'buscar_prestadores_proximos',
    params: {
      'categoria_id_param': categoriaId,
      'lat_param': latitude,
      'lng_param': longitude,
      'raio_km_param': raioKm,
    },
  );

  return List<Map<String, dynamic>>.from(response ?? []);
}

// 5. Buscar prestador com categoria (para perfil)
Future<Map<String, dynamic>?> buscarPrestadorComCategoria(String userId) async {
  final response = await Supabase.instance.client.from('usuarios').select('''
        *,
        categorias (
          id,
          nome,
          icone,
          descricao
        )
      ''').eq('user_id', userId).eq('tipo_usuario', 'prestador').maybeSingle();

  return response;
}

// 6. Atualizar categoria do prestador
Future<String?> atualizarCategoriaPrestador({
  required String userId,
  required String novaCategoriaId,
}) async {
  try {
    await UsuariosTable().update(
      data: {'categoria_id': novaCategoriaId},
      matchingRows: (rows) => rows.eq('user_id', userId),
    );
    return null; // Sucesso
  } catch (e) {
    return 'Erro ao atualizar categoria: ${e.toString()}';
  }
}

// 7. Buscar prestadores com filtros
Future<List<Map<String, dynamic>>> buscarPrestadoresComFiltros({
  required String categoriaId,
  String? cidade,
  String? estado,
  double? notaMinima,
  bool ordenarPorAvaliacao = false,
}) async {
  // Construir query base
  var queryBuilder = Supabase.instance.client
      .from('vw_prestadores_por_categoria')
      .select('*')
      .eq('categoria_id', categoriaId);

  // Aplicar filtros condicionais
  if (cidade != null && cidade.isNotEmpty) {
    queryBuilder = queryBuilder.ilike('cidade', '%$cidade%');
  }

  if (estado != null && estado.isNotEmpty) {
    queryBuilder = queryBuilder.eq('estado', estado);
  }

  if (notaMinima != null) {
    queryBuilder = queryBuilder.gte('media_avaliacoes', notaMinima);
  }

  // Aplicar ordenação e executar query
  List<Map<String, dynamic>> response;

  if (ordenarPorAvaliacao) {
    response = await queryBuilder
        .order('media_avaliacoes', ascending: false)
        .limit(50);
  } else {
    response =
        await queryBuilder.order('total_servicos', ascending: false).limit(50);
  }

  return response;
}
