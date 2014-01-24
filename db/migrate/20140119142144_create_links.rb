class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :uri
			t.boolean :permanent

      t.timestamps
    end
  end
end
