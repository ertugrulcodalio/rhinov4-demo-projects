# frozen_string_literal: true

class CreateBlogs < ActiveRecord::Migration[8.0]
  def change
    create_table :blogs do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :title
      t.text :body, null: true
      t.boolean :published
      t.datetime :discarded_at
      t.index :discarded_at
      t.timestamps
    end
  end
end
