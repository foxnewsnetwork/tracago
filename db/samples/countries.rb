class CountryLineParser
  attr_accessor :line

  def initialize(line)
    @line = line
  end

  def parse_weird_crap!
    _parse!(/ISO 3166\-2:\w{2}$/)
  end

  def numcode!
    _parse!(/\d{3}$/)
  end

  def iso3!
    _parse!(/\w{3}$/)
  end

  def iso!
    _parse!(/\w{2}$/)
  end

  def romanized_name!
    _line
  end

  private
  def _parse!(regex)
    _line.scan(regex).first.tap { line.gsub! regex, "" }
  end

  def _line
    self.line = line.strip.gsub(/^\s*/, "")
  end
end

content = File.read Rails.root.join("db", "countries.txt")
countries = content.split("\n").map do |line|
  line_parser = CountryLineParser.new line
  line_parser.parse_weird_crap!
  numcode = line_parser.numcode!
  iso3 = line_parser.iso3!
  iso = line_parser.iso!
  romanized_name = line_parser.romanized_name!
  {
    iso: iso,
    iso3: iso3,
    romanized_name: romanized_name,
    numcode: numcode
  }
end

Spree::Country.create! countries