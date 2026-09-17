import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/patrimonios.dart';
import '../service/patrimonios.dart';

class PatrimoniosController extends GetxController {
  // Instância da Service GetConnect
  final PatrimoniosApi api = Get.put(PatrimoniosApi());

  // Lista reativa de patrimônios
  final RxList<Patrimonios> patrimonios = <Patrimonios>[].obs;

  // Controle de carregamento
  final RxBool isLoading = false.obs;

  // Mensagem de erro reativa
  final RxString erro = ''.obs;

  // Campo de texto de pesquisa
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    listarPatrimonios();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// GET /api/v1/patrimonios
  Future<void> listarPatrimonios() async {
    try {
      isLoading.value = true;
      erro.value = '';

      final resposta = await api.listarPatrimonios();

      if (resposta.statusCode == 200 || resposta.statusCode == 201) {
        patrimonios.assignAll(resposta.body ?? []);
      } else {
        erro.value = 'Erro ao carregar patrimônios (${resposta.statusCode})';
      }
    } catch (e) {
      erro.value = 'Erro de conexão com o servidor. Verifique se a API está ativa.';
    } finally {
      isLoading.value = false;
    }
  }

  /// GET /api/v1/patrimonios?q={termo}
  Future<void> pesquisar(String termo) async {
    final query = termo.trim();
    if (query.isEmpty) {
      return listarPatrimonios();
    }

    try {
      isLoading.value = true;
      erro.value = '';

      final resposta = await api.pesquisaPatrimonio(query);

      if (resposta.statusCode == 200 || resposta.statusCode == 201) {
        patrimonios.assignAll(resposta.body ?? []);
      } else {
        erro.value = 'Erro ao pesquisar patrimônio';
      }
    } catch (e) {
      erro.value = 'Erro de conexão com a API';
    } finally {
      isLoading.value = false;
    }
  }

  /// Limpar pesquisa e recarregar lista completa
  void limparPesquisa() {
    searchController.clear();
    listarPatrimonios();
  }

  /// GET /api/v1/patrimonios/{id}
  Future<Patrimonios?> visualizar(dynamic id) async {
    try {
      erro.value = '';
      final resposta = await api.visualizarPatrimonio(id);

      if (resposta.statusCode == 200 || resposta.statusCode == 201) {
        return resposta.body;
      }

      erro.value = 'Patrimônio não encontrado';
      return null;
    } catch (e) {
      erro.value = 'Erro ao buscar patrimônio';
      return null;
    }
  }

  /// POST /api/v1/patrimonios
  Future<bool> cadastrar(Patrimonios patrimonio) async {
    try {
      isLoading.value = true;
      erro.value = '';

      final resposta = await api.cadastrarPatrimonio(patrimonio);

      if (resposta.statusCode == 200 || resposta.statusCode == 201) {
        await listarPatrimonios();
        Get.snackbar(
          'Sucesso',
          'Patrimônio cadastrado com sucesso!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return true;
      }

      final mensagemErro = resposta.statusText ?? 'Falha no cadastro';
      erro.value = 'Erro ao cadastrar patrimônio: $mensagemErro (${resposta.statusCode})';
      Get.snackbar(
        'Erro ao cadastrar',
        erro.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    } catch (e) {
      erro.value = 'Erro de conexão ao cadastrar: $e';
      Get.snackbar(
        'Erro de Conexão',
        erro.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// PUT /api/v1/patrimonios/{id}
  Future<bool> atualizar(Patrimonios patrimonio) async {
    try {
      isLoading.value = true;
      erro.value = '';

      final resposta = await api.atualizarPatrimonio(patrimonio);

      if (resposta.statusCode == 200 || resposta.statusCode == 201) {
        await listarPatrimonios();
        Get.snackbar(
          'Sucesso',
          'Patrimônio atualizado com sucesso!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return true;
      }

      erro.value = 'Erro ao atualizar patrimônio (${resposta.statusCode})';
      Get.snackbar(
        'Erro',
        erro.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    } catch (e) {
      erro.value = 'Erro de conexão com a API';
      Get.snackbar(
        'Erro',
        erro.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// DELETE /api/v1/patrimonios/{id}
  Future<bool> excluir(dynamic id) async {
    try {
      isLoading.value = true;
      erro.value = '';

      final resposta = await api.excluirPatrimonio(id);

      if (resposta.statusCode == 200 || resposta.statusCode == 204) {
        patrimonios.removeWhere((p) =>
            p.id?.toString() == id.toString() ||
            p.numeroInventario == id.toString());
        Get.snackbar(
          'Sucesso',
          'Patrimônio excluído com sucesso!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade800,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return true;
      }

      erro.value = 'Erro ao excluir patrimônio (${resposta.statusCode})';
      Get.snackbar(
        'Erro',
        erro.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    } catch (e) {
      erro.value = 'Erro de conexão com a API';
      Get.snackbar(
        'Erro',
        erro.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
