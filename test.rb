# encoding: UTF-8
require 'Mechanize'
require 'rubygems'
agent = Mechanize.new
agent.user_agent_alias = 'Mac Safari'

# page = agent.get('http://en.wikipedia.org/wiki/Special:Random')
# @bname =  page.title.split('-')[0]
# page = agent.get('http://www.quotationspage.com/random.php3')

# doc = page.parser.xpath('//dt[@class="quote"]/a')

# link = doc.last
# t = link.content.split(' ')
# @title = t.slice(t.length-5,t.length).join(' ')

page = agent.get('http://www.flickr.com/explore/interesting/7days/')

doc = page.parser.xpath('//span[@class="photo_container pc_m"]/a')

@photo = doc[2]
@photo.attribute('href').value = 'http://flickr.com'+@photo.attribute('href')
puts @photo.attribute('href')

