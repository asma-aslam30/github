# GitHub Repository Crawler

This project crawls GitHub repositories using the GraphQL API, stores data in PostgreSQL, and backs up the database daily using GitHub Actions.

## Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/your-repo.git
   cd your-repo


Install Dependencies:

Ensure Python 3.13, PostgreSQL, and Redis are installed.
Install Python packages:pip install -r crawler/requirements.txt




Set Up Environment Variables:

Create crawler/.env:GITHUB_TOKEN=your_github_token
GITHUB_TOKENS=token1,token2,token3
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/github_task
REDIS_URL=redis://localhost:6379/0




Set Up PostgreSQL:

Create database: createdb github_task
Run schema: psql -U postgres -d github_task -f setup_postgres.sql


Start Redis:
redis-server



Running

Start Celery Workers:
cd crawler
celery -A crawler.celery_app worker --loglevel=info


Run Crawler:
python crawl_stars.py


Run Local Backup:
powershell -File backup_db.ps1



Schema

repos: Stores repository details (repo_id, owner_login, name, stars, last_synced_at, etc.).
issues: Stores issue details (issue_id, repo_id, title, state).
pull_requests: Stores PR details (pr_id, repo_id, title, state).
comments: Stores comments for issues/PRs (comment_id, parent_id, parent_type).
ci_checks: Stores CI check details (check_id, pr_id, status).
labels: Stores repository labels (label_id, repo_id, name, color).
releases: Stores repository releases (release_id, repo_id, name).
pr_reviews: Stores PR reviews (review_id, pr_id, state, author_login).

Scaling

Distributed Crawling: Uses Celery with Redis for parallel task processing.
Token Rotation: Multiple GitHub tokens (GITHUB_TOKENS) to bypass rate limits.
Sharding: Plan for multiple PostgreSQL databases (e.g., shard by repo_id).
Caching: Redis caches GraphQL responses to reduce API calls.
Profiling: Use cProfile to identify bottlenecks (fetch_batch task).

GitHub Actions

Workflow: .github/workflows/postgres_backup.yaml
Runs daily at 2 AM UTC, crawls repos, and backs up the database to backups/.


