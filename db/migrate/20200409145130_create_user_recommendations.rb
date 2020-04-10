class CreateUserRecommendations < ActiveRecord::Migration[5.2]
  def change
    create_table :user_recommendations do |t|
      t.integer :project_id
      t.string :recommendation
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
