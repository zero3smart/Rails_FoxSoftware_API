# == Schema Information
#
# Table name: shipments
#
#  id                   :integer          not null, primary key
#  notes                :string
#  picture              :string
#  secret_id            :string
#  weight               :decimal(10, 2)   default(0.0)
#  dim_w                :decimal(10, 2)   default(0.0)
#  dim_h                :decimal(10, 2)   default(0.0)
#  dim_l                :decimal(10, 2)   default(0.0)
#  distance             :integer          not null
#  n_of_cartons         :integer          default(0)
#  cubic_feet           :integer          default(0)
#  unit_count           :integer          default(0)
#  skids_count          :integer          default(0)
#  user_id              :integer
#  original_shipment_id :integer
#  hazard               :boolean          default(FALSE)
#  private_bidding      :boolean          default(FALSE)
#  active               :boolean          default(TRUE)
#  stackable            :boolean          default(TRUE)
#  price                :decimal(10, 2)
#  pickup_at            :datetime         not null
#  arrive_at            :datetime         not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_shipments_on_active   (active)
#  index_shipments_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Shipment, type: :model do
end