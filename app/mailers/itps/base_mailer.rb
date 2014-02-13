class Itps::BaseMailer < ActionMailer::Base
  default from: 'noreply@globaltradepayment.co'
  after_action :_serialized_objects
  attr_hash_accessor :to, :subject, :mailer_method
  attr_hash_writer :from
  attr_writer :attributes
  
  def attributes
    @attributes ||= ActiveSupport::OrderedHash.new
  end

  def from
    self.attributes[:from] ||= 'noreply@globaltradepayment.co'
  end
  private
  def _email_archive
    @email_archive ||= Itps::EmailArchive.create _archive_params
  end
  def _serialized_objects
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