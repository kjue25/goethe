class Picture < Panel
  belongs_to :page
  has_many :tags, as: :panel
  accepts_nested_attributes_for :tags, allow_destroy: true
end
