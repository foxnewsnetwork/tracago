def image_path(name, type="jpeg")
  File.join Pathname.new(File.dirname(__FILE__)), "images", "#{name}.#{type}"
end
def image(name, type="jpeg")
  path = image_path(name, type)
  return false if !File.exist?(path)
  File.open(path)
end

inspection = Spree::Serviceables::Inspection.create!
inspection.images.create image "duck"

## Cheat for type test
# require 'capybara'
# require 'nokogiri'
# def wait_for_ajax(session)
#   Timeout.timeout(Capybara.default_wait_time) do
#     loop do
#       active = session.evaluate_script('jQuery.active')
#       break if active == 0
#     end
#   end
# end
# session = Capybara::Session.new :selenium
# session.visit "http://10fastfingers.com/typing-test/hebrew"
# session.find(:xpath, '//li[@id="my-mini-profile"]/a[@id="my-mini-profile-link"]').click
# session.find(:xpath, '//*[@id="UserUsername"]').set 'foxnewsnetwork'
# session.find(:xpath, '//*[@id="UserPassword"]').set '1234567'
# session.find(:xpath, '//*[@id="login-form-submit"]').click
# wait_for_ajax session
# element = session.find :xpath, '//*[@id="inputfield"]'
# doc = Nokogiri::HTML session.html
# words = []
# doc.xpath('//*[@id="row1"]/span').sort do |a,b|
#   a.attribute('wordnr').value.to_i <=> b.attribute('wordnr').value.to_i
# end.each do |span|
#   element.set "#{span.content} "
#   words << span.content
# end
# puts words