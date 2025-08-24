import '../database.dart';

class CategoriasTable extends SupabaseTable<CategoriasRow> {
  @override
  String get tableName => 'categorias';

  @override
  CategoriasRow createRow(Map<String, dynamic> data) => CategoriasRow(data);
}

class CategoriasRow extends SupabaseDataRow {
  CategoriasRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CategoriasTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get nome => getField<String>('nome')!;
  set nome(String value) => setField<String>('nome', value);

  String? get descricao => getField<String>('descricao');
  set descricao(String? value) => setField<String>('descricao', value);

  String? get icone => getField<String>('icone');
  set icone(String? value) => setField<String>('icone', value);

  bool? get ativo => getField<bool>('ativo');
  set ativo(bool? value) => setField<bool>('ativo', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
