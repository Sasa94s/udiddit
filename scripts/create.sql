-- Users Table
CREATE TABLE users
(
    id         SERIAL PRIMARY KEY,
    username   VARCHAR(25) UNIQUE NOT NULL,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "nonempty_username" CHECK ( COALESCE(TRIM(username), '') <> '' )
);

-- Topics Table
CREATE TABLE topics
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(30) UNIQUE NOT NULL,
    description VARCHAR(500) DEFAULT NULL,
    created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- Posts Table
CREATE TABLE posts
(
    id           SERIAL PRIMARY KEY,
    user_id      INT          REFERENCES users (id) ON DELETE SET NULL,
    topic_id     INT REFERENCES topics (id) ON DELETE CASCADE,
    title        VARCHAR(150) NOT NULL,
    url          VARCHAR(4000) DEFAULT NULL,
    text_content TEXT          DEFAULT NULL,
    created_at   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "text_or_url_only" CHECK ( (url IS NOT NULL OR text_content IS NOT NULL) AND
                                          (url IS NULL OR text_content IS NULL))
);

-- Comments Table
CREATE TABLE comments
(
    id                SERIAL PRIMARY KEY,
    user_id           INT  REFERENCES users (id) ON DELETE SET NULL,
    post_id           INT REFERENCES posts (id) ON DELETE CASCADE,
    parent_comment_id INT REFERENCES comments (id) ON DELETE CASCADE,
    text_content      TEXT NOT NULL,
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Votes Table
CREATE TABLE votes
(
    user_id    INT REFERENCES users (id) ON DELETE SET NULL,
    post_id    INT REFERENCES posts (id) ON DELETE CASCADE,
    vote_value SMALLINT CHECK (vote_value IN (-1, 1)),
    PRIMARY KEY (user_id, post_id)
);

-- Indexes for query performance
CREATE INDEX idx_users_last_login ON users (last_login);
CREATE INDEX idx_users_username ON users (username);
CREATE UNIQUE INDEX unique_idx_topics_name ON topics (TRIM(name));
CREATE UNIQUE INDEX idx_topics_name ON topics (LOWER(name) VARCHAR_PATTERN_OPS);
CREATE INDEX idx_posts_user ON posts (user_id);
CREATE INDEX idx_posts_topic ON posts (topic_id);
CREATE INDEX idx_comments_post ON comments (post_id);
CREATE INDEX idx_comments_user ON comments (user_id);
