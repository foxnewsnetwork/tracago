# == Schema Information
#
# Table name: itps_accounts_fund_requests_files
#
#  id              :integer          not null, primary key
#  fund_request_id :integer
#  file_id         :integer
#

class Itps::Accounts::FundRequestsFiles < ActiveRecord::Base
  self.table_name = 'itps_accounts_fund_requests_files'
  belongs_to :fund_request,
    class_name: 'Itps::Accounts::FundRequest'

  belongs_to :file,
    class_name: 'Itps::File'
end
