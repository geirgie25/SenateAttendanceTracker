class AddMaximumToCommittee < ActiveRecord::Migration[6.1]
  def change
      add_column :committees, :max_unexcused_absences, :integer, default: 6
      add_column :committees, :max_excused_absences, :integer, default: 11
      add_column :committees, :max_combined_absences, :integer, default: 11
  end
end
