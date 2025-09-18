# 🤖 Testes de API com Robot Framework  
### API: [Restful-Booker](https://restful-booker.herokuapp.com/apidoc/index.html)

Automação de testes de API utilizando **Robot Framework** e **RequestsLibrary**.  
Projeto criado para praticar a escrita de casos de teste para os principais métodos HTTP (GET, POST, PATCH, PUT e DELETE) em uma API pública.

---

## 🚀 Como executar o projeto

### 1. Criar e ativar o ambiente virtual

```bash
python -m venv .venv
.venv\Scripts\activate        # Windows
source .venv/bin/activate     # Linux/Mac
```
### 2. Instalar dependências
```bash
pip install -r requirements.txt
```
### 3. Rodar os testes

* Para executar todos os testes:

```bash
robot -d results tests
```

* Para executar um teste específico:

```bash
robot -d results tests/get_booking.robot
```

* Para testar o fluxo completo de CRUD:

```bash
robot -d results tests/booking_crud_flow.robot
```

Os relatórios serão gerados na pasta results/:

* log.html → Log detalhado da execução

* report.html → Relatório resumido

---
## 🧪 Keywords disponíveis (```resources/keywords.resource```)

Authenticate as Admin — obtém o token de autenticação

Create Booking — cria um novo booking

Get Bookings — obtém os 5 primeiros bookings (detalhados)

Get Booking By Id — busca os dados de um booking pelo ID

Update Booking — atualiza todos os dados de um booking (PUT)

Partial Update Booking — atualiza apenas campos específicos (PATCH)

Delete Booking — exclui um booking existente
