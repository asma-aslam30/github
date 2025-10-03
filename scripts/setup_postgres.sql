-- -- -- CREATE EXTENSION IF NOT EXISTS "pgcrypto";


-- -- -- CREATE TABLE IF NOT EXISTS repos (
-- -- -- repo_id BIGINT PRIMARY KEY,
-- -- -- node_id TEXT,
-- -- -- owner_login TEXT NOT NULL,
-- -- -- name TEXT NOT NULL,
-- -- -- full_name TEXT GENERATED ALWAYS AS (owner_login || '/' || name) STORED,
-- -- -- url TEXT,
-- -- -- primary_language TEXT,
-- -- -- description TEXT,
-- -- -- created_at TIMESTAMPTZ,
-- -- -- updated_at TIMESTAMPTZ,
-- -- -- raw JSONB,
-- -- -- inserted_at TIMESTAMPTZ NOT NULL DEFAULT now(),
-- -- -- last_synced_at TIMESTAMPTZ
-- -- -- );


-- -- -- -- time-series table for daily metrics
-- -- -- CREATE TABLE IF NOT EXISTS repo_daily_metrics (
-- -- -- id BIGSERIAL PRIMARY KEY,
-- -- -- repo_id BIGINT NOT NULL REFERENCES repos(repo_id) ON DELETE CASCADE,
-- -- -- metrics_date DATE NOT NULL,
-- -- -- stargazers_count INT NOT NULL,
-- -- -- watchers_count INT,
-- -- -- forks_count INT,
-- -- -- open_issues_count INT,
-- -- -- raw JSONB,
-- -- -- inserted_at TIMESTAMPTZ NOT NULL DEFAULT now(),
-- -- -- UNIQUE (repo_id, metrics_date)
-- -- -- );


-- -- -- -- helpful indices
-- -- -- CREATE INDEX IF NOT EXISTS idx_repo_daily_metrics_repo_date ON repo_daily_metrics(repo_id, metrics_date DESC);
-- -- -- CREATE INDEX IF NOT EXISTS idx_repos_owner ON repos(owner_login);


-- -- -- -- Partitioning note (for large scale) - example (manual steps)
-- -- -- -- You can later convert repo_daily_metrics into a range partitioned table by metrics_date.



-- -- -- Enable pgcrypto extension (optional, for UUIDs if needed)
-- -- CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- -- -- Create repos table
-- -- CREATE TABLE IF NOT EXISTS repos (
-- --     repo_id TEXT PRIMARY KEY,        -- GitHub GraphQL node ID is string
-- --     node_id TEXT,
-- --     owner_login TEXT NOT NULL,
-- --     name TEXT NOT NULL,
-- --     full_name TEXT GENERATED ALWAYS AS (owner_login || '/' || name) STORED,
-- --     url TEXT,
-- --     primary_language TEXT,
-- --     description TEXT,
-- --     stars INT,                       -- Added stars column
-- --     created_at TIMESTAMPTZ,
-- --     updated_at TIMESTAMPTZ,
-- --     raw JSONB,
-- --     inserted_at TIMESTAMPTZ NOT NULL DEFAULT now(),
-- --     last_synced_at TIMESTAMPTZ
-- -- );

-- -- -- Time-series table for daily metrics
-- -- CREATE TABLE IF NOT EXISTS repo_daily_metrics (
-- --     id BIGSERIAL PRIMARY KEY,
-- --     repo_id TEXT NOT NULL REFERENCES repos(repo_id) ON DELETE CASCADE,
-- --     metrics_date DATE NOT NULL,
-- --     stargazers_count INT NOT NULL,
-- --     watchers_count INT,
-- --     forks_count INT,
-- --     open_issues_count INT,
-- --     raw JSONB,
-- --     inserted_at TIMESTAMPTZ NOT NULL DEFAULT now(),
-- --     UNIQUE (repo_id, metrics_date)
-- -- );

-- -- -- Helpful indices
-- -- CREATE INDEX IF NOT EXISTS idx_repo_daily_metrics_repo_date 
-- --     ON repo_daily_metrics(repo_id, metrics_date DESC);

-- -- CREATE INDEX IF NOT EXISTS idx_repos_owner 
-- --     ON repos(owner_login);



-- --  -- Enable pgcrypto for UUIDs if needed
-- -- CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- -- -- Repos table
-- -- CREATE TABLE IF NOT EXISTS repos (
-- --     repo_id BIGINT PRIMARY KEY,
-- --     owner_login TEXT NOT NULL,
-- --     name TEXT NOT NULL,
-- --     full_name TEXT GENERATED ALWAYS AS (owner_login || '/' || name) STORED,
-- --     url TEXT,
-- --     stars INT,
-- --     primary_language TEXT,
-- --     description TEXT,
-- --     created_at TIMESTAMPTZ,
-- --     updated_at TIMESTAMPTZ,
-- --     raw JSONB,
-- --     inserted_at TIMESTAMPTZ NOT NULL DEFAULT now(),
-- --     last_synced_at TIMESTAMPTZ
-- -- );

-- -- -- Daily metrics table
-- -- CREATE TABLE IF NOT EXISTS repo_daily_metrics (
-- --     id BIGSERIAL PRIMARY KEY,
-- --     repo_id BIGINT NOT NULL REFERENCES repos(repo_id) ON DELETE CASCADE,
-- --     metrics_date DATE NOT NULL,
-- --     stargazers_count INT NOT NULL,
-- --     watchers_count INT,
-- --     forks_count INT,
-- --     open_issues_count INT,
-- --     raw JSONB,
-- --     inserted_at TIMESTAMPTZ NOT NULL DEFAULT now(),
-- --     UNIQUE (repo_id, metrics_date)
-- -- );

-- -- -- Issues table
-- -- CREATE TABLE IF NOT EXISTS issues (
-- --     issue_id BIGINT PRIMARY KEY,
-- --     repo_id TEXT NOT NULL REFERENCES repos(repo_id) ON DELETE CASCADE,
-- --     title TEXT,
-- --     state TEXT,
-- --     created_at TIMESTAMPTZ,
-- --     updated_at TIMESTAMPTZ,
-- --     comments_count INT,
-- --     raw JSONB,
-- --     inserted_at TIMESTAMPTZ NOT NULL DEFAULT now()
-- -- );

-- -- -- Pull Requests table
-- -- CREATE TABLE IF NOT EXISTS pull_requests (
-- --     pr_id BIGINT PRIMARY KEY,
-- --     repo_id TEXT NOT NULL REFERENCES repos(repo_id) ON DELETE CASCADE,
-- --     title TEXT,
-- --     state TEXT,
-- --     created_at TIMESTAMPTZ,
-- --     updated_at TIMESTAMPTZ,
-- --     comments_count INT,
-- --     raw JSONB,
-- --     inserted_at TIMESTAMPTZ NOT NULL DEFAULT now()
-- -- );

-- -- -- Comments table (for issues & PRs)
-- -- CREATE TABLE IF NOT EXISTS comments (
-- --     comment_id BIGINT PRIMARY KEY,
-- --     parent_type TEXT CHECK(parent_type IN ('issue','pull_request')),
-- --     parent_id BIGINT NOT NULL,
-- --     user_login TEXT,
-- --     body TEXT,
-- --     created_at TIMESTAMPTZ,
-- --     updated_at TIMESTAMPTZ,
-- --     raw JSONB,
-- --     inserted_at TIMESTAMPTZ NOT NULL DEFAULT now()
-- -- );

-- -- -- CI/CD Checks table
-- -- CREATE TABLE IF NOT EXISTS ci_checks (
-- --     check_id BIGINT PRIMARY KEY,
-- --     pr_id BIGINT NOT NULL REFERENCES pull_requests(pr_id) ON DELETE CASCADE,
-- --     name TEXT,
-- --     status TEXT,
-- --     conclusion TEXT,
-- --     completed_at TIMESTAMPTZ,
-- --     raw JSONB,
-- --     inserted_at TIMESTAMPTZ NOT NULL DEFAULT now()
-- -- );
-- -- CREATE TABLE IF NOT EXISTS labels (
-- --     label_id BIGINT PRIMARY KEY,
-- --     repo_id BIGINT NOT NULL REFERENCES repos(repo_id) ON DELETE CASCADE,
-- --     name TEXT,
-- --     color TEXT,
-- --     raw JSONB,
-- --     inserted_at TIMESTAMPTZ NOT NULL DEFAULT now()
-- -- );

-- -- CREATE TABLE IF NOT EXISTS releases (
-- --     release_id BIGINT PRIMARY KEY,
-- --     repo_id BIGINT NOT NULL REFERENCES repos(repo_id) ON DELETE CASCADE,
-- --     name TEXT,
-- --     created_at TIMESTAMPTZ,
-- --     published_at TIMESTAMPTZ,
-- --     raw JSONB,
-- --     inserted_at TIMESTAMPTZ NOT NULL DEFAULT now()
-- -- );

-- -- CREATE TABLE IF NOT EXISTS pr_reviews (
-- --     review_id BIGINT PRIMARY KEY,
-- --     pr_id BIGINT NOT NULL REFERENCES pull_requests(pr_id) ON DELETE CASCADE,
-- --     state TEXT,
-- --     author_login TEXT,
-- --     created_at TIMESTAMPTZ,
-- --     raw JSONB,
-- --     inserted_at TIMESTAMPTZ NOT NULL DEFAULT now()
-- -- );
-- -- -- Helpful indices
-- -- CREATE INDEX IF NOT EXISTS idx_repo_daily_metrics_repo_date ON repo_daily_metrics(repo_id, metrics_date DESC);
-- -- CREATE INDEX IF NOT EXISTS idx_repos_owner ON repos(owner_login);
-- -- CREATE INDEX IF NOT EXISTS idx_issues_repo ON issues(repo_id);
-- -- CREATE INDEX IF NOT EXISTS idx_pr_repo ON pull_requests(repo_id);
-- -- CREATE INDEX IF NOT EXISTS idx_comments_parent ON comments(parent_type, parent_id);
-- -- CREATE INDEX IF NOT EXISTS idx_ci_pr ON ci_checks(pr_id);

-- -- -- Indexes for labels table
-- -- CREATE INDEX IF NOT EXISTS idx_labels_repo_id ON labels(repo_id);
-- -- CREATE INDEX IF NOT EXISTS idx_labels_name ON labels(name);

-- -- -- Indexes for releases table
-- -- CREATE INDEX IF NOT EXISTS idx_releases_repo_id ON releases(repo_id);
-- -- CREATE INDEX IF NOT EXISTS idx_releases_name ON releases(name);

-- -- -- Indexes for pr_reviews table
-- -- CREATE INDEX IF NOT EXISTS idx_pr_reviews_pr_id ON pr_reviews(pr_id);
-- -- CREATE INDEX IF NOT EXISTS idx_pr_reviews_state ON pr_reviews(state);




-- -- Enable pgcrypto for UUIDs if needed
-- CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- -- Repos table
-- CREATE TABLE IF NOT EXISTS repos (
--     repo_id BIGINT PRIMARY KEY,
--     owner_login TEXT NOT NULL,
--     name TEXT NOT NULL,
--     full_name TEXT GENERATED ALWAYS AS (owner_login || '/' || name) STORED,
--     url TEXT,
--     stars INT,
--     primary_language TEXT,
--     description TEXT,
--     created_at TIMESTAMPTZ,
--     updated_at TIMESTAMPTZ,
--     raw JSONB,
--     inserted_at TIMESTAMPTZ NOT NULL DEFAULT now(),
--     last_synced_at TIMESTAMPTZ
-- );

-- -- Daily metrics table
-- CREATE TABLE IF NOT EXISTS repo_daily_metrics (
--     id BIGSERIAL PRIMARY KEY,
--     repo_id BIGINT NOT NULL REFERENCES repos(repo_id) ON DELETE CASCADE,
--     metrics_date DATE NOT NULL,
--     stargazers_count INT NOT NULL,
--     watchers_count INT,
--     forks_count INT,
--     open_issues_count INT,
--     raw JSONB,
--     inserted_at TIMESTAMPTZ NOT NULL DEFAULT now(),
--     UNIQUE (repo_id, metrics_date)
-- );

-- -- Issues table
-- CREATE TABLE IF NOT EXISTS issues (
--     issue_id BIGINT PRIMARY KEY,
--     repo_id BIGINT NOT NULL REFERENCES repos(repo_id) ON DELETE CASCADE,
--     title TEXT,
--     state TEXT,
--     created_at TIMESTAMPTZ,
--     updated_at TIMESTAMPTZ,
--     comments_count INT,
--     raw JSONB,
--     inserted_at TIMESTAMPTZ NOT NULL DEFAULT now()
-- );

-- -- Pull Requests table
-- CREATE TABLE IF NOT EXISTS pull_requests (
--     pr_id BIGINT PRIMARY KEY,
--     repo_id BIGINT NOT NULL REFERENCES repos(repo_id) ON DELETE CASCADE,
--     title TEXT,
--     state TEXT,
--     created_at TIMESTAMPTZ,
--     updated_at TIMESTAMPTZ,
--     comments_count INT,
--     raw JSONB,
--     inserted_at TIMESTAMPTZ NOT NULL DEFAULT now()
-- );

-- -- Comments table (for issues & PRs)
-- CREATE TABLE IF NOT EXISTS comments (
--     comment_id BIGINT PRIMARY KEY,
--     parent_type TEXT CHECK(parent_type IN ('issue','pull_request')),
--     parent_id BIGINT NOT NULL,
--     author_login TEXT,
--     body TEXT,
--     created_at TIMESTAMPTZ,
--     updated_at TIMESTAMPTZ,
--     raw JSONB,
--     inserted_at TIMESTAMPTZ NOT NULL DEFAULT now()
-- );

-- -- CI/CD Checks table
-- CREATE TABLE IF NOT EXISTS ci_checks (
--     check_id BIGINT PRIMARY KEY,
--     pr_id BIGINT NOT NULL REFERENCES pull_requests(pr_id) ON DELETE CASCADE,
--     name TEXT,
--     status TEXT,
--     conclusion TEXT,
--     completed_at TIMESTAMPTZ,
--     raw JSONB,
--     inserted_at TIMESTAMPTZ NOT NULL DEFAULT now()
-- );

-- -- Labels table
-- CREATE TABLE IF NOT EXISTS labels (
--     label_id BIGINT PRIMARY KEY,
--     repo_id BIGINT NOT NULL REFERENCES repos(repo_id) ON DELETE CASCADE,
--     name TEXT,
--     color TEXT,
--     raw JSONB,
--     inserted_at TIMESTAMPTZ NOT NULL DEFAULT now()
-- );

-- -- Releases table
-- CREATE TABLE IF NOT EXISTS releases (
--     release_id BIGINT PRIMARY KEY,
--     repo_id BIGINT NOT NULL REFERENCES repos(repo_id) ON DELETE CASCADE,
--     name TEXT,
--     created_at TIMESTAMPTZ,
--     published_at TIMESTAMPTZ,
--     raw JSONB,
--     inserted_at TIMESTAMPTZ NOT NULL DEFAULT now()
-- );

-- -- PR Reviews table
-- CREATE TABLE IF NOT EXISTS pr_reviews (
--     review_id BIGINT PRIMARY KEY,
--     pr_id BIGINT NOT NULL REFERENCES pull_requests(pr_id) ON DELETE CASCADE,
--     state TEXT,
--     author_login TEXT,
--     created_at TIMESTAMPTZ,
--     raw JSONB,
--     inserted_at TIMESTAMPTZ NOT NULL DEFAULT now()
-- );

-- -- Helpful indices
-- CREATE INDEX IF NOT EXISTS idx_repo_daily_metrics_repo_date ON repo_daily_metrics(repo_id, metrics_date DESC);
-- CREATE INDEX IF NOT EXISTS idx_repos_owner ON repos(owner_login);
-- CREATE INDEX IF NOT EXISTS idx_issues_repo ON issues(repo_id);
-- CREATE INDEX IF NOT EXISTS idx_pr_repo ON pull_requests(repo_id);
-- CREATE INDEX IF NOT EXISTS idx_comments_parent ON comments(parent_type, parent_id);
-- CREATE INDEX IF NOT EXISTS idx_ci_pr ON ci_checks(pr_id);
-- CREATE INDEX IF NOT EXISTS idx_labels_repo_id ON labels(repo_id);
-- CREATE INDEX IF NOT EXISTS idx_labels_name ON labels(name);
-- CREATE INDEX IF NOT EXISTS idx_releases_repo_id ON releases(repo_id);
-- CREATE INDEX IF NOT EXISTS idx_releases_name ON releases(name);
-- CREATE INDEX IF NOT EXISTS idx_pr_reviews_pr_id ON pr_reviews(pr_id);
-- CREATE INDEX IF NOT EXISTS idx_pr_reviews_state ON pr_reviews(state);



 
 
 
 
  -- Enable pgcrypto for UUIDs (if you want to use UUIDs in future)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ================================
-- Repositories table
-- ================================
CREATE TABLE IF NOT EXISTS repos (
    repo_id TEXT PRIMARY KEY, -- GitHub ka repo_id string hota hai
    owner_login TEXT NOT NULL,
    name TEXT NOT NULL,
    full_name TEXT GENERATED ALWAYS AS (owner_login || '/' || name) STORED,
    url TEXT,
    stars INT DEFAULT 0,
    primary_language TEXT,
    description TEXT,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    raw JSONB,
    inserted_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    last_synced_at TIMESTAMPTZ
);

-- ================================
-- Daily metrics
-- ================================
CREATE TABLE IF NOT EXISTS repo_daily_metrics (
    id BIGSERIAL PRIMARY KEY,
    repo_id TEXT NOT NULL REFERENCES repos(repo_id) ON DELETE CASCADE,
    metrics_date DATE NOT NULL,
    stargazers_count INT DEFAULT 0,
    watchers_count INT DEFAULT 0,
    forks_count INT DEFAULT 0,
    open_issues_count INT DEFAULT 0,
    raw JSONB,
    inserted_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (repo_id, metrics_date)
);

-- ================================
-- Issues
-- ================================
CREATE TABLE IF NOT EXISTS issues (
    issue_id BIGINT PRIMARY KEY,
    repo_id TEXT NOT NULL REFERENCES repos(repo_id) ON DELETE CASCADE,
    title TEXT,
    state TEXT CHECK (state IN ('open','closed')),
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    comments_count INT DEFAULT 0,
    raw JSONB,
    inserted_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ================================
-- Pull Requests
-- ================================
 
 
CREATE TABLE IF NOT EXISTS pull_requests (
    pr_id BIGINT PRIMARY KEY,  -- PR ka unique ID
    repo_id TEXT NOT NULL REFERENCES repos(repo_id) ON DELETE CASCADE,
    number INT NOT NULL,  -- GitHub PR number
    title TEXT,
    state TEXT CHECK (state IN ('open','closed','merged')), -- sirf valid states allow
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    merged_at TIMESTAMPTZ, -- merged wali state ke liye zaroori
    comments_count INT DEFAULT 0,
    raw JSONB,
    inserted_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (repo_id, number) -- ek hi repo ke andar PR number unique hoga
);


-- ================================
-- Comments (issues + PRs)
-- ================================
CREATE TABLE IF NOT EXISTS comments (
    comment_id BIGINT PRIMARY KEY,
    parent_type TEXT CHECK(parent_type IN ('issue','pull_request')),
    parent_id BIGINT NOT NULL,
    author_login TEXT,
    body TEXT,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    raw JSONB,
    inserted_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ================================
-- CI/CD Checks
-- ================================
CREATE TABLE IF NOT EXISTS ci_checks (
    check_id BIGINT PRIMARY KEY,
    pr_id BIGINT NOT NULL REFERENCES pull_requests(pr_id) ON DELETE CASCADE,
    name TEXT,
    status TEXT CHECK(status IN ('queued','in_progress','completed')),
    conclusion TEXT,
    completed_at TIMESTAMPTZ,
    raw JSONB,
    inserted_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ================================
-- Labels
-- ================================
CREATE TABLE IF NOT EXISTS labels (
    label_id BIGINT PRIMARY KEY,
    repo_id TEXT NOT NULL REFERENCES repos(repo_id) ON DELETE CASCADE,
    name TEXT,
    color TEXT,
    raw JSONB,
    inserted_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ================================
-- Releases
-- ================================
CREATE TABLE IF NOT EXISTS releases (
    release_id BIGINT PRIMARY KEY,
    repo_id TEXT NOT NULL REFERENCES repos(repo_id) ON DELETE CASCADE,
    name TEXT,
    created_at TIMESTAMPTZ,
    published_at TIMESTAMPTZ,
    raw JSONB,
    inserted_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ================================
-- PR Reviews
-- ================================
CREATE TABLE IF NOT EXISTS pr_reviews (
    review_id BIGINT PRIMARY KEY,
    pr_id BIGINT NOT NULL REFERENCES pull_requests(pr_id) ON DELETE CASCADE,
    state TEXT CHECK(state IN ('approved','changes_requested','commented','dismissed')),
    author_login TEXT,
    created_at TIMESTAMPTZ,
    raw JSONB,
    inserted_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ================================
-- Indices (performance boost)
-- ================================
CREATE INDEX IF NOT EXISTS idx_repo_daily_metrics_repo_date ON repo_daily_metrics(repo_id, metrics_date DESC);
CREATE INDEX IF NOT EXISTS idx_repos_owner ON repos(owner_login);
CREATE INDEX IF NOT EXISTS idx_issues_repo ON issues(repo_id);
CREATE INDEX IF NOT EXISTS idx_pr_repo ON pull_requests(repo_id);
CREATE INDEX IF NOT EXISTS idx_comments_parent ON comments(parent_type, parent_id);
CREATE INDEX IF NOT EXISTS idx_ci_pr ON ci_checks(pr_id);
CREATE INDEX IF NOT EXISTS idx_labels_repo_id ON labels(repo_id);
CREATE INDEX IF NOT EXISTS idx_labels_name ON labels(name);
CREATE INDEX IF NOT EXISTS idx_releases_repo_id ON releases(repo_id);
CREATE INDEX IF NOT EXISTS idx_releases_name ON releases(name);
CREATE INDEX IF NOT EXISTS idx_pr_reviews_pr_id ON pr_reviews(pr_id);
CREATE INDEX IF NOT EXISTS idx_pr_reviews_state ON pr_reviews(state);
