import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/patrimonios.dart';
import '../models/patrimonios.dart';
import 'widgets/patrimonio_modal.dart';

class PatrimoniosView extends StatelessWidget {
  const PatrimoniosView({super.key});

  @override
  Widget build(BuildContext context) {
    // Registra/obtém o Controller
    final controller = Get.put(PatrimoniosController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Patrimônios'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar Lista',
            onPressed: () => controller.listarPatrimonios(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de Pesquisa com botões necessários
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: 'Pesquisar por descrição ou local...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => controller.limparPesquisa(),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (termo) => controller.pesquisar(termo),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () =>
                      controller.pesquisar(controller.searchController.text),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),

          // Lista Reativa com Obx
          Expanded(
            child: Obx(() {
              // 1. Estado de Carregamento
              if (controller.isLoading.value) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Carregando patrimônios...'),
                    ],
                  ),
                );
              }

              // 2. Estado de Erro
              if (controller.erro.value.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 54,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          controller.erro.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => controller.listarPatrimonios(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // 3. Estado Vazio
              if (controller.patrimonios.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Nenhum patrimônio encontrado.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () =>
                              PatrimonioModal.abrirFormulario(),
                          icon: const Icon(Icons.add),
                          label: const Text('Cadastrar Primeiro Patrimônio'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // 4. Lista de Patrimônios
              return RefreshIndicator(
                onRefresh: () => controller.listarPatrimonios(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: controller.patrimonios.length,
                  itemBuilder: (context, index) {
                    final item = controller.patrimonios[index];
                    return _PatrimonioCard(item: item);
                  },
                ),
              );
            }),
          ),
        ],
      ),
      // Botão Flutuante para Adicionar Novo Patrimônio
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => PatrimonioModal.abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Novo Patrimônio'),
      ),
    );
  }
}

class _PatrimonioCard extends StatelessWidget {
  final Patrimonios item;

  const _PatrimonioCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    item.numeroInventario.isNotEmpty
                        ? item.numeroInventario.substring(0, 1)
                        : (item.id != null ? item.id.toString().substring(0, 1) : '#'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.descricao,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Nº Inventário: ${item.numeroInventario}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Local: ${item.local}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                  ),
                ),
                Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Resp: ${item.responsavel}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            // Botões de Ação do Card
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => PatrimonioModal.abrirDetalhes(item),
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('Visualizar'),
                ),
                TextButton.icon(
                  onPressed: () =>
                      PatrimonioModal.abrirFormulario(patrimonio: item),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Editar'),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'Excluir',
                  onPressed: () => PatrimonioModal.confirmarExclusao(item),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
