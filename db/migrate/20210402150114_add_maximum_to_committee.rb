class AddMaximumToCommittee < ActiveRecord::Migration[6.1]
  def change
      add_column :max_unexcused_absenses, :integer, :default: 7
      add_column :max_excused_absenses, :integer, :default: 11
      add_column :max_combined_absenses, :integer, :default: 11
  end
end
