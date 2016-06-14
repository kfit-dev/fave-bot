class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :channel_id
      t.string :github_username
      t.timestamps null: false
    end
  end
end
