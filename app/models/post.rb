class Post < ActiveRecord::Base
    
    mount_uploader :image, ImageUploader
    
    belongs_to :user
    has_many :likes
    has_many :comments
end
