# encoding: UTF-8
require 'sinatra'
require 'mechanize'
require 'rubygems'
require 'erb'
require 'haml'


def fetch_results(num)
	@agent ||= Mechanize.new
	@agent.user_agent_alias = 'Mac Safari'
	results = []
	(1..num).each do
		page = @agent.get('http://en.wikipedia.org/wiki/Special:Random')
		bandname =  page.title.split('-')[0]
		page = @agent.get('http://www.quotationspage.com/random.php3')

		doc = page.parser.xpath('//dt[@class="quote"]/a')

		link = doc.last
		t = link.content.split(' ')
		albumtitle = t.slice(t.length-5,t.length).join(' ')

		page = @agent.get('http://www.flickr.com/explore/interesting/7days/')
		
		doc = page.parser.xpath('//span[@class="photo_container pc_m"]/a')

		photo = doc[2]
		url = 'http://flickr.com'+photo.attribute('href').value
		page = @agent.get(url)
		
		doc = page.parser.xpath('//img[@alt="photo"]')
		photo = doc[0].attribute('src').value
		
		results << {
			'url' => url,
			'photo' => photo,
			'bandname' => bandname,
			'albumtitle' => albumtitle
			}
	end
	results
end

get '/' do
	@results = fetch_results(5)
	haml(:index)
end

not_found do
	status 404
	'That page wasn\'t found, sorry.'
end

error do
	status 500
	'Something has gone wrong, we\'re probably looking into it'
end