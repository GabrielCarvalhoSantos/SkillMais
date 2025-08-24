import '../database.dart';

class AvaliacoesTable extends SupabaseTable<AvaliacoesRow> {
  @override
  String get tableName => 'avaliacoes';

  @override
  AvaliacoesRow createRow(Map<String, dynamic> data) => AvaliacoesRow(data);
}

class AvaliacoesRow extends SupabaseDataRow {
  AvaliacoesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AvaliacoesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get contratanteId => getField<String>('contratante_id')!;
  set contratanteId(String value) => setField<String>('contratante_id', value);

  String get prestadorId => getField<String>('prestador_id')!;
  set prestadorId(String value) => setField<String>('prestador_id', value);

  String get servicoId => getField<String>('servico_id')!;
  set servicoId(String value) => setField<String>('servico_id', value);

  String get agendamentoId => getField<String>('agendamento_id')!;
  set agendamentoId(String value) => setField<String>('agendamento_id', value);

  int get nota => getField<int>('nota')!;
  set nota(int value) => setField<int>('nota', value);

  String? get comentario => getField<String>('comentario');
  set comentario(String? value) => setField<String>('comentario', value);

  DateTime? get dataField => getField<DateTime>('data');
  set dataField(DateTime? value) => setField<DateTime>('data', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
