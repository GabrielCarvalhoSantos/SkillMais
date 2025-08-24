import '../database.dart';

class PortfoliosTable extends SupabaseTable<PortfoliosRow> {
  @override
  String get tableName => 'portfolios';

  @override
  PortfoliosRow createRow(Map<String, dynamic> data) => PortfoliosRow(data);
}

class PortfoliosRow extends SupabaseDataRow {
  PortfoliosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PortfoliosTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get servicoId => getField<String>('servico_id')!;
  set servicoId(String value) => setField<String>('servico_id', value);

  String get urlImagem => getField<String>('url_imagem')!;
  set urlImagem(String value) => setField<String>('url_imagem', value);

  String? get descricao => getField<String>('descricao');
  set descricao(String? value) => setField<String>('descricao', value);

  int? get ordem => getField<int>('ordem');
  set ordem(int? value) => setField<int>('ordem', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
