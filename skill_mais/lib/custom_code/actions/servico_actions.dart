// lib/custom_code/actions/servico_actions.dart

import '/backend/supabase/supabase.dart';

// 1. Buscar categoria do prestador logado
Future<String?> buscarCategoriaDoPrestador(String userId) async {
  final response = await UsuariosTable().queryRows(
    queryFn: (q) => q
        .eq('user_id', userId)
        .eq('tipo_usuario', 'prestador')
        .select('categoria_id'),
  );

  return response.isNotEmpty ? response.first.categoriaId : null;
}

// 2. Criar serviço com categoria do prestador (auto-preenchida)
Future<String?> criarServicoComCategoriaPrestador({
  required String prestadorId,
  required String titulo,
  required String descricao,
  required double precoBase,
  String? categoriaEspecifica, // Se null, usa categoria do prestador
}) async {
  try {
    // Buscar categoria do prestador se não foi especificada
    String? categoriaId = categoriaEspecifica;

    if (categoriaId == null) {
      categoriaId = await buscarCategoriaDoPrestador(prestadorId);
      if (categoriaId == null) {
        return 'Prestador não possui categoria definida';
      }
    }

    await ServicosTable().insert({
      'prestador_id': prestadorId,
      'titulo': titulo,
      'descricao': descricao,
      'preco_base': precoBase,
      'categoria_id': categoriaId, // Usa categoria do prestador ou específica
      'ativo': true,
    });

    return null; // Sucesso
  } catch (e) {
    return 'Erro ao criar serviço: ${e.toString()}';
  }
}

// 3. Buscar serviços do prestador com categoria
Future<List<Map<String, dynamic>>> buscarServicosComCategoria(
    String prestadorId) async {
  final response = await Supabase.instance.client
      .from('servicos')
      .select('''
        *,
        categorias (
          id,
          nome,
          icone
        )
      ''')
      .eq('prestador_id', prestadorId)
      .order('created_at', ascending: false);

  return List<Map<String, dynamic>>.from(response);
}

// 4. Verificar se prestador pode criar serviço (tem categoria)
Future<bool> prestadorPodeCriarServico(String userId) async {
  final categoriaId = await buscarCategoriaDoPrestador(userId);
  return categoriaId != null;
}

// 5. Sugerir categoria para novo serviço (categoria do prestador)
Future<Map<String, dynamic>?> sugerirCategoriaParaServico(
    String prestadorId) async {
  final response = await Supabase.instance.client
      .from('usuarios')
      .select('''
        categorias (
          id,
          nome,
          icone
        )
      ''')
      .eq('user_id', prestadorId)
      .eq('tipo_usuario', 'prestador')
      .maybeSingle();

  return response?['categorias'];
}
