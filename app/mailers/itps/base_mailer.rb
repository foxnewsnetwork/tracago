class Itps::BaseMailer < ActionMailer::Base
  default from: 'noreply@globaltradepayment.co'
  after_action :_serialized_objects
  attr_hash_accessor :to, :subject, :mailer_method
  attr_hash_writer :from
  attr_writer :attributes

  class << self
    def generate_email_without_archiving(method_name, *args)
      new(method_name, *args) do |mailer|
        mailer.do_not_archive!
      end.message
    end
  end

  def initialize(method_name=nil, *args, &block)
    super(nil, *args)
    yield(self) if block_given?
    process(method_name, *args) if method_name
  end

  def attributes
    @attributes ||= ActiveSupport::OrderedHash.new
  end

  def from
    self.attributes[:from] ||= 'noreply@globaltradepayment.co'
  end

  def do_not_archive!
    @do_not_archive = true
  end

  def okay_archive!
    @do_not_archive = false
  end

  def do_not_archive?
    true == @do_not_archive
  end
  private
  def _email_archive
    @email_archive ||= Itps::EmailArchive.create! _archive_params
  end
  def _serialized_objects
    return if do_not_archive?
    _objects_array.map do |object_params|
      _email_archive.serialized_objects.create(object_params)
    end
  end
  def _objects_array
    attributes.to_a.select do |arr|
      arr.last.is_a? ActiveRecord::Base
    end.map do |arr|
      {
        name_of_model: _strip_itps_from_class_name(arr.last.class.to_s),
        variable_namekey: arr.first,
        external_model_id: arr.last.id
      }
    end
  end
  def _archive_params
    {
      mailer_name: _mailer_name,
      mailer_method: attributes[:mailer_method],
      destination: attributes[:to],
      origination: attributes[:from],
      subject: attributes[:subject]
    }
  end
  def _mailer_name
    _strip_itps_from_class_name self.class.to_s
  end
  def _strip_itps_from_class_name(str)
    str.split("::").tail.join("::")
  end
  def _mail_params
    {
      to: to,
      from: from,
      subject: subject
    }
  end
end