// lib/custom_code/actions/categoria_actions.dart

import '/backend/supabase/supabase.dart';

// 1. Buscar categorias ativas para dropdown
Future<List<CategoriasRow>> buscarCategoriasAtivas() async {
  return await CategoriasTable().queryRows(
    queryFn: (q) => q.eq('ativo', true).order('nome', ascending: true),
  );
}

// 2. Buscar todas as categorias para tela de busca
Future<List<CategoriasRow>> buscarTodasCategorias() async {
  return await CategoriasTable().queryRows(
    queryFn: (q) => q.eq('ativo', true).order('nome', ascending: true),
  );
}

// 3. Contar prestadores por categoria
Future<int> contarPrestadoresPorCategoria(String categoriaId) async {
  final response = await Supabase.instance.client
      .from('usuarios')
      .select('*')
      .eq('tipo_usuario', 'prestador')
      .eq('categoria_id', categoriaId);

  // Contar manualmente os resultados
  return response.length;
}
