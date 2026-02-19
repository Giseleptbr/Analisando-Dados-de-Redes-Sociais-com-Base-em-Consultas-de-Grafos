//////////////////////////////////////////////////////
// CONSTRAINTS
//////////////////////////////////////////////////////

CREATE CONSTRAINT user_id_unique IF NOT EXISTS
FOR (u:User) REQUIRE u.userId IS UNIQUE;

CREATE CONSTRAINT post_id_unique IF NOT EXISTS
FOR (p:Post) REQUIRE p.postId IS UNIQUE;

CREATE CONSTRAINT comment_id_unique IF NOT EXISTS
FOR (c:Comment) REQUIRE c.commentId IS UNIQUE;

CREATE CONSTRAINT tag_name_unique IF NOT EXISTS
FOR (t:Tag) REQUIRE t.name IS UNIQUE;

CREATE CONSTRAINT community_id_unique IF NOT EXISTS
FOR (g:Community) REQUIRE g.communityId IS UNIQUE;

//////////////////////////////////////////////////////
// INDEXES
//////////////////////////////////////////////////////

CREATE INDEX user_username_idx IF NOT EXISTS
FOR (u:User) ON (u.username);

CREATE INDEX post_createdAt_idx IF NOT EXISTS
FOR (p:Post) ON (p.createdAt);

//////////////////////////////////////////////////////
// USERS
//////////////////////////////////////////////////////

UNWIND range(1,15) AS id
CREATE (:User {
  userId: id,
  name: "User " + id,
  username: "user" + id,
  createdAt: datetime("2024-01-01T00:00:00") + duration({days: id})
});

//////////////////////////////////////////////////////
// COMMUNITIES
//////////////////////////////////////////////////////

CREATE (:Community {communityId: 1, name: "Data Science"});
CREATE (:Community {communityId: 2, name: "AI & ML"});
CREATE (:Community {communityId: 3, name: "Graph Tech"});

//////////////////////////////////////////////////////
// TAGS
//////////////////////////////////////////////////////

CREATE (:Tag {name: "neo4j"});
CREATE (:Tag {name: "datascience"});
CREATE (:Tag {name: "machinelearning"});
CREATE (:Tag {name: "ai"});
CREATE (:Tag {name: "graph"});
CREATE (:Tag {name: "cypher"});
CREATE (:Tag {name: "analytics"});
CREATE (:Tag {name: "backend"});

//////////////////////////////////////////////////////
// POSTS
//////////////////////////////////////////////////////

UNWIND range(1,30) AS id
MATCH (u:User {userId: ((id % 15) + 1)})
CREATE (p:Post {
  postId: id,
  text: "Post about topic " + id,
  type: CASE WHEN id % 3 = 0 THEN "video"
             WHEN id % 2 = 0 THEN "image"
             ELSE "text" END,
  createdAt: datetime("2024-02-01T00:00:00") + duration({days: id})
})
CREATE (u)-[:POSTED]->(p);

//////////////////////////////////////////////////////
// TAG RELATIONS
//////////////////////////////////////////////////////

MATCH (p:Post), (t:Tag)
WHERE p.postId % 2 = 0 AND t.name IN ["neo4j","graph"]
MERGE (p)-[:HAS_TAG]->(t);

MATCH (p:Post), (t:Tag)
WHERE p.postId % 3 = 0 AND t.name IN ["ai","machinelearning"]
MERGE (p)-[:HAS_TAG]->(t);

//////////////////////////////////////////////////////
// COMMUNITY RELATIONS
//////////////////////////////////////////////////////

MATCH (p:Post), (g:Community)
WHERE p.postId % 3 = 0 AND g.communityId = 2
MERGE (p)-[:IN_COMMUNITY]->(g);

MATCH (p:Post), (g:Community)
WHERE p.postId % 2 = 0 AND g.communityId = 1
MERGE (p)-[:IN_COMMUNITY]->(g);

MATCH (p:Post), (g:Community)
WHERE p.postId % 5 = 0 AND g.communityId = 3
MERGE (p)-[:IN_COMMUNITY]->(g);

//////////////////////////////////////////////////////
// FOLLOWS
//////////////////////////////////////////////////////

UNWIND range(1,15) AS id
MATCH (u1:User {userId: id}),
      (u2:User {userId: ((id + 3) % 15) + 1})
MERGE (u1)-[:FOLLOWS {
  createdAt: datetime("2024-03-01T00:00:00") + duration({days: id})
}]->(u2);

//////////////////////////////////////////////////////
// LIKES
//////////////////////////////////////////////////////

UNWIND range(1,30) AS pid
MATCH (u:User {userId: ((pid + 2) % 15) + 1}),
      (p:Post {postId: pid})
MERGE (u)-[:LIKED {
  createdAt: datetime("2024-03-10T00:00:00") + duration({days: pid})
}]->(p);

//////////////////////////////////////////////////////
// COMMENTS
//////////////////////////////////////////////////////

UNWIND range(1,20) AS cid
MATCH (u:User {userId: ((cid + 4) % 15) + 1}),
      (p:Post {postId: ((cid + 5) % 30) + 1})
CREATE (c:Comment {
  commentId: cid,
  text: "Interesting point " + cid,
  createdAt: datetime("2024-03-15T00:00:00") + duration({days: cid})
})
CREATE (u)-[:COMMENTED]->(c)
CREATE (c)-[:ON]->(p);
