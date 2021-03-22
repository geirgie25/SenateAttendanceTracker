class AddTitleToMeeting < ActiveRecord::Migration[6.1]
  def change
    add_column :meetings, :title, :string
  end
end
