class Footstep < ActiveRecord::Base
	belongs_to :user
	belongs_to :footstepuser, :class_name => "User"
end
