# encoding: UTF-8
require 'sinatra'
require 'mechanize'
require 'rubygems'
require 'erb'

before '/' do
	# Initialize Mechanize
	@agent ||= Mechanize.new
	@agent.user_agent_alias = 'Mac Safari'
	@page = @agent.get('http://en.wikipedia.org/wiki/Special:Random')
end

get '/' do
	@bname =  @page.title.split('-')[0]
	@page = @agent.get('http://www.quotationspage.com/random.php3')

	doc = @page.parser.xpath('//dt[@class="quote"]/a')

	link = doc.last
	t = link.content.split(' ')
	@title = t.slice(t.length-5,t.length).join(' ')

	@page = @agent.get('http://www.flickr.com/explore/interesting/7days/')

	doc = @page.parser.xpath('//span[@class="photo_container pc_m"]/a')

	@photo = doc[2]
	@photo.attribute('href').value = 'http://flickr.com'+@photo.attribute('href')
	#puts @bname, @title
	erb :index
end

not_found do
	status 404
	'That wasn\'t found, sorry. Try checking out the readme to see if you were accessing an unsupported method'
end

error do
	status 500
	'Something has gone wrong, we\'re probably looking into it'
end