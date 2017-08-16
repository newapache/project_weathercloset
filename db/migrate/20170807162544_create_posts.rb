class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.belongs_to :user
      t.text :content
      
      t.string :image #이미지 저장 컬럼(s3 이미지링크주소 저장하면될듯??)
      t.string :date_value #날짜 저장하는 컬럼, 선경이가 만든 뷰에서 날짜 선택하는 부분이 있는데 그 값을 여기다가 저장,
      
      #입력한 옷 종류 값을 저정하는 컬럼들
      t.string :outer 
      t.string :top
      t.string :bottom
      t.string :dress
      t.string :etc
      
      t.boolean :show_attribute, :default => false #공개,비공개 여부 속성, 기본값은 false
      
      # counter_cache 기능을 사용하기 위해 필요한 컬럼
      # Like 모델을 카운팅할 것이기 때문에 이름은 likes_count
      t.integer :likes_count
      t.timestamps null: false
    end
  end
end
