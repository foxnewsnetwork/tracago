namespace :fast_fingers do
  desc 'cheats on the 10fastfinger typing test. Specify language with FAST_LNG'
  task cheat: :environment do
    FAST_LNG ||= 'english'
    wait_for_ajax = lambda do |session|
      Timeout.timeout(Capybara.default_wait_time) do
        loop do
          active = session.evaluate_script('jQuery.active')
          break if active == 0
        end
      end
    end
    session = Capybara::Session.new :selenium
    session.visit "http://10fastfingers.com/typing-test/#{FAST_LNG}"
    session.find(:xpath, '//li[@id="my-mini-profile"]/a[@id="my-mini-profile-link"]').click
    session.find(:xpath, '//*[@id="UserUsername"]').set 'foxnewsnetwork'
    session.find(:xpath, '//*[@id="UserPassword"]').set '1234567'
    session.find(:xpath, '//*[@id="login-form-submit"]').click
    wait_for_ajax.call session
    element = session.find :xpath, '//*[@id="inputfield"]'
    doc = Nokogiri::HTML session.html
    words = []
    doc.xpath('//*[@id="row1"]/span').sort do |a,b|
      a.attribute('wordnr').value.to_i <=> b.attribute('wordnr').value.to_i
    end.each do |span|
      element.set "#{span.content} "
      words << span.content
    end
    sleep 45.seconds
    session.save_screenshot Rails.root.join("public", "type-#{FAST_LNG}-#{Time.now}.png")
  end
end