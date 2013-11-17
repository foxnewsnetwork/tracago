Spree::Sample.load_sample("stockpiles")

def image_path(name, type="jpeg")
  File.join Pathname.new(File.dirname(__FILE__)), "images", "#{name}.#{type}"
end
def image(name, type="jpeg")
  path = image_path(name, type)
  return false if !File.exist?(path)
  File.open(path)
end

Spree::Stockpile.all.each do |stockpile|
  main_img = image(stockpile.image_name)
  if main_img
    stockpile.images.create! :attachment =>  main_img
  else
    puts "#{image_path stockpile.image_name} failed to load..."
  end
end