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

#url = URI("https://netflix54.p.rapidapi.com/search/?query=movie&offset=0&limit_titles=50&limit_suggestions=20&lang=en")
url = URI("https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

# Create an HTTP request
request = Net::HTTP::Get.new(url)
#request["X-RapidAPI-Key"] = '48b6192f7amshb5e2a948637df63p1d867ajsne93026296e26'
#request["X-RapidAPI-Host"] = 'netflix54.p.rapidapi.com'
request["accept"] = 'application/json'
request["Authorization"] = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzMGQyZGJjZGVjYTg0YWNjMGU0MDc3YTdhZGFjZWQzOSIsInN1YiI6IjY1Nzc2NWFiMjBlY2FmMDEzYWNiMmExYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.h6a6mdHzsSSVh_IZMh6sgLUPXatkJVZadrOy9JtDR9c'

response = http.request(request)
data = JSON.parse(response.read_body)

#movies = data['titles'].map do |title_info|
#  name = title_info.dig('jawSummary', 'maturity', 'title')
#  synopsis = title_info.dig('jawSummary', 'maturity', 'synopsis')

  #{
 #   name: name,
#    synopsis: synopsis
#  }
#end.compact


#movies.each do |movie|
#  Movie.create!(name: movie[:name], synopsis: movie[:synopsis])
#end

#10.times do
#  Movie.create!(
#    name: data['title_info']['jawSummary']['maturity']['title'],
#    synopsis: data['title-info']['jawSummary']['maturity']['synopsis']
#  )
#end

data['results'].first(20).each do |movie_data|
  name = movie_data['title'] # Assuming the API response contains 'title' field for the movie name
  synopsis = movie_data['overview']

  begin
    Movie.create!(name: name, synopsis: synopsis)
    puts "Successfully created: #{name}"
  rescue StandardError => e
    puts "Failed to create: #{name}"
    puts "Error: #{e.message}"
  end
end

puts "Finished"
