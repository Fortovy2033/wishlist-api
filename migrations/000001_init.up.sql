CREATE SCHEMA wlist_api;

CREATE TABLE wlist_api.users (
  id        SERIAL                        PRIMARY KEY,
  email     VARCHAR(320) NOT NULL UNIQUE  CHECK (
    email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
  ),
  pass_hash VARCHAR(256)
);

CREATE TABLE wlist_api.wishlists (
  id          SERIAL                  PRIMARY KEY,
  user_id     INT                     REFERENCES wlist_api.users(id) ON DELETE CASCADE,
  token       VARCHAR(32)   NOT NULL  UNIQUE,
  title       VARCHAR(128)  NOT NULL,
  description VARCHAR(256),
  created_at  TIMESTAMPTZ               DEFAULT NOW()
);

CREATE TABLE wlist_api.wishes (
  id          SERIAL                  PRIMARY KEY,
  wishlist_id INT                     REFERENCES wlist_api.wishlists(id) ON DELETE CASCADE,
  title       VARCHAR(128)  NOT NULL,
  description VARCHAR(256),
  link        TEXT                    CHECK (link ~* '^https?://[^\s/$.?#].[^\s]*$'),
  priority    SMALLINT      NOT NULL  CHECK (priority >= 0 AND priority <= 10),
  is_reserved BOOLEAN       NOT NULL
);
