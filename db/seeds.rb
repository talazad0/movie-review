# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require "json"
require "uri"
require "net/http"

Movie.delete_all

puts "Creating Movies"

url = URI("https://netflix54.p.rapidapi.com/search/?query=movie&offset=0&limit_titles=50&limit_suggestions=20&lang=en")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

# Create an HTTP request
request = Net::HTTP::Get.new(url)
request["X-RapidAPI-Key"] = '48b6192f7amshb5e2a948637df63p1d867ajsne93026296e26'
request["X-RapidAPI-Host"] = 'netflix54.p.rapidapi.com'

# Send the request and get the response
response = http.request(request)

# Parse the JSON response
data = JSON.parse(response.read_body)

# Assuming you have a Movie model with 'title' and 'synopsis' attributes
movies = data['titles'].map do |title_info|
  name = title_info.dig('jawSummary', 'maturity', 'title')
  synopsis = title_info.dig('jawSummary', 'maturity', 'synopsis')

  {
    name: name,
    synopsis: synopsis
  }
end.compact # Remove nil entries

# Seed the database
movies.each do |movie|
  Movie.create!(name: movie[:name], synopsis: movie[:synopsis])
end

puts "Finished"
