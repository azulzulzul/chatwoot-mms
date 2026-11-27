class AddBreakConfigToInboxes < ActiveRecord::Migration[7.1]
  def change
    add_column :inboxes, :break_config, :jsonb, default: {}, null: false
  end
end
