class Denomination
  include ActiveModel::Validations
  attr_accessor :name, :value

  validates :name, presence: true, format: { with: /\A[a-zA-Z]+\z/ }
  validates :value, numericality: { only_integer: true, greater_than: 0 }, presence: true

  def initialize(name, value)
    @name = name
    @value = value
  end

  def to_h
    {value => name}
  end
end
