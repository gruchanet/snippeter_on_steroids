class AlterUser < ActiveRecord::Migration
  def change
    remove_column :users, :name
    add_column :users, :name, :string
    add_column :users, :email, :string
  end
end
