import 'package:get/get.dart';
import '../models/patrimonios.dart';

class PatrimoniosApi extends GetConnect {
  @override
  void onInit() {
    // 8080 é a porta padrão do servidor de patrimônios
    // No Android emulador usa 10.0.2.2, no Windows/Web usa localhost
    httpClient.baseUrl = GetPlatform.isAndroid
        ? 'http://10.0.2.2:8080'
        : 'http://localhost:8080';
    httpClient.timeout = const Duration(seconds: 10);

    super.onInit();
  }

  /// GET /api/v1/patrimonios - Lista todos os patrimônios
  Future<Response<List<Patrimonios>>> listarPatrimonios() async {
    final response = await get('/api/v1/patrimonios');
    return _parseListResponse(response);
  }

  /// GET /api/v1/patrimonios?q={termo} - Busca patrimônios por termo
  Future<Response<List<Patrimonios>>> pesquisaPatrimonio(String termo) async {
    final response = await get('/api/v1/patrimonios', query: {'q': termo});
    return _parseListResponse(response);
  }

  /// GET /api/v1/patrimonios/{id} - Visualiza detalhes de um patrimônio
  Future<Response<Patrimonios>> visualizarPatrimonio(dynamic id) async {
    final response = await get('/api/v1/patrimonios/$id');
    return _parseSingleResponse(response);
  }

  /// Alias com 'z' para manter compatibilidade
  Future<Response<Patrimonios>> vizualizarPatrimonio(dynamic id) async {
    return await visualizarPatrimonio(id);
  }

  /// POST /api/v1/patrimonios - Cadastra novo patrimônio
  Future<Response<Patrimonios>> cadastrarPatrimonio(
    Patrimonios patrimonio,
  ) async {
    final response = await post('/api/v1/patrimonios', patrimonio.toJson());
    return _parseSingleResponse(response);
  }

  /// PUT /api/v1/patrimonios/{id} - Atualiza um patrimônio existente
  Future<Response<Patrimonios>> atualizarPatrimonio(
    Patrimonios patrimonio,
  ) async {
    final idParaRota = patrimonio.id ?? patrimonio.numeroInventario;
    final response = await put(
      '/api/v1/patrimonios/$idParaRota',
      patrimonio.toJson(),
    );
    return _parseSingleResponse(response);
  }

  /// DELETE /api/v1/patrimonios/{id} - Remove um patrimônio
  Future<Response> excluirPatrimonio(dynamic id) async {
    return await delete('/api/v1/patrimonios/$id');
  }

  /// Decodifica listas mesmo se a API retornar envelope { data: { patrimonios: [...] } }
  Response<List<Patrimonios>> _parseListResponse(Response response) {
    if (!response.isOk || response.body == null) {
      return Response<List<Patrimonios>>(
        statusCode: response.statusCode,
        statusText: response.statusText,
        headers: response.headers,
        body: [],
      );
    }

    final body = response.body;
    List<dynamic>? listaJson;

    if (body is List) {
      listaJson = body;
    } else if (body is Map) {
      if (body['data'] is Map && body['data']['patrimonios'] is List) {
        listaJson = body['data']['patrimonios'] as List<dynamic>;
      } else if (body['data'] is List) {
        listaJson = body['data'] as List<dynamic>;
      } else if (body['patrimonios'] is List) {
        listaJson = body['patrimonios'] as List<dynamic>;
      }
    }

    final lista = listaJson
            ?.map((item) =>
                Patrimonios.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList() ??
        [];

    return Response<List<Patrimonios>>(
      statusCode: response.statusCode,
      statusText: response.statusText,
      headers: response.headers,
      body: lista,
    );
  }

  /// Decodifica um único objeto mesmo se a API retornar envelope { data: { ... } }
  Response<Patrimonios> _parseSingleResponse(Response response) {
    if (!response.isOk || response.body == null) {
      return Response<Patrimonios>(
        statusCode: response.statusCode,
        statusText: response.statusText,
        headers: response.headers,
      );
    }

    final body = response.body;
    Map<String, dynamic>? itemMap;

    if (body is Map) {
      if (body['data'] is Map) {
        itemMap = Map<String, dynamic>.from(body['data'] as Map);
      } else {
        itemMap = Map<String, dynamic>.from(body);
      }
    }

    Patrimonios? patrimonio;
    if (itemMap != null) {
      patrimonio = Patrimonios.fromJson(itemMap);
    }

    return Response<Patrimonios>(
      statusCode: response.statusCode,
      statusText: response.statusText,
      headers: response.headers,
      body: patrimonio,
    );
  }
}

// Alias para garantir compatibilidade
typedef Patrimonio = PatrimoniosApi;
