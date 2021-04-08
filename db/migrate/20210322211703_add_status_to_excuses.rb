class AddStatusToExcuses < ActiveRecord::Migration[6.1]
  def change
    add_column :excuses, :status, :integer, default: 0
  end
end
