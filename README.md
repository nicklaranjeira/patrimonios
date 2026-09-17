# 🏛️ Aplicativo de Gerenciamento de Patrimônio - SENAI

Aplicativo mobile e web desenvolvido em **Flutter** utilizando o padrão arquitetural em camadas com o ecossistema **GetX** (`Model`, `Service`, `Controller`, `Views`) integrado a uma **API RESTful** construída em **FastAPI (Python)**.

---

## 📋 Sumário
- [Arquitetura do Projeto](#-arquitetura-do-projeto)
- [Estrutura de Pastas](#-estrutura-de-pastas)
- [Rotas da API RESTful](#-rotas-da-api-restful)
  - [1. Listagem Geral](#1-listar-todos-os-patrimônios)
  - [2. Pesquisa por Termo](#2-pesquisar-patrimônios)
  - [3. Detalhes por ID](#3-obter-detalhes-de-um-patrimônio)
  - [4. Cadastro de Novo Patrimônio](#4-cadastrar-patrimônio)
  - [5. Atualização de Patrimônio](#5-atualizar-patrimônio)
  - [6. Remoção de Patrimônio](#6-excluir-patrimônio)
- [Configuração de Rede e Portas](#-configuração-de-rede-e-portas)
- [Como Executar](#-como-executar)
  - [1. Backend (FastAPI)](#1-executar-a-api-python)
  - [2. Frontend (Flutter)](#2-executar-o-aplicativo-flutter)
- [Funcionalidades da Interface](#-funcionalidades-da-interface)

---

## 🏗️ Arquitetura do Projeto

O projeto adota o padrão em camadas desacopladas promovido pelo GetX:

```
[ View / UI ]  <--->  [ Controller ]  <--->  [ Service (GetConnect) ]  <--->  [ API REST ]
      ^                      ^
      |                      |
      +-------[ Model ]------+
```

1. **Model (`lib/models/patrimonios.dart`)**:
   Representa a entidade de negócio. Responsável pela serialização (`toJson`) e desserialização (`fromJson`), com suporte aos formatos `n_do_inventario` e `numero_inventario`.
2. **Service (`lib/service/patrimonios.dart`)**:
   Gerencia as chamadas HTTP utilizando `GetConnect`. Inclui resolução dinâmica de hosts (`10.0.2.2` no emulador Android e `localhost` na Web/Windows) e fallback inteligente de rotas.
3. **Controller (`lib/controllers/patrimonios.dart`)**:
   Controla a lógica de negócio e os estados reativos da tela (`patrimonios`, `isLoading`, `erro`, `searchController`).
4. **Views (`lib/views/`)**:
   Interface visual reativa com tema vermelho, barra de busca, cards informativos e modais de interação.

---

## 📁 Estrutura de Pastas

```
lib/
├── controllers/
│   └── patrimonios.dart           # Lógica reativa, estado e CRUD GetX
├── models/
│   └── patrimonios.dart           # Modelo de dados e conversão JSON
├── service/
│   └── patrimonios.dart           # Camada de comunicação HTTP (GetConnect)
├── views/
│   ├── patrimonios_view.dart      # Tela principal com listagem e busca
│   └── widgets/
│       └── patrimonio_modal.dart  # Modais de formulário, detalhes e exclusão
└── main.dart                      # Configuração do GetMaterialApp e tema
```

---

## 🌐 Rotas da API RESTful

O backend opera por padrão na **porta 8000**. Todas as rotas suportam tanto o prefixo padrão `/api/v1/patrimonios` quanto o formato direto `/patrimonios`.

### 1. Listar todos os patrimônios
Recupera a lista completa de todos os patrimônios registrados no banco de dados.

* **Método:** `GET`
* **Rota:** `/api/v1/patrimonios` (ou `/patrimonios`)
* **Status de Sucesso:** `200 OK`
* **Exemplo de Resposta:**
  ```json
  {
    "success": true,
    "message": "Patrimônios recuperados com sucesso",
    "data": {
      "total": 3,
      "patrimonios": [
        {
          "id": 1,
          "n_do_inventario": "SENAI-INV-2026-001",
          "descricao": "Impressora 3D Industrial Bambu Lab X1-Carbon",
          "local": "Lab. de Prototipagem Avançada - Bloco A",
          "responsavel": "Prof. Ricardo Silva"
        }
      ]
    }
  }
  ```

---

### 2. Pesquisar patrimônios
Filtra os patrimônios dinamicamente por qualquer termo correspondente na descrição, número de inventário, localização ou responsável.

* **Método:** `GET`
* **Rota:** `/api/v1/patrimonios?q={termo}` (ou `/patrimonios?q={termo}`)
* **Parâmetro de Consulta (Query):**
  * `q` (string, obrigatório): Termo de busca (ex: `?q=Impressora` ou `?q=Bloco A`).
* **Status de Sucesso:** `200 OK`
* **Exemplo de Resposta:** Lista contendo apenas os itens que atendem ao critério de busca.

---

### 3. Obter detalhes de um patrimônio
Busca as informações completas de um único patrimônio através do seu identificador (`id` numérico ou código de inventário).

* **Método:** `GET`
* **Rota:** `/api/v1/patrimonios/{id}` (ou `/patrimonios/{id}`)
* **Parâmetro de Rota:**
  * `id` (int/string): Identificador único do patrimônio (ex: `/api/v1/patrimonios/1`).
* **Status de Sucesso:** `200 OK`
* **Status de Erro:** `404 Not Found` (caso o identificador não exista).
* **Exemplo de Resposta:**
  ```json
  {
    "success": true,
    "data": {
      "id": 1,
      "n_do_inventario": "SENAI-INV-2026-001",
      "descricao": "Impressora 3D Industrial Bambu Lab X1-Carbon",
      "local": "Lab. de Prototipagem Avançada - Bloco A",
      "responsavel": "Prof. Ricardo Silva"
    }
  }
  ```

---

### 4. Cadastrar patrimônio
Cria e persiste um novo patrimônio no banco de dados.

* **Método:** `POST`
* **Rota:** `/api/v1/patrimonios` (ou `/patrimonios`)
* **Headers:** `Content-Type: application/json`
* **Corpo da Requisição (JSON Payload):**
  ```json
  {
    "n_do_inventario": "SENAI-INV-2026-004",
    "descricao": "Osciloscópio Digital Keysight 4 Canais 100MHz",
    "local": "Lab. de Eletrônica - Bloco C",
    "responsavel": "Prof. Carlos Eduardo"
  }
  ```
* **Status de Sucesso:** `201 Created`
* **Status de Erro:** `422 Unprocessable Entity` (caso algum campo obrigatório falte).
* **Exemplo de Resposta:**
  ```json
  {
    "success": true,
    "message": "Patrimônio cadastrado com sucesso",
    "data": {
      "id": 4,
      "n_do_inventario": "SENAI-INV-2026-004",
      "descricao": "Osciloscópio Digital Keysight 4 Canais 100MHz",
      "local": "Lab. de Eletrônica - Bloco C",
      "responsavel": "Prof. Carlos Eduardo"
    }
  }
  ```

---

### 5. Atualizar patrimônio
Atualiza os dados cadastrais de um patrimônio previamente existente.

* **Método:** `PUT`
* **Rota:** `/api/v1/patrimonios/{id}` (ou `/patrimonios/{id}`)
* **Headers:** `Content-Type: application/json`
* **Parâmetro de Rota:** `id` do item a ser modificado.
* **Corpo da Requisição (JSON Payload):**
  ```json
  {
    "n_do_inventario": "SENAI-INV-2026-001",
    "descricao": "Impressora 3D Bambu Lab X1-Carbon (Manutenção Concluída)",
    "local": "Lab. Maker - Sala 104",
    "responsavel": "Prof. Ricardo Silva"
  }
  ```
* **Status de Sucesso:** `200 OK`
* **Status de Erro:** `404 Not Found` (caso o item não seja localizado).

---

### 6. Excluir patrimônio
Remove permanentemente o patrimônio informado do sistema.

* **Método:** `DELETE`
* **Rota:** `/api/v1/patrimonios/{id}` (ou `/patrimonios/{id}`)
* **Parâmetro de Rota:** `id` do item a ser removido.
* **Status de Sucesso:** `200 OK` (ou `204 No Content`).
* **Status de Erro:** `404 Not Found`.
* **Exemplo de Resposta:**
  ```json
  {
    "success": true,
    "message": "Patrimônio removido com sucesso"
  }
  ```

---

## ⚙️ Configuração de Rede e Portas

A Service do Flutter possui resolução automática de endereço:

| Ambiente | Host Configurado | Porta | URL Base |
| :--- | :--- | :--- | :--- |
| **Emulador Android Nativo** | `10.0.2.2` (alias para localhost da máquina host) | `8000` | `http://10.0.2.2:8000` |
| **Navegador Web (Chrome/Edge)** | `localhost` / `127.0.0.1` | `8000` | `http://localhost:8000` |
| **Windows Desktop** | `localhost` / `127.0.0.1` | `8000` | `http://localhost:8000` |

> ℹ️ **Observação de CORS:** O backend possui middleware de CORS com `allow_origin_regex=".*"` e `allow_credentials=True`, garantindo que o Flutter Web possa enviar requisições sem bloqueios de segurança do navegador.

---

## 🚀 Como Executar

### 1. Executar a API Python
Abra um terminal dedicado para o backend:

```powershell
# Acesse o diretório da API
cd "C:\Users\Aluno\DS- QUARTO TERMO\MOBILE\api -python"

# Ative o ambiente virtual
.\venv\Scripts\Activate.ps1

# Inicie o servidor FastAPI na porta 8000
fastapi run
# ou: uvicorn app:app --host 0.0.0.0 --port 8000 --reload
```

A documentação interativa Swagger UI estará acessível no navegador em:
👉 **`http://localhost:8000/docs`**

---

### 2. Executar o Aplicativo Flutter
Em outro terminal:

```powershell
# Acesse a pasta do projeto Flutter
cd "C:\Users\Aluno\DS- QUARTO TERMO\MOBILE\Aplicativo de gerenciamento de patrimônio\patrimonios"

# Baixe as dependências
flutter pub get

# Inicie o aplicativo (selecione o Emulador Android ou o Chrome)
flutter run
```

---

## 🎨 Funcionalidades da Interface

* **Tema Vermelho SENAI:** Identidade visual configurada no `ThemeData` com a cor característica `#E30613`.
* **Atualização em tempo real:** Lista observável com `Obx` que atualiza dinamicamente conforme os registros são adicionados, modificados ou excluídos.
* **Barra de Pesquisa:** Campo com busca em tempo real e botão para limpar filtros.
* **Modais Interativos:**
  * **Modal de Cadastro/Edição:** Formulário com validação de campos obrigatórios.
  * **Modal de Detalhes:** Apresenta todas as informações do patrimônio com botões rápidos de ação.
  * **Modal de Confirmação de Exclusão:** Diálogo de segurança antes de efetivar a remoção.
* **Notificações:** Alertas visuais através de `Get.snackbar` para feedbacks de sucesso e erro.
