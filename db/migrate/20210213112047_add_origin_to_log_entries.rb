class AddOriginToLogEntries < ActiveRecord::Migration[6.1]
  def change
    add_column :log_entries, :origin, :string
  end
end
