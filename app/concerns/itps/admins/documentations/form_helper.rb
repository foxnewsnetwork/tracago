class Itps::Admins::Documentations::FormHelper < Spree::FormHelperBase
  Fields = [
    :title,
    :body,
    :tags
  ]
  attr_hash_accessor *Fields
  attr_accessor :attributes
  validates *Fields,
    presence: true
  validates :tags,
    format: { with: /[a-z\s,]/i }

  def documentation!
    @documentation ||= _create_documentation.tap { |d| d.tag! *_tag_params }
  end

  def create_success?
    return true if valid? && documentation!.present? && documentation!.persisted?
    false
  end

  def create_failed?
    !create_success?
  end

  private
  def _create_documentation
    Itps::Documentation.create! title: title,
      body: body
  end

  def _tag_params
    tags.split(",").map(&:strip).map(&:scrub).map(&:downcase).map { |s| s.gsub(/\s+/, " ") }.reject(&:blank?)
  end

end