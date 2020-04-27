require "sass"

router CrystalShards do
  use HTTP::LogHandler.new
  root to: "home#home"
  static path: "/assets/bootstrap.css", string: Sass.compile_file("src/scss/bootstrap/bootstrap.scss", output_style: Sass::OutputStyle::COMPRESSED)
  static path: "/assets", dir: "./src/assets"

  scope "/shards", controller: ShardsController do
    get "/", action: index
    get "/:provider/*uri", action: show
  end

  scope "/projects", controller: ProjectsController do
    get "/", action: index
    get "/new", action: new
    post "/create", action: create
    get "/:provider/*uri", action: show
  end

  scope "/tags", controller: TagsController do
    get "/", action: index
    get "/:tag", action: show
  end

  scope "/authors", controller: AuthorsController do
    get "/", action: index
    get "/:email_or_name", action: show
  end
end

require "./controllers/*"
