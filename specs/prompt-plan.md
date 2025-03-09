**Prompt 1: Rails Foundation**
"Create a new Rails 8.0.1 application with these components:
- PostgreSQL database configuration
- Devise authentication with admin role flag
- ActiveAdmin dashboard scaffold
- RSpec testing framework with:
  - FactoryBot
  - Database cleaner
  - Request test helpers
- Solid Queue for background jobs (replacing Sidekiq)
- Solid Cache for caching (replacing Redis)
- Solid Cable for WebSocket
Include docker-compose.yml with Elasticsearch service. Configure for Hatchbox.io deployment."

**Prompt 2: Core Models (Updated)**
"Generate models with these attributes and associations:

1. Site:
- url (unique)
- name
- author
- crawl_frequency
- last_crawled_at
- status enum (active, paused, error)
- priority (integer)
- has_errors (boolean)

2. BlogPost:
- site_id (foreign key)
- title
- content (text)
- url (unique)
- published_at
- digest (string, unique)
- summary (text)
- reading_time (integer)
- indexed (boolean)

3. CrawlLog:
- site_id
- status
- posts_found
- posts_indexed
- error_message
- started_at
- completed_at

4. SearchQuery:
- query_text
- results_count
- sources_used

5. Tag:
- name (unique)

6. BlogPostTag:
- blog_post_id (foreign key)
- tag_id (foreign key)

7. TrendingTopic:
- topic
- search_count
- is_featured
- last_trending_at

8. ContentCitation:
- blog_post_id (foreign key)
- cited_blog_post_id (foreign key)
- citation_count

9. NicheScore:
- site_id (foreign key)
- inverse_popularity_score (float)
- content_uniqueness_score (float)
- topic_specificity_score (float)
- writing_depth_score (float)
- overall_niche_score (float)
- last_calculated_at

Include:
- Model validations
- FactoryBot definitions
- RSpec model tests
- ActiveAdmin resources with basic filters"

**Prompt 3: URL Management**
"Create a UrlQueue model and service to manage crawl targets:
- Priority queue system with exponential backoff
- Track retry attempts
- Distributed locking mechanism
- Integration with Site model

Methods needed:
- enqueue_site(site)
- next_batch(limit=10)
- mark_completed(url, status)
- requeue_failed(url)

Test requirements:
- Concurrency safety tests
- Priority ordering verification
- Retry logic coverage"

**Prompt 4: Crawler Base**
"Implement base crawler class with:
- Polite crawling (robots.txt respect)
- HTML sanitization
- Content digest calculation
- URL normalization
- Error handling circuit breaker

Include:
- Link extraction service
- Content sanitizer module
- Digest generator using SHA-256
- Integration with CrawlLog

Test requirements:
- Verify politeness rules
- Test digest stability
- Validate URL normalization"

**Prompt 5: Elasticsearch Integration**
"Set up Elasticsearch integration with:
- Searchable concern for models
- Index configuration matching BlogPost schema
- Custom analyzer for content field
- Async indexing hooks
- Health check endpoint

Include:
- Search service class with:
  - Basic term search
  - Faceting
  - Highlighting
- RSpec integration tests
- ActiveAdmin search interface

Test requirements:
- Index synchronization tests
- Search relevance verification
- Failure recovery scenarios"

**Prompt 6: Summary Generation (Updated)**
"Create SummarizationService with:
- Dual extractive/abstractive approach using specific models:
  - Extractive: distilbert-base-uncased-finetuned-extractive-summarization
  - Abstractive: t5-small-finetuned-for-blog-summaries
- Result caching in Solid Cache with 24hr TTL
- API rate limiting with exponential backoff
- Local fallback using smaller distilled models
- Error budget tracking (max 5% failures per day)
- Content safety filters

API Management:
- HuggingFace API cost optimization
- Request batching (up to 5 articles)
- Priority queue based on article importance
- Local model inference for low-latency needs

Integrate with:
- BlogPost model via after_save
- ActiveAdmin dashboard
- Solid Queue jobs

Test requirements:
- Summary quality checks using ROUGE metrics
- Cache validation
- Toxicity filter tests
- Error handling verification
- API rate limit simulation tests"

**Prompt 7: Monitoring**
"Implement monitoring stack:
- Request instrumentation
- Sidekiq metrics
- Elasticsearch performance
- Crawler success rates
- Anomaly detection

Tools:
- Prometheus exporter
- Health check endpoints
- Admin dashboard widgets
- Log correlation IDs

Test requirements:
- Metric collection verification
- Alert threshold tests
- Log traceability check"

**Prompt 8: Access Control**
"Add granular permissions:
- Role-based access control
- Audit logging
- Rate limiting
- Content moderation tools
- GDPR compliance endpoints

Features:
- Data export/delete
- Consent tracking
- Request throttling
- Security headers

Test requirements:
- Authorization spec coverage
- Audit log integrity
- Compliance validation"

**Prompt 9: Modern Rails 8 Features**
"Implement modern Rails 8 features:
- Configure Solid Queue for background processing
- Set up Solid Cache for caching layer
- Implement Solid Cable for real-time updates
- Configure Hatchbox.io deployment pipeline

Features:
- Queue monitoring dashboard
- Cache statistics
- WebSocket status panel
- Zero-downtime deployment through Hatchbox

Test requirements:
- Queue processing verification
- Cache hit/miss metrics
- WebSocket connection tests
- Deployment health checks"

**Prompt X: Tag System Implementation**
"Create a complete tag system with these components:

1. TagExtractor service:
- Automatic tag extraction using TF-IDF analysis
- Named entity recognition via spaCy
- Keyword frequency analysis
- Domain-specific terminology detection

2. Tag assignment logic:
- Automatic tagging on BlogPost creation
- Manual tag management in ActiveAdmin
- Tag merging functionality
- Tag relevance scoring

3. Tag-based search functionality:
- Faceted search by tags in Elasticsearch
- Tag suggestion in search interface
- Tag cloud visualization
- Related tag discovery

Include:
- TagManager service for handling tag operations
- TagExtractionJob in Solid Queue
- TagCleanupService for maintaining tag quality
- RSpec tests for extraction accuracy

Test requirements:
- Tag extraction quality verification
- Tag assignment consistency
- Search relevance with tags
- Management interface functionality tests"

**Prompt X: Blog Post Detection**
"Implement sophisticated blog post detection with:

1. URL Pattern Detector:
- Regular expression engine for common blog URL patterns:
  - `/posts/{id}`, `/blog/{year}/{month}/{slug}`
  - Dated URL patterns (`/2025/03/15/title`)
  - Query parameter detection (`?p=123`)
- Pattern ranking by confidence score
- Site-specific pattern learning algorithm
- Test suite with 500+ real-world blog URLs

2. Content Structure Analyzer:
- HTML structure analysis for blog characteristics:
  - Article tag detection
  - Header/content ratio analysis
  - Content word count threshold (500+ words)
  - Date element proximity detection
- DOM-based classification algorithm
- Heuristic scoring system (0-100)
- Training set from 1000+ manually labeled pages

3. Temporal Signal Extractor:
- Date extraction from multiple sources:
  - Meta tags (Open Graph/Dublin Core)
  - URL date patterns
  - Content date references
  - Header proximity analysis
- Date normalization and validation
- Confidence scoring for extracted dates
- Fallback mechanism for ambiguous cases

4. Machine Learning Integration:
- Sequence classification for edge cases
  - Model: DistilBERT fine-tuned on blog classification
  - Features: URL, HTML structure, content signals
  - Output: Binary classification with confidence score
- Threshold-based decision making
- Continuous improvement through feedback loop
- Performance metrics tracking

Include:
- Blog detection service
- URL classifier
- Content analyzer
- Temporal extractor
- Fallback ML classifier
- Detection metrics dashboard
- Test suite with precision/recall metrics"


