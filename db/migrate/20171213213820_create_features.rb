class CreateFeatures < ActiveRecord::Migration[5.0]
  def change
    create_table :features do |t|
      t.string :feature_type
      t.text   :feature_data

      t.timestamps
    end
  end
end
