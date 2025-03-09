# Blogggg

Blogggg is a Ruby on Rails 8 application designed to crawl and index blog posts from various sites, providing a powerful search interface with intelligent ranking algorithms.

## System Requirements

* Ruby 3.4.2
* PostgreSQL 16
* Elasticsearch 8.12.0
* Docker and Docker Compose (for local development)

## Getting Started

### Local Development Setup

1. Clone the repository
   ```
   git clone <repository-url>
   cd blogggg
   ```

2. Install dependencies
   ```
   bundle install
   ```

3. Database setup
   ```
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. Start the server
   ```
   rails server
   ```

5. Visit `http://localhost:3000` in your browser

### Docker Development Environment

For a complete development environment with PostgreSQL and Elasticsearch:

1. Start the Docker services
   ```
   docker-compose up
   ```

2. In a separate terminal, set up the database
   ```
   docker-compose exec web rails db:create db:migrate db:seed
   ```

3. Visit `http://localhost:3000` in your browser

## Default Users

After running the seed data, the following users are available:

- Admin User (ActiveAdmin): 
  - Email: admin@example.com
  - Password: password

- Regular User with Admin Flag:
  - Email: admin@blogggg.com
  - Password: password

- Regular User:
  - Email: user@blogggg.com
  - Password: password

## Features

* Blog site crawling and indexing
* Intelligent search with hybrid ranking
* Admin dashboard for site management
* Polite crawling with robots.txt compliance
* NicheValue scoring system

## Development

### Running Tests

```
bundle exec rspec
```

### Code Quality

This project uses RuboCop for code quality:

```
bundle exec rubocop
```

## Health Check

The application includes a health check endpoint at `/health` that provides status information about:

- Database connectivity
- Elasticsearch connectivity
- Solid Queue status
- Cache status

## Deployment

This application is containerized and ready for deployment using [Kamal](https://kamal-deploy.org/):

```
kamal setup
kamal deploy
```

Alternatively, you can build and run the Docker container manually:

```
docker build -t blogggg .
docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name blogggg blogggg
```

## Tech Stack

* Ruby on Rails 8.0.1
* PostgreSQL 16
* Elasticsearch 8.12.0
* Turbo & Stimulus (Hotwire)
* Importmap for JavaScript dependencies
* Solid Queue, Cache, and Cable for background processing and caching
* Docker container-based deployment

## License

[Add your license information here]

## Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request
