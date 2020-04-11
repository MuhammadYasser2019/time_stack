class CreateUserDisciplinary < ActiveRecord::Migration[5.2]
  def change
    create_table :user_disciplinaries do |t|
      t.integer :project_id
      t.string :disciplinary
      t.integer :submitted_by
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end