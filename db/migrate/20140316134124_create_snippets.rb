class CreateSnippets < ActiveRecord::Migration
  def change
    create_table :snippets do |t|
      t.text :snippet
      t.references :lang, index: true
      t.string :description

      t.timestamps
    end
  end
end
