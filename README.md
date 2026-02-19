# Social Network Graph Analytics with Neo4j Aura

Este projeto implementa um modelo de **rede social utilizando banco de dados em grafos (Neo4j)**, com foco em **consultas analíticas, engajamento e recomendações baseadas em relacionamentos**.

A arquitetura foi desenvolvida para simular uma plataforma social moderna capaz de responder a perguntas complexas sobre:

- Engajamento de usuários
- Popularidade de conteúdo
- Conexões sociais
- Comunidades de interesse
- Padrões temporais

---

## Modelagem do Grafo

O modelo foi estruturado com os seguintes nós principais:

- **User**
- **Post**
- **Comment**
- **Tag**
- **Community**

E os seguintes relacionamentos:

- `(:User)-[:FOLLOWS]->(:User)`
- `(:User)-[:POSTED]->(:Post)`
- `(:User)-[:LIKED]->(:Post)`
- `(:User)-[:COMMENTED]->(:Comment)`
- `(:Comment)-[:ON]->(:Post)`
- `(:Post)-[:HAS_TAG]->(:Tag)`
- `(:Post)-[:IN_COMMUNITY]->(:Community)`

---

## Diagrama da Arquitetura

Abaixo está a representação visual do modelo do grafo:

![Social Network Graph Model](social_network.png)

---

## Estrutura Técnica

O projeto contém:

- Constraints para integridade de dados
- Índices para otimização de consultas
- 15 usuários
- 30 posts
- 20 comentários
- 8 tags
- 3 comunidades
- Conexões FOLLOW
- Likes
- Timestamps coerentes para análises temporais

Todo o banco pode ser criado executando o arquivo: social_network_project.cypher


---

## Como Executar no Neo4j Aura

1. Criar uma instância gratuita no Neo4j Aura
2. Conectar ao database
3. Copiar e executar o conteúdo do arquivo `social_network_project.cypher`
4. Rodar as queries analíticas abaixo

---

## Exemplos de Queries Analíticas

###  Top Influenciadores

MATCH (u:User)<-[:FOLLOWS]-(:User)
RETURN u.username, count(*) AS followers
ORDER BY followers DESC
LIMIT 5;

### Posts Mais Engajados

MATCH (p:Post)
OPTIONAL MATCH (:User)-[:LIKED]->(p)
WITH p, count(*) AS likes
OPTIONAL MATCH (:Comment)-[:ON]->(p)
RETURN p.postId, likes, count(*) AS comments
ORDER BY (likes + comments) DESC
LIMIT 10;

### Comunidades Mais Ativas

MATCH (g:Community)<-[:IN_COMMUNITY]-(p:Post)
RETURN g.name AS community, count(p) AS posts
ORDER BY posts DESC
LIMIT 10;

### Sugestão de Pessoas Para Seguir

## Arquitetura Lógica
User
 ├ FOLLOWS → User
 ├ POSTED → Post
 ├ LIKED → Post
 └ COMMENTED → Comment

Post
 ├ HAS_TAG → Tag
 └ IN_COMMUNITY → Community

Comment
 └ ON → Post


