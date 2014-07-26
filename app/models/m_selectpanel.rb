class MSelectpanel < Panel
  belongs_to :page
  has_many :options, as: :selectpanel
  has_many :tags, as: :panel
  accepts_nested_attributes_for :options, allow_destroy: true
  accepts_nested_attributes_for :tags, allow_destroy: true
end
