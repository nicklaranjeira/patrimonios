import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/patrimonios.dart';

class PatrimoniosApi extends GetConnect {
  PatrimoniosApi() {
    _configurar();
  }

  @override
  void onInit() {
    _configurar();
    super.onInit();
  }

  void _configurar() {
    // No Android Emulator nativo usa 10.0.2.2. No Web e Desktop usa localhost
    final host = (GetPlatform.isAndroid && !kIsWeb) ? '10.0.2.2' : 'localhost';
    httpClient.baseUrl = 'http://$host:8000';
    httpClient.timeout = const Duration(seconds: 10);
  }

  /// Tenta primeiro a rota com /api/v1/patrimonios. Se retornar 404, tenta /patrimonios
  Future<Response> _tentarRotas({
    required String metodo,
    required String rotaPrincipal,
    dynamic corpo,
    Map<String, dynamic>? query,
  }) async {
    final rotaAlternativa = rotaPrincipal.replaceFirst('/api/v1', '');

    Response res;
    switch (metodo) {
      case 'GET':
        res = await get(rotaPrincipal, query: query);
        if (res.statusCode == 404) {
          res = await get(rotaAlternativa, query: query);
        }
        break;
      case 'POST':
        res = await post(rotaPrincipal, corpo);
        if (res.statusCode == 404) {
          res = await post(rotaAlternativa, corpo);
        }
        break;
      case 'PUT':
        res = await put(rotaPrincipal, corpo);
        if (res.statusCode == 404) {
          res = await put(rotaAlternativa, corpo);
        }
        break;
      case 'DELETE':
        res = await delete(rotaPrincipal);
        if (res.statusCode == 404) {
          res = await delete(rotaAlternativa);
        }
        break;
      default:
        res = await get(rotaPrincipal);
    }
    return res;
  }

  /// GET /api/v1/patrimonios ou /patrimonios - Lista todos os patrimônios
  Future<Response<List<Patrimonios>>> listarPatrimonios() async {
    final response = await _tentarRotas(
      metodo: 'GET',
      rotaPrincipal: '/api/v1/patrimonios',
    );
    return _parseListResponse(response);
  }

  /// GET /api/v1/patrimonios?q={termo} ou /patrimonios?q={termo} - Busca por termo
  Future<Response<List<Patrimonios>>> pesquisaPatrimonio(String termo) async {
    final response = await _tentarRotas(
      metodo: 'GET',
      rotaPrincipal: '/api/v1/patrimonios',
      query: {'q': termo},
    );
    return _parseListResponse(response);
  }

  /// GET /api/v1/patrimonios/{id} ou /patrimonios/{id} - Detalhes
  Future<Response<Patrimonios>> visualizarPatrimonio(dynamic id) async {
    final response = await _tentarRotas(
      metodo: 'GET',
      rotaPrincipal: '/api/v1/patrimonios/$id',
    );
    return _parseSingleResponse(response);
  }

  /// Alias com 'z' para compatibilidade
  Future<Response<Patrimonios>> vizualizarPatrimonio(dynamic id) async {
    return await visualizarPatrimonio(id);
  }

  /// POST /api/v1/patrimonios ou /patrimonios - Cadastra novo patrimônio
  Future<Response<Patrimonios>> cadastrarPatrimonio(
    Patrimonios patrimonio,
  ) async {
    final payload = patrimonio.toJson();
    final response = await _tentarRotas(
      metodo: 'POST',
      rotaPrincipal: '/api/v1/patrimonios',
      corpo: payload,
    );
    return _parseSingleResponse(response);
  }

  /// PUT /api/v1/patrimonios/{id} ou /patrimonios/{id} - Atualiza patrimônio
  Future<Response<Patrimonios>> atualizarPatrimonio(
    Patrimonios patrimonio,
  ) async {
    final idParaRota = patrimonio.id ?? patrimonio.numeroInventario;
    final payload = patrimonio.toJson();
    final response = await _tentarRotas(
      metodo: 'PUT',
      rotaPrincipal: '/api/v1/patrimonios/$idParaRota',
      corpo: payload,
    );
    return _parseSingleResponse(response);
  }

  /// DELETE /api/v1/patrimonios/{id} ou /patrimonios/{id} - Exclui patrimônio
  Future<Response> excluirPatrimonio(dynamic id) async {
    return await _tentarRotas(
      metodo: 'DELETE',
      rotaPrincipal: '/api/v1/patrimonios/$id',
    );
  }

  /// Decodifica listas com ou sem envelope data
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

  /// Decodifica único objeto com ou sem envelope data
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

// Alias para compatibilidade
typedef Patrimonio = PatrimoniosApi;
