class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :posts
  has_many :likes
  # 1:N 관계인 likes를 이용해서 Post와 N:N 관계를 구현 
  # 특정 유저가 좋아요를 누른 posts를 얻을 수 있음. 
  # ex) user.likes_posts 
  has_many :liked_posts, through: :likes, source: :post
  has_many :comments

  def is_like?(post)
    Like.find_by(user_id: self.id, post_id: post.id).present?
  end
end
