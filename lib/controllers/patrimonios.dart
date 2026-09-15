import 'package:get/get.dart';

import '../models/patrimonios.dart';
import '../service/patrimonios.dart';

class PatrimoniosController extends GetxController {
  // Instância da Service
  final Patrimonios api = Patrimonios();

  // Lista de patrimônios
  final RxList<Patrimonios> patrimonios = <Patrimonios>[].obs;

  // Controla o carregamento
  final RxBool isLoading = false.obs;

  // Mensagem de erro
  final RxString erro = ''.obs;

  // Executado quando o Controller é iniciado
  @override
  void onInit() {
    super.onInit();

    listarPatrimonios();
  }

  // GET - Listar patrimônios
  Future<void> listarPatrimonios() async {
    try {
      isLoading.value = true;
      erro.value = '';

      final resposta = await api.listarPatrimonios();

      if (resposta.statusCode == 200) {
        patrimonios.assignAll(resposta.body ?? []);
      } else {
        erro.value = 'Erro ao carregar patrimônios';
      }
    } catch (e) {
      erro.value = 'Erro de conexão com a API';
    } finally {
      isLoading.value = false;
    }
  }

  // GET - Pesquisar patrimônio
  Future<void> pesquisar(String termo) async {
    try {
      isLoading.value = true;
      erro.value = '';

      final resposta = await api.pesquisaPatrimonio(termo);

      if (resposta.statusCode == 200) {
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

  // GET - Visualizar patrimônio por ID
  Future<Patrimonios?> visualizar(String id) async {
    try {
      final resposta = await api.visualizarPatrimonio(id);

      if (resposta.statusCode == 200) {
        return resposta.body;
      }

      erro.value = 'Patrimônio não encontrado';
      return null;
    } catch (e) {
      erro.value = 'Erro ao buscar patrimônio';
      return null;
    }
  }

  // POST - Cadastrar patrimônio
  Future<bool> cadastrar(Patrimonios patrimonio) async {
    try {
      isLoading.value = true;
      erro.value = '';

      final resposta = await api.cadastrarPatrimonio(patrimonio);

      if (resposta.statusCode == 200 || resposta.statusCode == 201) {
        await listarPatrimonios();
        return true;
      }

      erro.value = 'Erro ao cadastrar patrimônio';
      return false;
    } catch (e) {
      erro.value = 'Erro de conexão com a API';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // PUT - Atualizar patrimônio
  Future<bool> atualizar(Patrimonios patrimonio) async {
    try {
      isLoading.value = true;
      erro.value = '';

      final resposta = await api.atualizarPatrimonio(patrimonio);

      if (resposta.statusCode == 200) {
        await listarPatrimonios();
        return true;
      }

      erro.value = 'Erro ao atualizar patrimônio';
      return false;
    } catch (e) {
      erro.value = 'Erro de conexão com a API';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // DELETE - Excluir patrimônio
  Future<bool> excluir(String id) async {
    try {
      isLoading.value = true;
      erro.value = '';

      final resposta = await api.excluirPatrimonio(id);

      if (resposta.statusCode == 200 || resposta.statusCode == 204) {
        patrimonios.removeWhere((patrimonio) => patrimonio.id == id);

        return true;
      }

      erro.value = 'Erro ao excluir patrimônio';
      return false;
    } catch (e) {
      erro.value = 'Erro de conexão com a API';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
