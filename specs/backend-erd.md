erDiagram
    USERS {
        id bigserial PK
        email string
        encrypted_password string
        reset_password_token string
        reset_password_sent_at datetime
        remember_created_at datetime
        created_at datetime
        updated_at datetime
        admin boolean
    }
    
    SITES {
        id bigserial PK
        url string
        name string
        author string
        last_crawled_at datetime
        crawl_frequency string
        active boolean
        priority int
        has_errors boolean
        created_at datetime
        updated_at datetime
    }
    
    BLOG_POSTS {
        id bigserial PK
        site_id bigint FK
        title string
        content text
        url string
        published_at datetime
        indexed boolean
        summary text
        reading_time int
        created_at datetime
        updated_at datetime
    }
    
    CRAWL_LOGS {
        id bigserial PK
        site_id bigint FK
        status string
        message text
        started_at datetime
        completed_at datetime
        posts_found int
        posts_indexed int
        created_at datetime
    }
    
    SEARCH_QUERIES {
        id bigserial PK
        query_text string
        results_count int
        sources_used int
        created_at datetime
    }
    
    TAGS {
        id bigserial PK
        name string
        created_at datetime
        updated_at datetime
    }
    
    BLOG_POST_TAGS {
        id bigserial PK
        blog_post_id bigint FK
        tag_id bigint FK
        created_at datetime
        updated_at datetime
    }
    
    TRENDING_TOPICS {
        id bigserial PK
        topic string
        search_count int
        is_featured boolean
        last_trending_at datetime
        created_at datetime
        updated_at datetime
    }
    
    CONTENT_CITATIONS {
        id bigserial PK
        blog_post_id bigint FK
        cited_blog_post_id bigint FK
        citation_count int
        created_at datetime
        updated_at datetime
    }
    
    NICHE_SCORES {
        id bigserial PK
        site_id bigint FK
        inverse_popularity_score float
        content_uniqueness_score float
        topic_specificity_score float
        writing_depth_score float
        overall_niche_score float
        last_calculated_at datetime
        created_at datetime
        updated_at datetime
    }
    
    SITES ||--o{ BLOG_POSTS : "has many"
    SITES ||--o{ CRAWL_LOGS : "has many"
    BLOG_POSTS ||--o{ BLOG_POST_TAGS : "has many"
    TAGS ||--o{ BLOG_POST_TAGS : "has many"
    BLOG_POSTS ||--o{ CONTENT_CITATIONS : "cites"
    BLOG_POSTS ||--o{ CONTENT_CITATIONS : "is cited by"
    SITES ||--|| NICHE_SCORES : "has one"