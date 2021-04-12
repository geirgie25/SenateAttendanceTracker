class RenamingTypeToAttendanceType < ActiveRecord::Migration[6.1]
  def change
    rename_column :attendance_records, :type, :attendance_type
  end
end
