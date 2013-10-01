class AddAdminToSeries < ActiveRecord::Migration
  def change
    add_column :series, :trailer, :string
  end
end
