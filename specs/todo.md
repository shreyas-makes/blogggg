# blogggg Implementation Checklist

## Phase 1: Core Infrastructure Setup

### Rails Foundation
- [ ] Create new Rails 8.0.1 app with PostgreSQL
- [ ] Configure modern components:
  - [ ] Solid Queue (background jobs)
  - [ ] Solid Cache (caching layer)
  - [ ] Solid Cable (WebSocket)
  - [ ] Elasticsearch
- [ ] Install and configure:
  - [ ] Devise with admin flag
  - [ ] ActiveAdmin dashboard
  - [ ] RSpec + FactoryBot
  - [ ] Database Cleaner
- [ ] Configure Hatchbox.io deployment
- [ ] Implement health check endpoint
- [ ] Write infrastructure tests:
  - [ ] Service connectivity
  - [ ] Admin/user auth flows
  - [ ] Docker service initialization

## Phase 2: Data Modeling

### Core Models
- [ ] Site model:
  - [ ] Fields: url, name, crawl_frequency, last_crawled_at, status
  - [ ] Validations: unique URL, enum status
  - [ ] ActiveAdmin resource
  - [ ] Model specs

- [ ] BlogPost model:
  - [ ] Fields: site_id, title, content, url, published_at, digest
  - [ ] Validations: unique URL/digest
  - [ ] Search index hook
  - [ ] Model specs

- [ ] CrawlLog model:
  - [ ] Fields: site_id, status, posts_found, posts_indexed, error_message
  - [ ] Association specs
  - [ ] ActiveAdmin filters

## Phase 3: Crawling System (Updated)

### URL Management
- [ ] UrlQueue model:
  - [ ] Priority scoring system
  - [ ] Exponential backoff field
  - [ ] Distributed locking
  - [ ] Concurrency tests

- [ ] Queue Service:
  - [ ] enqueue_site
  - [ ] next_batch
  - [ ] mark_completed
  - [ ] requeue_failed
  - [ ] Integration tests

### Crawler Implementation
- [ ] Base crawler class:
  - [ ] robots.txt compliance
  - [ ] HTML sanitization
  - [ ] SHA-256 digest
  - [ ] URL normalization
  - [ ] Circuit breaker

- [ ] Support services:
  - [ ] Link extractor
  - [ ] Content sanitizer
  - [ ] CrawlLog integration
  - [ ] Test fixtures for edge cases

### Polite Crawling Implementation
- [ ] robots.txt Parser:
  - [ ] Standard robots.txt parsing
  - [ ] Sitemap extraction
  - [ ] Crawl-delay detection and enforcement
  - [ ] Agent-specific rule handling

- [ ] Rate Limiting:
  - [ ] Domain-specific delay calculation:
    ```ruby
    def calculate_delay(domain)
      # Start with base delay
      delay = DEFAULT_DELAY
      
      # Check for robots.txt crawl-delay
      if robots = RobotsTxt.find_by(domain: domain)
        delay = [delay, robots.crawl_delay].max
      end
      
      # Apply adaptive delay based on server response
      response_times = CrawlLog.where(domain: domain)
                        .order(created_at: :desc).limit(5)
                        .pluck(:response_time)
      
      if response_times.present?
        # Slow down if server is responding slowly
        avg_response = response_times.sum / response_times.size.to_f
        delay = [delay, avg_response * 1.5].max if avg_response > 500
      end
      
      # Apply exponential backoff for error cases
      error_count = CrawlLog.where(domain: domain, status: 'error')
                     .where('created_at > ?', 1.hour.ago).count
      delay *= (1.5 ** error_count) if error_count > 0
      
      # Cap maximum delay
      [delay, MAX_DELAY].min
    end
    ```
  - [ ] Global rate limiting pool
  - [ ] Per-domain request tracking
  - [ ] Exponential backoff for errors

- [ ] Request Identification:
  - [ ] Transparent user-agent with contact info:
    ```
    User-Agent: blogggg Crawler/1.0 (+https://blogggg.com/about/crawler)
    ```
  - [ ] Optional site owner notification system
  - [ ] Opt-out registry integration
  - [ ] Response to `Crawl-Control` headers

- [ ] Bandwidth Conservation:
  - [ ] Conditional GET with ETag/If-Modified-Since
  - [ ] Resource size limits
  - [ ] MIME type filtering
  - [ ] Compression handling

- [ ] Politeness Metrics:
  - [ ] Request timing logging
  - [ ] Compliance reporting
  - [ ] Domain-specific politeness score
  - [ ] Admin dashboard integration

## Phase 4: Search System (Updated)

### Elasticsearch Integration
- [ ] Searchable concern:
  - [ ] Async callbacks
  - [ ] Custom index mappings:
    ```json
    {
      "settings": {
        "analysis": {
          "analyzer": {
            "blog_content": {
              "type": "custom",
              "tokenizer": "standard",
              "filter": [
                "lowercase",
                "stop",
                "porter_stem"
              ]
            }
          }
        }
      },
      "mappings": {
        "properties": {
          "title": {
            "type": "text",
            "analyzer": "blog_content",
            "boost": 2.0,
            "fields": {
              "raw": { "type": "keyword" }
            }
          },
          "content": {
            "type": "text",
            "analyzer": "blog_content"
          },
          "published_at": {
            "type": "date"
          },
          "site_id": {
            "type": "integer"
          },
          "niche_score": {
            "type": "float"
          }
        }
      }
    }
    ```

- [ ] Search Service with Hybrid Ranking:
  - [ ] Implement custom scoring function:
    ```ruby
    def search_with_hybrid_ranking(query, options = {})
      es_params = {
        query: {
          function_score: {
            query: {
              multi_match: {
                query: query,
                fields: ["title^2", "content"],
                type: "best_fields"
              }
            },
            functions: [
              {
                # TF-IDF is already part of the base score (0.6 weight)
                # Recency factor (0.25 weight)
                exp: {
                  published_at: {
                    scale: "30d",
                    decay: 0.5
                  }
                },
                weight: 0.25
              },
              {
                # NicheValue factor (0.15 weight)
                field_value_factor: {
                  field: "niche_score",
                  factor: 1.0,
                  modifier: "log1p",
                  missing: 0.1
                },
                weight: 0.15
              }
            ],
            score_mode: "sum",
            boost_mode: "multiply"
          }
        },
        highlight: {
          fields: {
            content: {},
            title: {}
          }
        }
      }
      
      # Add faceting, pagination, etc.
      add_facets(es_params, options)
      add_pagination(es_params, options)
      
      # Execute search
      BlogPost.search(es_params)
    end
    ```

  - [ ] Integration with NicheScore calculation
  - [ ] Scheduled reindexing for score updates
  - [ ] Relevance tests with human evaluation

- [ ] Admin Interface:
  - [ ] Search panel with algorithm controls
  - [ ] Score visualization tools
  - [ ] A/B testing framework for ranking adjustments
  - [ ] Performance monitoring dashboard

## Phase 5: AI Features

### Summary Generation
- [ ] SummarizationService:
  - [ ] Dual-model architecture
  - [ ] Result caching
  - [ ] Fallback mechanism
  - [ ] Content safety filters

- [ ] Integration points:
  - [ ] BlogPost after_save
  - [ ] Admin dashboard
  - [ ] Sidekiq worker
  - [ ] Toxicity test suite

## Phase 6: Monitoring & Observability

- [ ] Metrics collection:
  - [ ] Request instrumentation
  - [ ] Sidekiq stats
  - [ ] ES performance
  - [ ] Crawler metrics

- [ ] Dashboard:
  - [ ] Prometheus exporter
  - [ ] Health checks
  - [ ] Log correlation IDs
  - [ ] Alert thresholds

## Phase 7: Security & Compliance

- [ ] Access control:
  - [ ] Role-based permissions
  - [ ] Audit logging
  - [ ] Rate limiting
  - [ ] Security headers

- [ ] GDPR compliance:
  - [ ] Data export
  - [ ] Right to erasure
  - [ ] Consent tracking
  - [ ] Cookie management

## Infrastructure & Deployment (Updated)

### Hetzner Infrastructure through Hatchbox.io
- [ ] Hatchbox infrastructure configuration:
  - [ ] Connect Hatchbox.io to Hetzner Cloud API
  - [ ] Define server specifications via Hatchbox interface:
    - [ ] Application servers (2x CX41)
    - [ ] Database server (CPX51)
    - [ ] Elasticsearch server (CX41)
  - [ ] Configure private network settings
  - [ ] Set up firewall rules
  - [ ] Configure backup schedules

### Hatchbox.io Deployment Pipeline
- [ ] CI/CD Configuration:
  - [ ] GitHub integration
  - [ ] Automated testing
  - [ ] Blue/green deployment strategy
  - [ ] Database migration safety checks
  - [ ] Zero-downtime deployment scripts
  - [ ] Rollback procedures

- [ ] Application Configuration:
  - [ ] Environment variables management
  - [ ] Secret key handling
  - [ ] Service discovery
  - [ ] Log routing
  - [ ] Monitoring integration

## Post-Launch

- [ ] Documentation:
  - [ ] API docs
  - [ ] Admin guide
  - [ ] Monitoring manual
  - [ ] Disaster recovery

- [ ] Maintenance:
  - [ ] Model retraining
  - [ ] Index rotation
  - [ ] Security audits
  - [ ] Dependency updates

### Performance & Security
- [ ] Infrastructure optimization:
  - [ ] Load balancer configuration
  - [ ] Database replication
  - [ ] Elasticsearch cluster setup
  - [ ] Backup verification
  - [ ] Network security audit
  - [ ] Performance benchmarking

## Additional Phase: NicheValue Scoring System

### NicheValue Implementation
- [ ] Create NicheScore model:
  - [ ] Fields: site_id, inverse_popularity_score, content_uniqueness_score, topic_specificity_score, writing_depth_score, overall_niche_score, last_calculated_at
  - [ ] Validations and ActiveAdmin resource
  - [ ] Model specs

- [ ] Inverse Popularity Calculation Service:
  - [ ] Count inbound links from other blogs
  - [ ] Calculate inverse function
  - [ ] Scale appropriately
  - [ ] Unit tests

- [ ] Content Uniqueness Analyzer:
  - [ ] TF-IDF variance calculator
  - [ ] Corpus centroid distance
  - [ ] Semantic uniqueness metrics
  - [ ] Integration tests

- [ ] Topic Specificity Service:
  - [ ] Implement LDA topic modeling
  - [ ] Calculate topic focus metrics
  - [ ] Category consistency analysis
  - [ ] Performance optimization

- [ ] Writing Depth Analyzer:
  - [ ] Reading level calculation
  - [ ] Sentence structure complexity
  - [ ] Citation/reference detection
  - [ ] Validation with human-scored samples

- [ ] NicheValue Calculation Pipeline:
  - [ ] Score aggregation algorithm
  - [ ] Scheduled recalculation jobs
  - [ ] Historical tracking
  - [ ] Relevance impact testing