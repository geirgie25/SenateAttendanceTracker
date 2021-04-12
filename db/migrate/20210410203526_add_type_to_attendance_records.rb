class AddTypeToAttendanceRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :attendance_records, :type, :integer
  end
end
