# == Schema Information
#
# Table name: itps_email_archives
#
#  id            :integer          not null, primary key
#  mailer_name   :string(255)      not null
#  mailer_method :string(255)      not null
#  destination   :string(255)      not null
#  origination   :string(255)
#  subject       :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Itps::EmailArchive < ActiveRecord::Base
  self.table_name = 'itps_email_archives'

  has_many :serialized_objects,
    class_name: 'Itps::EmailArchives::SerializedObject'

  def to_mail!
    Itps.const_get(mailer_name).send(mailer_method, *unserialized_objects, destination)
  end

  def unserialized_objects
    serialized_objects.map(&:instantiate)
  end
end
