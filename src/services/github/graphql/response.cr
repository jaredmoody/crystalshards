class Service::Github::GraphQL::Response(T)
  class Error
    class Location
      JSON.mapping(
        line: Int32,
        column: Int32
      )
    end

    JSON.mapping(
      message: String,
      locations: Array(Location)
    )
  end

  JSON.mapping(
    data: T?,
    errors: Array(Error)?
  )

  def self.fetch(*args, **variables) : T
    fetch(variables)
  end

  def self.fetch(variables) : T
    headers = HTTP::Headers.new
    headers["Authorization"] = "Bearer #{GITHUB_TOKEN}"
    url = "https://api.github.com/graphql"
    body = {
      query:     T::QUERY,
      variables: variables,
    }.to_json
    puts "Fetching repo by resource url:"
    puts "variables:", variables.to_pretty_json
    puts "query:", T::QUERY
    response = HTTP::Client.post(url, headers, body)
    puts "Response: #{response.status_code}"
    raise Exception.new("Bad response #{response.status_code}: #{response.body}") if response.status_code != 200
    response = from_json(response.body)
    raise "GraphQL Error: #{response.errors.try(&.map(&.message).join(""))}" if (response.errors)
    return response.data.not_nil!
  end
end
