class CreateInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :infos do |t|
      t.string :wallet_key
      t.string :export_key
      t.string :did
      t.string :genesis_file

      t.timestamps
    end
  end
end
