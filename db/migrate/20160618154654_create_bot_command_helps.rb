class CreateBotCommandHelps < ActiveRecord::Migration
  def change
    create_table :bot_command_helps do |t|
      t.string :command
      t.string :description
      t.string :long_description
      t.timestamps null: false
    end
  end
end