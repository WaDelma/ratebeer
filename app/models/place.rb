class Place < OpenStruct
  def self.rendered_fields
    [:name, :status, :street, :zip, :country, :overall]
  end
end
