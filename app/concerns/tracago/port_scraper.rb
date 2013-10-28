class Tracago::PortScraper
  class << self
    def scraps_into(filename)
      new(filename).start! 
    end
  end

  Target = "http://freightforum.com/portcodes/index"
  XPath = '//*[@id="main"]/table/tbody/tr'
  def initialize(filename)
    @filename = filename
    _clear_file!
    @index = 0
  end

  def start!
    return if _finished?
    _doc do |line|
      _append_to_file _parse_line line
    end
    _clear_doc!
    start!
  end

  private

  def _clear_file!
    File.unlink @filename if File.exist? @filename
  end

  def _parse_line(line)
    line
  end

  def _append_to_file(line)
    File.open @filename, "a+" do |f|
      f.puts line
    end
  end

  def _finished?
    @index > 45450
  end

  def _clear_doc!
    @noko_doc = nil
  end

  def _doc(&block)
    _noko_doc.xpath(XPath).each(&block)
  end

  def _noko_doc
    @noko_doc ||= Nokogiri::HTML(open _scrap_path_plus_plus!).tap do
      puts "Hitting #{_scrap_path}..."
    end
  end

  def _scrap_path_plus_plus!
    _scrap_path.tap { @index += 50 }
  end

  def _scrap_path
    Target + "/#{@index}"
  end
end