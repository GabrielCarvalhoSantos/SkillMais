# SkillMais - Marketplace de Serviços Locais

## Informações do Projeto

**Discentes:**
- Gabriel Carvalho Santos
- Odisley Nascimento Santos

---

## 1. Nome do Projeto
**SkillMais**

## 2. Problema/Dor que o Projeto Resolve
O projeto resolve a dificuldade que muitas pessoas têm em encontrar profissionais confiáveis e disponíveis para realizar serviços domésticos ou pequenos trabalhos em sua localidade, conectando contratantes a prestadores de serviço de forma prática, rápida e segura por meio de um aplicativo móvel.

## 3. Objetivo e Aplicação do Projeto
O objetivo do projeto é desenvolver um aplicativo móvel multiplataforma que funcione como um marketplace de serviços locais. A plataforma permite que contratantes encontrem, agendem e avaliem prestadores de serviços para tarefas do dia a dia. Pode ser utilizado em qualquer região onde haja necessidade de serviços domésticos como encanador, eletricista, diarista, entre outros.

---

# Documento de Requisitos de Software
**Marketplace de Serviços Locais - MVP**

- **Versão:** 1.1
- **Data:** 17/04/2025
- **Status:** Em análise

## 1. Introdução

### 1.1 Finalidade
Este documento especifica os requisitos para o Produto Mínimo Viável (MVP) do Marketplace de Serviços Locais, uma plataforma que conecta pessoas que necessitam de serviços domésticos ou pequenos trabalhos com prestadores locais disponíveis. O documento servirá como base para o planejamento, desenvolvimento e validação do projeto.

### 1.2 Escopo do Produto
O MVP focará nas funcionalidades essenciais para viabilizar a conexão entre contratantes e prestadores de serviços, contemplando cadastro, busca, comunicação básica, agendamento e avaliações.

### 1.3 Público-Alvo
Este documento destina-se à equipe de desenvolvimento, partes interessadas (stakeholders) envolvidos no projeto.

### 1.4 Definições, Acrônimos e Abreviações

| Termo | Definição |
|-------|-----------|
| MVP | Produto Mínimo Viável |
| Contratante | Usuário que busca contratar um serviço |
| Prestador | Profissional que oferece serviços através da plataforma |
| RF | Requisito Funcional |
| RNF | Requisito Não-Funcional |

## 2. Descrição Geral

### 2.1 Perspectiva do Produto
O Marketplace de Serviços Locais é um produto independente que será desenvolvido como aplicação móvel multiplataforma utilizando Flutter Flow para frontend e Supabase para backend.

### 2.2 Características dos Usuários

| Tipo de Usuário | Características | Conhecimento Técnico |
|-----------------|-----------------|---------------------|
| Contratante | Pessoas com necessidade de serviços domésticos ou pequenos trabalhos | Conhecimento básico de aplicativos móveis |
| Prestador | Profissionais autônomos que oferecem serviços especializados | Conhecimento básico de aplicativos móveis |

### 2.3 Restrições
- Desenvolvido por dois desenvolvedores júnior's
- Aplicativo móvel desenvolvido com Flutter Flow
- Backend utilizando Supabase
- Sem integrações complexas com sistemas de pagamento
- Funcionalidades limitadas ao escopo do MVP

### 2.4 Premissas e Dependências
- Disponibilidade contínua dos serviços Supabase
- Acesso a serviços básicos de geolocalização
- Dispositivos dos usuários com sistemas operacionais Android (7.0+) ou iOS (11.0+)

## 3. Requisitos Específicos

### 3.1 Requisitos Funcionais

#### 3.1.1 Gerenciamento de Usuários

| ID | Descrição | Prioridade |
|----|-----------|------------|
| RF001 | O sistema deve permitir cadastro via usuário/senha | Alta |
| RF002 | O sistema deve permitir autenticação básica de usuários | Alta |
| RF003 | O sistema deve permitir cadastro de perfil de contratante com dados básicos (nome, e-mail, telefone) | Alta |
| RF004 | O sistema deve permitir cadastro de um endereço principal para contratantes | Alta |
| RF005 | O sistema deve permitir cadastro de perfil de prestador com dados básicos | Alta |
| RF006 | O sistema deve permitir cadastro de preço por tipo de serviço | Alta |

#### 3.1.2 Busca de Serviços

| ID | Descrição | Prioridade |
|----|-----------|------------|
| RF007 | O sistema deve permitir busca por categoria de serviço | Alta |
| RF008 | O sistema deve exibir informações resumidas do prestador nos resultados de busca | Média |

#### 3.1.3 Comunicação

| ID | Descrição | Prioridade |
|----|-----------|------------|
| RF009 | O sistema deve notificar sobre novas mensagens via e-mail | Média |

#### 3.1.4 Agendamento

| ID | Descrição | Prioridade |
|----|-----------|------------|
| RF010 | O sistema deve permitir seleção de data e horário para serviços | Alta |
| RF011 | O sistema deve permitir visualização de serviços agendados | Alta |
| RF013 | O sistema deve permitir cancelamento de serviços agendados | Média |

#### 3.1.5 Avaliações

| ID | Descrição | Prioridade |
|----|-----------|------------|
| RF014 | O sistema deve permitir avaliação com nota (1-5 estrelas) após conclusão do serviço | Alta |
| RF015 | O sistema deve exibir média de avaliações no perfil do prestador | Alta |

### 3.2 Requisitos Não-Funcionais

#### 3.2.1 Usabilidade

| ID | Descrição | Critério de Aceitação |
|----|-----------|----------------------|
| RNF001 | A interface deve ser intuitiva e responsiva para smartphones | Teste de usabilidade com 3 usuários completando tarefas básicas sem ajuda |
| RNF002 | O sistema deve adaptar-se a diferentes tamanhos de tela | Funcionamento adequado em dispositivos com telas de 4" a 6.5" |

#### 3.2.2 Desempenho

| ID | Descrição | Critério de Aceitação |
|----|-----------|----------------------|
| RNF003 | O sistema deve carregar telas principais em menos de 5 segundos | Testes de tempo de carregamento em conexão 4G |
| RNF004 | O sistema deve suportar até 100 usuários simultâneos | Testes de carga simulando acessos simultâneos |

#### 3.2.3 Segurança

| ID | Descrição | Critério de Aceitação |
|----|-----------|----------------------|
| RNF005 | O sistema deve implementar HTTPS | Verificação de certificado SSL válido |
| RNF006 | O sistema deve implementar proteção básica contra injeção SQL | Testes de segurança com casos comuns de injeção SQL |

## 4. Arquitetura do Sistema

### 4.1 Componentes Principais

```
[Aplicativo (Flutter Flow)] <---> [Backend (Supabase)]
         |                               |
         v                               v
   [UI/UX Básica]                [Autenticação Simples]
                                 [Banco de Dados PostgreSQL]
                                 [Armazenamento de Arquivos]
```

### 4.2 Interfaces Externas
- API de Geolocalização (básica)
- Serviço de E-mail para notificações

## 5. Modelo de Dados Simplificado

### 5.1 Entidades Principais

| Entidade | Atributos Principais |
|----------|---------------------|
| Usuário | id, nome, email, telefone, tipo (contratante/prestador), data_cadastro |
| Endereço | id, usuario_id, cep, logradouro, número, complemento, bairro, cidade, estado, latitude, longitude |
| Categoria | id, nome, descricao, ícone |
| Serviço | id, prestador_id, categoria_id, título, descricao, preco_base |
| Portfolio | id, servico_id, url_imagem, descricao |
| Agendamento | id, contratante_id, servico_id, data_hora, status, observacoes |
| Mensagem | id, remetente_id, destinatario_id, conteudo, data_hora, lida |
| Avaliacao | id, contratante_id, prestador_id, servico_id, nota, comentario, data |

## 6. Interfaces de Usuário

### 6.1 Principais Telas

| Tela | Descrição |
|------|-----------|
| Cadastro/Login | Tela para cadastro e autenticação de usuários |
| Perfil | Tela para visualização e edição de perfil |
| Busca | Tela para busca de serviços por categoria e localização |
| Resultados | Tela com listagem de prestadores encontrados |
| Detalhes do Prestador | Tela com informações detalhadas do prestador e seu portfólio |
| Agendamento | Tela para seleção de data e horário |
| Meus Agendamentos | Tela para visualização de serviços agendados |
| Avaliação | Tela para avaliação pós-serviço |

## 7. Critérios de Aceitação
- Todos os requisitos funcionais de alta prioridade implementados
- Interface responsiva em diferentes dispositivos
- Tempo de resposta dentro dos limites estabelecidos
- Fluxo completo de cadastro, busca, agendamento e avaliação funcionando corretamente

## 8. Considerações de Implementação

### 8.1 Simplificações Técnicas
- Utilizar componentes pré-construídos do Flutter Flow
- Limitar chamadas de API complexas
- Implementar apenas notificações por e-mail (sem push)
- Utilizar recursos nativos do Supabase para autenticação e armazenamento

### 8.2 Tecnologias Específicas
- **Frontend:** Flutter Flow
- **Backend:** Supabase (PostgreSQL, Authentication, Storage)
- **Controle de Versão:** Git

## 9. Exclusões do MVP (Para Versões Futuras)

As seguintes funcionalidades estão fora do escopo do MVP:

- Sistema de pagamento in-app
- Verificação avançada de identidade
- Filtros avançados de busca
- Sistema de orçamentos
- Área de atendimento configurável
- Calendário de disponibilidade detalhado
- Múltiplos endereços para contratantes
- Upload de documentos
- Integração com redes sociais para cadastro
- Dashboard para análise de dados
- Recuperação de senha para usuários
- Categorização múltipla de serviços para prestadores
- Portfólio visual com múltiplas imagens para prestadores
- Geolocalização para exibição de prestadores próximos
- Ordenação de resultados por proximidade geográfica
- Sistema de comunicação por mensagens entre contratantes e prestadores
- Sistema de notificações para confirmação de agendamentos
- Funcionalidade de comentários em avaliações de serviços
- Rotinas de backup e recuperação do banco de dados