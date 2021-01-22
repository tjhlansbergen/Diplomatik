class CreateLogEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :log_entries do |t|
      t.string :severity
      t.string :message

      t.timestamps
    end
  end
end
