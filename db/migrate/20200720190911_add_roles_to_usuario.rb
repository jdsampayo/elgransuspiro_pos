class AddRolesToUsuario < ActiveRecord::Migration[6.0]
  def change
    add_column :usuarios, :roles, :string
  end
end
