import '../database.dart';

class AgendamentosTable extends SupabaseTable<AgendamentosRow> {
  @override
  String get tableName => 'agendamentos';

  @override
  AgendamentosRow createRow(Map<String, dynamic> data) => AgendamentosRow(data);
}

class AgendamentosRow extends SupabaseDataRow {
  AgendamentosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AgendamentosTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get contratanteId => getField<String>('contratante_id')!;
  set contratanteId(String value) => setField<String>('contratante_id', value);

  String get servicoId => getField<String>('servico_id')!;
  set servicoId(String value) => setField<String>('servico_id', value);

  DateTime get dataHora => getField<DateTime>('data_hora')!;
  set dataHora(DateTime value) => setField<DateTime>('data_hora', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get observacoes => getField<String>('observacoes');
  set observacoes(String? value) => setField<String>('observacoes', value);

  double? get valorAcordado => getField<double>('valor_acordado');
  set valorAcordado(double? value) => setField<double>('valor_acordado', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
