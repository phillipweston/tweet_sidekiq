class CreateTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :oauth_token
      t.string :oauth_secret
      t.timestamps
    end

    create_table :tweets do |t|
      t.references :user
      t.string  :text
      t.datetime :tweeted_at
      t.timestamps
    end

    create_table :followers do |t|
      t.references :user
      t.string  :username
      t.timestamps
    end
    
  end
end
