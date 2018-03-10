require 'bundler/setup'
Bundler.require
require 'active_record'
require_relative 'currency'
require_relative 'denomination'

@avaliable_coins = {}

def input_denominations(seq)
  while(true)
    print "Enter Denomination Name #{seq}: "
    denomination_name = gets().strip
    print "Enter Denomination Value #{seq}: "
    denomination_value = gets().strip
    denomination = Denomination.new(denomination_name, denomination_value.to_i)
    denomination.validate
    if (errors = denomination.errors.full_messages).any?
      errors.each { |e| puts e }
      next
    end
    if @avaliable_coins.has_key?(denomination.value) || @avaliable_coins.has_value?(denomination.name)
      puts 'This Denomination Value already exists'
      print "Hit 'y' to Override / 'n' to discard: "
      conclude = gets().strip.downcase
      case conclude
      when 'y'
        alter_denomination( denomination.to_h, 'update' )
        next
      when 'n'
        puts "Discarding #{denomination_name}, enter again"
        next
      else
        puts 'Invalid Input, try again..'
        next
      end
    else
      alter_denomination( denomination.to_h, 'add' )
      break
    end
  end
end

def alter_denomination(denomination_hash, action)
  @avaliable_coins.merge!(denomination_hash)
  actions_status = (action == 'add' ? 'Added' : 'Updated')
  puts "Denomination #{actions_status} - #{@avaliable_coins.inspect}"
end

begin
  print 'Enter the number of denominations: '
  no_of_denominations = gets().strip.to_i
  no_of_denominations.times { |i| input_denominations(i+1) }
  currency = Currency.new(@avaliable_coins)
  print 'Enter Amount to get change: '
  amount = gets().to_i
  puts currency.change_for(amount).inspect
rescue SignalException => e
  raise e
rescue StandardError => e
  puts 'Something Went Wrong - Exiting Program'
  raise e
end
