class InitialMigration < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.text :username
      t.text :password
      t.text :name
      t.timestamps
    end

    create_table :roles do |t|
      t.text :role_name
      t.timestamps
    end
    
    create_join_table :users, :roles

    create_table :committees do |t|
      t.text :committee_name
      t.timestamps
    end

    create_join_table :committees, :roles

    create_table :committee_enrollments do |t|
      t.belongs_to :committee, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
      t.timestamps
    end

    create_table :meetings do |t|
      t.timestamp :start_time
      t.timestamp :end_time
      t.belongs_to :committee, index: true, foreign_key: true
      t.timestamps
    end

    create_table :attendance_records do |t|
      t.belongs_to :meeting, index: true, foreign_key: true
      t.belongs_to :committee_enrollment, index: true, foreign_key: true
      t.boolean :attended
      t.timestamps
    end

    create_table :excuses do |t|
      t.text :reason
      t.belongs_to :attendance_record, index: true, foreign_key: true
      t.timestamps
    end
  end
end
