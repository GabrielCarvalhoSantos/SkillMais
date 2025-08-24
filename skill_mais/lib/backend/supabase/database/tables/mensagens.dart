import '../database.dart';

class MensagensTable extends SupabaseTable<MensagensRow> {
  @override
  String get tableName => 'mensagens';

  @override
  MensagensRow createRow(Map<String, dynamic> data) => MensagensRow(data);
}

class MensagensRow extends SupabaseDataRow {
  MensagensRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MensagensTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get remetenteId => getField<String>('remetente_id')!;
  set remetenteId(String value) => setField<String>('remetente_id', value);

  String get destinatarioId => getField<String>('destinatario_id')!;
  set destinatarioId(String value) =>
      setField<String>('destinatario_id', value);

  String get agendamentoId => getField<String>('agendamento_id')!;
  set agendamentoId(String value) => setField<String>('agendamento_id', value);

  String get conteudo => getField<String>('conteudo')!;
  set conteudo(String value) => setField<String>('conteudo', value);

  bool? get lida => getField<bool>('lida');
  set lida(bool? value) => setField<bool>('lida', value);

  DateTime? get dataHora => getField<DateTime>('data_hora');
  set dataHora(DateTime? value) => setField<DateTime>('data_hora', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
