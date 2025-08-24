import '../database.dart';

class ServicosTable extends SupabaseTable<ServicosRow> {
  @override
  String get tableName => 'servicos';

  @override
  ServicosRow createRow(Map<String, dynamic> data) => ServicosRow(data);
}

class ServicosRow extends SupabaseDataRow {
  ServicosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ServicosTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get prestadorId => getField<String>('prestador_id')!;
  set prestadorId(String value) => setField<String>('prestador_id', value);

  String get titulo => getField<String>('titulo')!;
  set titulo(String value) => setField<String>('titulo', value);

  String? get descricao => getField<String>('descricao');
  set descricao(String? value) => setField<String>('descricao', value);

  double get precoBase => getField<double>('preco_base')!;
  set precoBase(double value) => setField<double>('preco_base', value);

  bool? get ativo => getField<bool>('ativo');
  set ativo(bool? value) => setField<bool>('ativo', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String get categoriaId => getField<String>('categoria_id')!;
  set categoriaId(String value) => setField<String>('categoria_id', value);
}
