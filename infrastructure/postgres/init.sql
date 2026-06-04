CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE crawl_jobs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  seed_url TEXT NOT NULL,
  allowed_domain TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  max_depth INT NOT NULL DEFAULT 2,
  max_pages INT NOT NULL DEFAULT 100,
  pages_crawled INT NOT NULL DEFAULT 0,
  pages_failed INT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  started_at TIMESTAMPTZ,
  finished_at TIMESTAMPTZ
);

CREATE TABLE crawl_urls (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id UUID NOT NULL REFERENCES crawl_jobs(id) ON DELETE CASCADE,
  url TEXT NOT NULL,
  normalized_url TEXT NOT NULL,
  depth INT NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'queued',
  priority INT NOT NULL DEFAULT 0,
  attempts INT NOT NULL DEFAULT 0,
  discovered_from UUID REFERENCES crawl_urls(id),
  next_fetch_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_error TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  fetched_at TIMESTAMPTZ,

  UNIQUE (job_id, normalized_url)
);

CREATE TABLE pages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id UUID NOT NULL REFERENCES crawl_jobs(id) ON DELETE CASCADE,
  crawl_url_id UUID NOT NULL REFERENCES crawl_urls(id) ON DELETE CASCADE,
  final_url TEXT,
  title TEXT,
  text_content TEXT,
  html_storage_key TEXT,
  status_code INT,
  content_type TEXT,
  content_hash TEXT,
  fetched_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  UNIQUE (crawl_url_id)
);

CREATE TABLE page_links (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id UUID NOT NULL REFERENCES crawl_jobs(id) ON DELETE CASCADE,
  from_url_id UUID NOT NULL REFERENCES crawl_urls(id) ON DELETE CASCADE,
  to_url TEXT NOT NULL,
  normalized_to_url TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE fetch_errors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id UUID NOT NULL REFERENCES crawl_jobs(id) ON DELETE CASCADE,
  crawl_url_id UUID NOT NULL REFERENCES crawl_urls(id) ON DELETE CASCADE,
  error_type TEXT NOT NULL,
  error_message TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_crawl_urls_job_status
ON crawl_urls(job_id, status);

CREATE INDEX idx_crawl_urls_queue
ON crawl_urls(status, next_fetch_at, priority DESC, created_at);

CREATE INDEX idx_pages_job
ON pages(job_id);

CREATE INDEX idx_page_links_from_url
ON page_links(from_url_id);