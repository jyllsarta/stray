# == Schema Information
#
# Table name: release_notes
#
#  id           :bigint           not null, primary key
#  content      :text(65535)
#  published_at :datetime
#  title        :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class ReleaseNote < ApplicationRecord
end
