class Currency

  def initialize(available_coins)
    @available_coins = available_coins
  end

  def change_for(amount)
    validate_amount(amount)
    coins = []
    remaining_amount = amount
    @available_coins.keys.sort_by { |x| -x }.inject({}) do |change_given, coin|
      remainder = (remaining_amount / coin).to_i
      if remainder > 0
        remainder.times { coins << coin }
        change_given.merge!( { @available_coins[coin] => remainder } )
      end
      remaining_amount = amount - coins.inject(:+)
      change_given
    end
  end

  private

  def validate_amount(amount)
    unless amount.kind_of?(Integer) && amount.to_i > 0
      raise 'Invalid Amount'
    end
  end
end
