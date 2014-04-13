class ChangeUriType < ActiveRecord::Migration
  def up
    change_column :links, :uri, :text
  end

  def down
    change_column :links, :uri, :string
  end
end
