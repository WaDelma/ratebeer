class FillStyles < ActiveRecord::Migration[5.2]
  def up
    styles = Beer.distinct.select :style
    styles.each do |style|
      if not Style.find_by(name: style.style)
        Style.create name: style.style
      end
    end
    add_reference :beers, :style, foreign_key: true
    Beer.all.each do |beer|
      style = Style.find_by(name: beer.style).id
      execute "UPDATE beers SET style_id = #{style} WHERE id = #{beer.id}"
    end
    remove_column :beers, :style, :string
  end
  def down
    add_column :beers, :style, :string
    Beer.all.each do |beer|
      style = Style.find_by(id: beer.style_id).name
      execute "UPDATE beers SET style = \"#{style}\" WHERE id = #{beer.id}"
    end
    remove_column :beers, :style_id, :bigint
  end
end
