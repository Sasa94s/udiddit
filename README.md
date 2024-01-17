# Udiddit, a social news aggregator

Udiddit, a social news aggregation, web content rating, and discussion website, is currently using a risky and unreliable Postgres database schema to store the forum posts, discussions, and votes made by their users about different topics.  

## Prerequisites
- Install PostgreSQL (Recommended v14)
- Download [Dataset](https://video.udacity-data.com/topher/2020/February/5e548a9f_bad-db/bad-db.sql) into `data/` path.

## Getting Started

To setup the database schema and initial data, you need to follow these steps:
- Create database named `udiddit`
- From `data` directory, run `bad-db.sql`
- From `scripts` directory, run `create.sql` then `migrate.sql`

Or you can directly run the automation setup script from terminal:
```shell
. ./setup.sh
```

## Introduction

The schema allows posts to be created by registered users on certain topics, and can include a URL or a text content. It also allows registered users to cast an upvote (like) or downvote (dislike) for any forum post that has been created. In addition to this, the schema also allows registered users to add comments on posts.  

Here is the DDL used to create the schema:  

```sql
CREATE TABLE bad_posts (
	id SERIAL PRIMARY KEY,
	topic VARCHAR(50),
	username VARCHAR(50),
	title VARCHAR(150),
	url VARCHAR(4000) DEFAULT NULL,
	text_content TEXT DEFAULT NULL,
	upvotes TEXT,
	downvotes TEXT
);

CREATE TABLE bad_comments (
	id SERIAL PRIMARY KEY,
	username VARCHAR(50),
	post_id BIGINT,
	text_content TEXT
);
```
  
## Problem Statement

A key issue is the use of multi-value columns in the `bad_posts` table, where the `upvotes` and `downvotes` are stored as comma-separated values. This practice deviates from the principles of database normalization and can complicate data retrieval and manipulation. 

Additionally, there is a notable lack of foreign key constraints, particularly in the `bad_posts` table where the `post_id` column is un-referenced. This absence could lead to data integrity issues, such as orphan records. Another concern is the repetition of the `username` column in both the `bad_posts` and `bad_comments` tables, which suggests a potential redundancy and inefficiency in the schema design.

### `bad_posts` Table - Sample Data *(First 5 Rows)*
| id | topic | username | title | url | text\_content | upvotes | downvotes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Synergized | Gus32 | numquam quia laudantium non sed libero optio sit aliquid aut voluptatem | null | Voluptate ut similique libero architecto accusantium inventore fuga. Maxime est consequatur repellendus commodi. Consequatur veniam debitis consequatur. Et eaque a. Magnam ea rerum eos modi. Accusamus aut impedit perferendis. Quasi est ipsum. | Judah.Okuneva94,Dasia98,Maurice\_Dooley14,Dangelo\_Lynch59,Brandi.Schaefer,Jayde.Kulas74,Katarina\_Hudson,Ken.Murphy42 | Lambert.Buckridge0,Joseph\_Pouros82,Jesse\_Yost |
| 2 | Applications | Keagan\_Howell | officia temporibus molestias sequi ea qui | http://lesley.com | null | Marcellus31,Amina\_Larson,Vicky\_Hilll,Angelo\_Aufderhar64,Javier25,Wilhelmine99,Danika\_Renner88 | Aniyah\_Balistreri68,Demarcus.Berge,Melody.Ondricka,Ruben\_Kuvalis,Marlin\_Klocko7,Dangelo\_Lynch59,Alana\_Mayer17,Caleigh.McKenzie |
| 3 | Buckinghamshire | Gertrude.Nicolas48 | officiis accusamus qui at blanditiis dolor sit | http://aurelie.name | null | Evangeline.Koss65,Adolfo\_Ward,Ariel.Armstrong,Domingo\_Ratke,Noble41 | Reinhold.Little,Rosalyn44,Ezequiel\_Lindgren,Adriel50,Keith.Schroeder,Opal.Schulist22,Carissa54,Lora7,Eudora\_Dickinson68,Morgan.Aufderhar89 |
| 4 | Incredible\_Wooden\_Salad | Aurelio56 | rerum quae voluptas et nesciunt asperiores ea libero qui nihil quas dolorum | http://gerry.info | null | Julio\_Strosin,Preston\_Carroll13,Major99,Antonia\_Eichmann24 | Brandi.Schaefer,German60,Vicky\_Hilll,Lorenza95,Raegan69,Gladys.Williamson |
| 5 | Plastic | Tia.Bosco | quos voluptatem nobis sunt nam repellat | null | Deleniti et tempore aut. Est velit exercitationem voluptates et est ducimus. | Brycen\_Murphy,Cleveland51,Robyn\_Hayes,George.Windler,Cheyenne\_Green84,Monroe.Metz99,Carissa54,Elvis51,Andrew\_Keeling67,Viva\_Cassin57 | Clement57,Hoyt79 |

### `bad_comments` Table - Sample Data *(First 5 Rows)*
| id | username | post\_id | text\_content |
| :--- | :--- | :--- | :--- |
| 1 | Liliane.Lakin40 | 2615 | Voluptatem cum nisi maxime itaque porro. Tempore animi fugit mollitia consequuntur occaecati maxime quisquam et. Et autem sed quasi. |
| 2 | Adeline99 | 6755 | Ab ea ad velit tempore. Consectetur quis corporis modi id. Rerum dolorem quas doloremque eaque iusto fugiat sapiente. Voluptas id tempore nisi est et maxime porro illo. |
| 3 | Darrel\_Reynolds | 9102 | Atque quaerat et. Omnis consequatur qui possimus sit accusantium dicta. Praesentium a fugiat nisi. Qui consequatur sed rerum excepturi sunt ratione. Omnis eius et officia doloribus suscipit similique porro corrupti nam. |
| 4 | Kolby.Langosh | 9734 | Ratione facilis et beatae aut temporibus et qui nemo. Dolores officiis sapiente quod blanditiis harum quo. Error deleniti facilis reprehenderit fugit praesentium consequatur aut. Aut sit nisi. |
| 5 | Jared\_Koss45 | 890 | Veritatis doloribus officiis cupiditate quibusdam voluptatem facilis vel possimus. Consectetur saepe voluptatem minus debitis et. |

## Proposed Schema Improvements
There are several aspects that could be improved:
- Data Normalization: 
  - **Multi-values Column:** comma-separated values - Table: `bad_posts`, Columns: [`upvotes`, `downvotes`]
  - Separate `Votes` information from `bad_posts` table
- Data Integrity:
  - **Lack of Foreign Key Constraints:** un-referenced column - Table `bad_posts`, Column: `post_id`
  - **Column Repetition:** `username` column repeated in both tables `bad_posts` and `bad_comments`
- Data Consistency:
  - Add `CHECK` constraint to ensure valid URLs
  - Add `created_at` column to track the records timeline
- Query Optimization:
  - Add appropriate indexes to speed up query search and retrieval


## Schema Creation

Having done this initial investigation and assessment, before diving deep into the heart of the problem and create a new schema for Udiddit. A few guidelines are provided to consider any modelling or querying concerns.

> [Schema Guidelines](./GUIDELINES.md)

### Create `Users` Table
Stores user information. `username` is unique, not null and not empty. `last_login` and `created_at` timestamps are included for tracking purposes.
```sql
-- Users Table
CREATE TABLE users
(
    id         SERIAL      PRIMARY KEY,
    username   VARCHAR(25) UNIQUE NOT NULL,
    last_login TIMESTAMP,
    created_at TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "nonempty_username" CHECK ( COALESCE(TRIM(username), '') <> '' )
);
```

### Create `Topics` Table
Stores topics with unique names and optional descriptions.
```sql
-- Topics Table
CREATE TABLE topics
(
    id          SERIAL       PRIMARY KEY,
    name        VARCHAR(30)  UNIQUE NOT NULL,
    description VARCHAR(500) DEFAULT NULL,
    created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "nonempty_topic_name" CHECK ( COALESCE(TRIM(name), '') <> '' )
);
```

### Create `Posts` Table
Relates to `users` and `topics`. `Posts` must have either a URL or text content, but not both, enforced by the `CHECK` constraints.
```sql
-- Posts Table
CREATE TABLE posts
(
    id           SERIAL        PRIMARY KEY,
    user_id      INT           REFERENCES users (id) ON DELETE SET NULL,
    topic_id     INT           REFERENCES topics (id) ON DELETE CASCADE,
    title        VARCHAR(150)  NOT NULL,
    url          VARCHAR(4000) DEFAULT NULL,
    text_content TEXT          DEFAULT NULL,
    created_at   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "nonempty_post_title" CHECK ( COALESCE(TRIM(title), '') <> '' ),
    CONSTRAINT "text_or_url_only" CHECK ( (url IS NOT NULL OR text_content IS NOT NULL) AND
                                          (url IS NULL OR text_content IS NULL))
);
```

### Create `Comments` Table
Supports nested comments with `parent_comment_id`. Relates to `users` and `posts`, with cascading deletes.
```sql
-- Comments Table
CREATE TABLE comments
(
    id                SERIAL    PRIMARY KEY,
    user_id           INT       REFERENCES users (id) ON DELETE SET NULL,
    post_id           INT       REFERENCES posts (id) ON DELETE CASCADE,
    parent_comment_id INT       REFERENCES comments (id) ON DELETE CASCADE,
    text_content      TEXT      NOT NULL,
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "nonempty_comment_text_content" CHECK ( COALESCE(TRIM(text_content), '') <> '' )
);
```
### Create `Votes` Table
Stores votes with a constraint to ensure a `user` can only vote once per `post`. The `vote_value` is either `1` (upvote) or `-1` (downvote).
```sql
CREATE TABLE votes
(
    user_id    INT REFERENCES users (id) ON DELETE SET NULL,
    post_id    INT REFERENCES posts (id) ON DELETE CASCADE,
    vote_value SMALLINT CHECK (vote_value IN (-1, 1)),
    PRIMARY KEY (user_id, post_id)
);
```

## Data Migration

### Migrate `Users` Table
We should migrate all unique users from both bad_posts and bad_comments, as well as those who only voted (from the upvotes and downvotes columns).
```sql
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
```

### Migrate `Topics` Table
Since topic descriptions can be empty, we'll just insert the topic names.
```sql
-- Topics
INSERT INTO topics (name)
SELECT DISTINCT topic
FROM bad_posts
WHERE COALESCE(TRIM(topic), '') <> '';
```

### Migrate `Posts` Table
Migrate posts after users and topics have been inserted.
```sql
-- Posts
INSERT INTO posts (id, user_id, topic_id, title, url, text_content)
SELECT bp.id, u.id, t.id, bp.title, bp.url, bp.text_content
FROM bad_posts bp
    LEFT JOIN users u ON bp.username = u.username
    LEFT JOIN topics t ON bp.topic = t.name;
```

### Migrate `Comments` Table
Since all comments are top-level, we don't need to consider threading.
```sql
-- Comments
INSERT INTO comments (id, user_id, post_id, text_content)
SELECT bc.id, u.id, p.id, bc.text_content
FROM bad_comments bc
    LEFT JOIN users u ON bc.username = u.username
    LEFT JOIN posts p ON bc.post_id = p.id;
```

### Migrate `Votes` Table
Use `regexp_split_to_table` to handle the comma-separated values in `upvotes` and `downvotes`.
```sql
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
```

## Validation

The summary of the tables shows the deprecated `bad_posts` table has identical rows count of `50,000` as the newly migrated `posts` table, while the deprecated `bad_comments` has identical rows count of `100,000` as the newly migrated `comments` table. 

### Deprecated Tables Summary
Here is the summary of the rows count per table for the deprecated tables:

| Table | Rows Count |
| :--- | :--- |
| Bad Posts | 50000 |
| Bad Comments | 100000 |

### Migrated Tables Summary
Here is the summary of the rows count per table for the newly migrated tables:

| Table | Rows Count |
| :--- | :--- |
| Users | 11077 |
| Topics | 89 |
| Posts | 50000 |
| Comments | 100000 |
| Votes | 499710 |


## Performance Optimization

### Optimize `Users` Table
- Enhances finding `users` who haven't logged in recently.
- Enhances retrieval speed for queries based on the `username` column in the `users` table.
```sql
CREATE INDEX idx_users_last_login ON users (last_login);
CREATE INDEX idx_users_username ON users (username);
```

### Optimize `Topics` Table
- Ensures that topic `name`s are unique after trimming any leading/trailing whitespace, preventing duplicate `topics` with differences due to spacing.
- Improves performance of case-insensitive uniqueness checks on the `name` column in the `topics` table, enhancing query performance of pattern-based searches.
```sql
CREATE UNIQUE INDEX unique_idx_topics_name ON topics (TRIM(name));
CREATE UNIQUE INDEX idx_topics_name ON topics (LOWER(name) VARCHAR_PATTERN_OPS);
```

### Optimize `Posts` Table
- Enhances filtering or joining on the `user_id` column in the `posts` table, such as finding `posts` by a specific `user`.
- Improves efficiency for queries involving the `topic_id` column in the `posts` table, like retrieving all `posts` under a certain `topic`.
```sql
CREATE INDEX idx_posts_user ON posts (user_id);
CREATE INDEX idx_posts_topic ON posts (topic_id);
```

### Optimize `Comments` Table
- Enhances performance for operations that involve the `post_id` column in the `comments` table, such as retrieving all `comments` for a given `post`.
- Speeds up searches and joins on the `user_id` column in the `comments` table, useful for finding all `comments` made by a specific `user`.
```sql
CREATE INDEX idx_comments_post ON comments (post_id);
CREATE INDEX idx_comments_user ON comments (user_id);
```
