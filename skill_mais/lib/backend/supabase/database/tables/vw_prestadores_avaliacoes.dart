import '../database.dart';

class VwPrestadoresAvaliacoesTable
    extends SupabaseTable<VwPrestadoresAvaliacoesRow> {
  @override
  String get tableName => 'vw_prestadores_avaliacoes';

  @override
  VwPrestadoresAvaliacoesRow createRow(Map<String, dynamic> data) =>
      VwPrestadoresAvaliacoesRow(data);
}

class VwPrestadoresAvaliacoesRow extends SupabaseDataRow {
  VwPrestadoresAvaliacoesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VwPrestadoresAvaliacoesTable();

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get nome => getField<String>('nome');
  set nome(String? value) => setField<String>('nome', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get telefone => getField<String>('telefone');
  set telefone(String? value) => setField<String>('telefone', value);

  int? get totalAvaliacoes => getField<int>('total_avaliacoes');
  set totalAvaliacoes(int? value) => setField<int>('total_avaliacoes', value);

  double? get mediaAvaliacoes => getField<double>('media_avaliacoes');
  set mediaAvaliacoes(double? value) =>
      setField<double>('media_avaliacoes', value);

  int? get totalServicos => getField<int>('total_servicos');
  set totalServicos(int? value) => setField<int>('total_servicos', value);
}
