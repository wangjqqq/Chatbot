class Article < ApplicationRecord
  belongs_to :user,optional: true
  belongs_to :friend, :class_name => "User",optional: true
  mount_uploader :picture, PictureUploader
end
