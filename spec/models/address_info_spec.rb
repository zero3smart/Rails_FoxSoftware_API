# == Schema Information
#
# Table name: address_infos
#
#  id           :integer          not null, primary key
#  type         :string
#  contact_name :string           not null
#  city         :string           not null
#  zip_code     :string           not null
#  address1     :string           not null
#  address2     :string           not null
#  state        :string(2)        not null
#  appointment  :boolean          default(FALSE)
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe AddressInfo, type: :model do
end