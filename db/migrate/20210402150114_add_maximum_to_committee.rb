class AddMaximumToCommittee < ActiveRecord::Migration[6.1]
  def change
      add_column :max_absesnse, :max_number, :integer
  end
end
