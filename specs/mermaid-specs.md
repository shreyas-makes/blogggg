graph TD
    subgraph "Client Layer"
        Browser["User Browser"]
        AdminBrowser["Admin Browser"]
    end

    subgraph "Web Layer"
        Nginx["Nginx Web Server"]
    end

    subgraph "Application Layer"
        Rails["Rails Application<br>(Puma) <br> Rails 8"]
        AdminUI["ActiveAdmin Interface"]
    end

    subgraph "Background Processing"
        SolidQueue["Solid Queue"]
        CrawlerJobs["Crawler Jobs"]
        AIJobs["AI Summarization Jobs"]
    end

    subgraph "Data Layer"
        PostgreSQL["PostgreSQL Database"]
        Elasticsearch["Elasticsearch"]
        SolidCache["Solid Cache"]
    end

    subgraph "External Services"
        HuggingFace["Hugging Face<br>Inference API"]
    end

    subgraph "Target Sites"
        PersonalSites["Personal Websites<br>(from nownownow.com)"]
    end

    %% Client to Web Layer
    Browser -->|HTTP/HTTPS| Nginx
    AdminBrowser -->|HTTP/HTTPS| Nginx

    %% Web to Application Layer
    Nginx -->|Proxy| Rails
    Nginx -->|Proxy| AdminUI

    %% Application Components
    Rails -->|Uses| AdminUI
    Rails -->|Enqueues Jobs| SolidQueue
    
    %% Background Jobs
    SolidQueue -->|Manages| CrawlerJobs
    SolidQueue -->|Manages| AIJobs
    
    %% Data Access
    Rails -->|Queries| PostgreSQL
    Rails -->|Searches| Elasticsearch
    Rails -->|Caches| SolidCache
    
    %% Crawler Flow
    CrawlerJobs -->|Crawls| PersonalSites
    CrawlerJobs -->|Indexes| Elasticsearch
    CrawlerJobs -->|Stores| PostgreSQL
    
    %% AI Processing
    AIJobs -->|Requests| HuggingFace
    AIJobs -->|Caches Results| SolidCache
    
    %% Search Flow
    Rails -->|Searches| Elasticsearch
    Rails -->|Retrieves| PostgreSQL
    Rails -->|Checks Cache| SolidCache

    %% Deployment Management
    GitHub["GitHub Repository"] -->|Deploy| Hatchbox["Hatchbox.io"]
    Hatchbox -->|Manages| Nginx
    Hatchbox -->|Manages| Rails
    Hatchbox -->|Manages| PostgreSQL
    Hatchbox -->|Manages| SolidCache
    Hatchbox -->|Manages| SolidQueue
    
    %% Monitoring
    Logs["Application Logs"] -->|Collected From| Rails
    Logs -->|Collected From| SolidQueue