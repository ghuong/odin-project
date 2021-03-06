require 'rest-client'

url = 'http://localhost:3000/users'

puts RestClient.get(url)
puts RestClient.get(url + '/1')
puts RestClient.get(url + '/new')
puts RestClient.get(url + '/1/edit')

puts RestClient.post(url, "")