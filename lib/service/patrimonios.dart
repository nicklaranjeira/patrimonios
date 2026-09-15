import 'package:get/get.dart';
import '../models/patrimonios.dart';

class PatrimoniosApi extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'http://10.0.2.2:8000';

    httpClient.defaultDecoder = (map) {
      if (map is List) {
        return map.map((item) => Patrimonios.fromJson(item)).toList();
      }

      if (map is Map<String, dynamic>) {
        return Patrimonios.fromJson(map);
      }

      return map;
    };

    super.onInit();
  }

  // GET listagem
  Future<Response<List<Patrimonios>>> listarPatrimonios() async {
    return await get<List<Patrimonios>>('/api/v1/patrimonios');
  }

  // GET busca
  Future<Response<List<Patrimonios>>> pesquisaPatrimonio(String termo) async {
    return await get<List<Patrimonios>>('/api/v1/patrimonios?q=$termo');
  }

  // GET exibição por id
  Future<Response<Patrimonios>> visualizarPatrimonio(String id) async {
    return await get<Patrimonios>('/api/v1/patrimonios/$id');
  }

  // Alias com 'z' para compatibilidade
  Future<Response<Patrimonios>> vizualizarPatrimonio(String id) async {
    return await visualizarPatrimonio(id);
  }

  // POST cadastro
  Future<Response<Patrimonios>> cadastrarPatrimonio(
    Patrimonios patrimonio,
  ) async {
    return await post('/api/v1/patrimonios', patrimonio.toJson());
  }

  // PUT atualizar
  Future<Response<Patrimonios>> atualizarPatrimonio(
    Patrimonios patrimonio,
  ) async {
    return await put(
      '/api/v1/patrimonios/${patrimonio.id}',
      patrimonio.toJson(),
    );
  }

  // DELETE deletar
  Future<Response> excluirPatrimonio(dynamic id) async {
    return await delete('/api/v1/patrimonios/$id');
  }
}

// Alias para garantir compatibilidade caso a classe seja chamada de Patrimonio
typedef Patrimonio = PatrimoniosApi;
