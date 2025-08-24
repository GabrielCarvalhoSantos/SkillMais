import '../database.dart';

class EnderecosTable extends SupabaseTable<EnderecosRow> {
  @override
  String get tableName => 'enderecos';

  @override
  EnderecosRow createRow(Map<String, dynamic> data) => EnderecosRow(data);
}

class EnderecosRow extends SupabaseDataRow {
  EnderecosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => EnderecosTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get usuarioId => getField<String>('usuario_id')!;
  set usuarioId(String value) => setField<String>('usuario_id', value);

  String get cep => getField<String>('cep')!;
  set cep(String value) => setField<String>('cep', value);

  String get logradouro => getField<String>('logradouro')!;
  set logradouro(String value) => setField<String>('logradouro', value);

  String get numero => getField<String>('numero')!;
  set numero(String value) => setField<String>('numero', value);

  String? get complemento => getField<String>('complemento');
  set complemento(String? value) => setField<String>('complemento', value);

  String get bairro => getField<String>('bairro')!;
  set bairro(String value) => setField<String>('bairro', value);

  String get cidade => getField<String>('cidade')!;
  set cidade(String value) => setField<String>('cidade', value);

  String get estado => getField<String>('estado')!;
  set estado(String value) => setField<String>('estado', value);

  double? get latitude => getField<double>('latitude');
  set latitude(double? value) => setField<double>('latitude', value);

  double? get longitude => getField<double>('longitude');
  set longitude(double? value) => setField<double>('longitude', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
