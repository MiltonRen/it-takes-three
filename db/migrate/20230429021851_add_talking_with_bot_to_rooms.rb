class AddTalkingWithBotToRooms < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :talking_with_bot, :boolean
  end
end
