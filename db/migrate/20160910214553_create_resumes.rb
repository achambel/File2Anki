class CreateResumes < ActiveRecord::Migration[5.0]
  def change
    create_table :resumes do |t|
      t.string :file_name, null: false
      t.integer :cards, null: false
      t.integer :questions, null: false
      t.integer :answers, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
