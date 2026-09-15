import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/patrimonios.dart';
import '../../models/patrimonios.dart';

class PatrimonioModal {
  /// Abre o modal de formulário para cadastrar ou editar um patrimônio.
  static void abrirFormulario({Patrimonios? patrimonio}) {
    final controller = Get.find<PatrimoniosController>();
    final isEdicao = patrimonio != null;

    final inventarioController =
        TextEditingController(text: patrimonio?.numeroInventario ?? '');
    final descricaoController =
        TextEditingController(text: patrimonio?.descricao ?? '');
    final localController =
        TextEditingController(text: patrimonio?.local ?? '');
    final responsavelController =
        TextEditingController(text: patrimonio?.responsavel ?? '');

    final formKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        isEdicao ? Icons.edit_note : Icons.add_circle_outline,
                        color: Theme.of(Get.context!).colorScheme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isEdicao ? 'Editar Patrimônio' : 'Novo Patrimônio',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Get.back(),
                        tooltip: 'Fechar',
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  // Campo Número do Inventário
                  TextFormField(
                    controller: inventarioController,
                    decoration: InputDecoration(
                      labelText: 'Nº do Inventário *',
                      hintText: 'Ex: SENAI-INV-2026-001',
                      prefixIcon: const Icon(Icons.qr_code),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'Informe o número do inventário';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  // Campo Descrição
                  TextFormField(
                    controller: descricaoController,
                    decoration: InputDecoration(
                      labelText: 'Descrição *',
                      hintText: 'Ex: Impressora 3D Bambu Lab',
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'Informe a descrição do equipamento';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  // Campo Local
                  TextFormField(
                    controller: localController,
                    decoration: InputDecoration(
                      labelText: 'Localização / Sala *',
                      hintText: 'Ex: Lab. de Manufatura - Bloco A',
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'Informe o local onde o equipamento se encontra';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  // Campo Responsável
                  TextFormField(
                    controller: responsavelController,
                    decoration: InputDecoration(
                      labelText: 'Responsável *',
                      hintText: 'Ex: Prof. Ricardo Silva',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'Informe o responsável';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  // Botões: Cancelar e Salvar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text('Cancelar'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final novoItem = Patrimonios(
                              id: patrimonio?.id,
                              numeroInventario:
                                  inventarioController.text.trim(),
                              descricao: descricaoController.text.trim(),
                              local: localController.text.trim(),
                              responsavel: responsavelController.text.trim(),
                            );

                            bool sucesso;
                            if (isEdicao) {
                              sucesso = await controller.atualizar(novoItem);
                            } else {
                              sucesso = await controller.cadastrar(novoItem);
                            }

                            if (sucesso) {
                              Get.back(); // Fecha o modal
                            }
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: Text(isEdicao ? 'Atualizar' : 'Salvar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(Get.context!).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Abre o modal para visualizar os detalhes completos do patrimônio.
  static void abrirDetalhes(Patrimonios item) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue, size: 28),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Detalhes do Patrimônio',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(height: 24),
              if (item.id != null) ...[
                _itemDetalhe('ID:', item.id.toString(), Icons.tag),
                const SizedBox(height: 10),
              ],
              _itemDetalhe('Nº Inventário:', item.numeroInventario, Icons.qr_code),
              const SizedBox(height: 10),
              _itemDetalhe('Descrição:', item.descricao, Icons.description),
              const SizedBox(height: 10),
              _itemDetalhe('Local:', item.local, Icons.location_on),
              const SizedBox(height: 10),
              _itemDetalhe('Responsável:', item.responsavel, Icons.person),
              if (item.dataRegistro != null) ...[
                const SizedBox(height: 10),
                _itemDetalhe('Registrado em:', item.dataRegistro!, Icons.calendar_today),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                    label: const Text('Fechar'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      abrirFormulario(patrimonio: item);
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _itemDetalhe(String rotulo, String valor, IconData icone) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icone, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          rotulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            valor.isNotEmpty ? valor : '-',
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  /// Modal de confirmação para excluir o patrimônio.
  static void confirmarExclusao(Patrimonios item) {
    final controller = Get.find<PatrimoniosController>();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 10),
            Text('Excluir Patrimônio'),
          ],
        ),
        content: Text(
          'Tem certeza de que deseja remover o patrimônio "${item.descricao}" (${item.numeroInventario})?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Get.back();
              final idAlvo = item.id ?? item.numeroInventario;
              await controller.excluir(idAlvo);
            },
            icon: const Icon(Icons.delete_forever),
            label: const Text('Excluir'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
