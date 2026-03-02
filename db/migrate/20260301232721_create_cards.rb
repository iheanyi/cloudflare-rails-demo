class CreateCards < ActiveRecord::Migration[8.1]
  def change
    create_table :cards do |t|
      t.references :board_column, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.string :label
      t.string :label_color
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :cards, [:board_column_id, :position]
  end
end
