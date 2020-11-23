class Footstep < ApplicationRecord
  belongs_to :user
  belongs_to :footstepuser, :class_name => "User"
end
