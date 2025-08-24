import '../database.dart';

class VwAgendamentosCompletosTable
    extends SupabaseTable<VwAgendamentosCompletosRow> {
  @override
  String get tableName => 'vw_agendamentos_completos';

  @override
  VwAgendamentosCompletosRow createRow(Map<String, dynamic> data) =>
      VwAgendamentosCompletosRow(data);
}

class VwAgendamentosCompletosRow extends SupabaseDataRow {
  VwAgendamentosCompletosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VwAgendamentosCompletosTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  DateTime? get dataHora => getField<DateTime>('data_hora');
  set dataHora(DateTime? value) => setField<DateTime>('data_hora', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get observacoes => getField<String>('observacoes');
  set observacoes(String? value) => setField<String>('observacoes', value);

  double? get valorAcordado => getField<double>('valor_acordado');
  set valorAcordado(double? value) => setField<double>('valor_acordado', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get contratanteId => getField<String>('contratante_id');
  set contratanteId(String? value) => setField<String>('contratante_id', value);

  String? get contratanteNome => getField<String>('contratante_nome');
  set contratanteNome(String? value) =>
      setField<String>('contratante_nome', value);

  String? get contratanteEmail => getField<String>('contratante_email');
  set contratanteEmail(String? value) =>
      setField<String>('contratante_email', value);

  String? get contratanteTelefone => getField<String>('contratante_telefone');
  set contratanteTelefone(String? value) =>
      setField<String>('contratante_telefone', value);

  String? get prestadorId => getField<String>('prestador_id');
  set prestadorId(String? value) => setField<String>('prestador_id', value);

  String? get prestadorNome => getField<String>('prestador_nome');
  set prestadorNome(String? value) => setField<String>('prestador_nome', value);

  String? get prestadorEmail => getField<String>('prestador_email');
  set prestadorEmail(String? value) =>
      setField<String>('prestador_email', value);

  String? get prestadorTelefone => getField<String>('prestador_telefone');
  set prestadorTelefone(String? value) =>
      setField<String>('prestador_telefone', value);

  String? get servicoId => getField<String>('servico_id');
  set servicoId(String? value) => setField<String>('servico_id', value);

  String? get servicoTitulo => getField<String>('servico_titulo');
  set servicoTitulo(String? value) => setField<String>('servico_titulo', value);

  String? get servicoDescricao => getField<String>('servico_descricao');
  set servicoDescricao(String? value) =>
      setField<String>('servico_descricao', value);

  double? get servicoPrecoBase => getField<double>('servico_preco_base');
  set servicoPrecoBase(double? value) =>
      setField<double>('servico_preco_base', value);

  String? get categoriaNome => getField<String>('categoria_nome');
  set categoriaNome(String? value) => setField<String>('categoria_nome', value);
}
