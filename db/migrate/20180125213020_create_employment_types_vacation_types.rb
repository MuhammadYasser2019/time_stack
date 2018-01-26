class CreateEmploymentTypesVacationTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :employment_types_vacation_types do |t|
      t.integer    :employment_type_id
      t.integer    :vacation_type_id
      
      t.timestamps
    end
  end
end
