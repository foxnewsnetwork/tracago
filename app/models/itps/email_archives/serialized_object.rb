# == Schema Information
#
# Table name: itps_email_archives_serialized_objects
#
#  id                :integer          not null, primary key
#  email_archive_id  :integer          not null
#  order_number      :integer          default(0), not null
#  name_of_model     :string(255)      not null
#  variable_namekey  :string(255)      not null
#  external_model_id :string(255)      not null
#

class Itps::EmailArchives::SerializedObject < ActiveRecord::Base
  self.table_name = 'itps_email_archives_serialized_objects'
  belongs_to :email_archive,
    class_name: 'Itps::EmailArchive'

  def instantiate
    Itps.const_get(name_of_model).find external_model_id
  end
end
