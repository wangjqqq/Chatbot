class Article < ApplicationRecord
  belongs_to :user
  belongs_to :friend, :class_name => "User"
  #mount_uploader :picture, PictureUploader
end
