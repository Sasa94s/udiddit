-- Users
INSERT INTO users (username)
SELECT DISTINCT bp.username
FROM bad_posts AS bp
WHERE COALESCE(TRIM(bp.username), '') <> ''
UNION
SELECT DISTINCT bc.username
FROM bad_comments AS bc
WHERE COALESCE(TRIM(bc.username), '') <> ''
UNION
SELECT username
FROM (SELECT DISTINCT UNNEST(string_to_array(upvotes, ',') || string_to_array(downvotes, ',')) AS username
      FROM bad_posts) AS v
WHERE COALESCE(TRIM(v.username), '') <> '';

-- Topics
INSERT INTO topics (name)
SELECT DISTINCT topic
FROM bad_posts
WHERE COALESCE(TRIM(topic), '') <> '';

-- Posts
INSERT INTO posts (id, user_id, topic_id, title, url, text_content)
SELECT bp.id, u.id, t.id, bp.title, bp.url, bp.text_content
FROM bad_posts bp
         LEFT JOIN users u ON bp.username = u.username
         LEFT JOIN topics t ON bp.topic = t.name;

-- Comments
INSERT INTO comments (id, user_id, post_id, text_content)
SELECT bc.id, u.id, p.id, bc.text_content
FROM bad_comments bc
         LEFT JOIN users u ON bc.username = u.username
         LEFT JOIN posts p ON bc.post_id = p.id;

-- Votes
INSERT INTO votes (user_id, post_id, vote_value)
SELECT v.user_id, v.post_id, SUM(v.vote_value) AS vote_value
FROM (SELECT DISTINCT u.id AS user_id, downvotes.id AS post_id, -1 AS vote_value
      FROM (SELECT id, regexp_split_to_table(downvotes, ',') AS username
            FROM bad_posts) AS downvotes
               LEFT JOIN users u ON downvotes.username = u.username
      WHERE COALESCE(TRIM(u.username), '') <> ''
      UNION ALL
      SELECT DISTINCT u.id AS user_id, upvotes.id AS post_id, 1 AS vote_value
      FROM (SELECT id, regexp_split_to_table(upvotes, ',') AS username
            FROM bad_posts) AS upvotes
               LEFT JOIN users u ON upvotes.username = u.username
      WHERE COALESCE(TRIM(u.username), '') <> '') AS v
GROUP BY user_id, post_id
HAVING SUM(vote_value) <> 0;

-- DROP DEPRECATED TABLES
DROP TABLE bad_comments;
DROP TABLE bad_posts;