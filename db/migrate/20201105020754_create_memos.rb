class CreateMemos < ActiveRecord::Migration[6.0]
  def change
    create_table :memos do |t|
      t.text        :memo_text, null:false
      t.references  :user,      foreign_key: true

      t.timestamps
    end
  end
end
