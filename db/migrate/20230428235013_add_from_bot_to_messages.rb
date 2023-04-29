class AddFromBotToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :from_bot, :boolean
  end
end
