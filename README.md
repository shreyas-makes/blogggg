# Blogggg

Blogggg is a Ruby on Rails 8 application designed to provide a modern blogging platform with an intuitive interface and powerful features.

## System Requirements

* Ruby 3.4.2
* PostgreSQL
* Node.js and Yarn (for asset compilation)

## Getting Started

### Setup

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
   ```

4. Start the server
   ```
   rails server
   ```

5. Visit `http://localhost:3000` in your browser

## Features

* Blog post creation and management
* Rich text editing
* Responsive design
* User authentication
* SEO-friendly URLs

## Development

### Running Tests

```
rails test
```

### Code Quality

This project uses RuboCop for code quality:

```
rubocop
```

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

* Ruby on Rails 8
* PostgreSQL
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
