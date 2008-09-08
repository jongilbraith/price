class Price
  
  include Comparable
  
  @@tax_rate = 175
  cattr_accessor :tax_rate
  
  attr_accessor :money
  
  attr_accessor :tax
  
  attr_accessor :currency
  
  def initialize(cents, currency, tax_inclusive = false)
    @currency = currency
    
    if tax_inclusive == true
      @money = Money.new((cents.to_f / (1000 + @@tax_rate) * 1000), @currency)
      @tax = Money.new((cents.to_f / (1000 + @@tax_rate) * @@tax_rate), @currency)
    else
      @money = Money.new(cents, @currency)
      @tax = Money.new((@money.cents.to_f / 1000 * @@tax_rate), @currency)
    end
  end
  
  def <=>(other_price)
    @money.cents <=> other_price.money.cents if @currency == other_price.currency
  end
  
  def +(other_price)
    Price.new(self.without_tax.cents + other_price.without_tax.cents, @currency, false) if @currency == other_price.currency
  end
  
  def -(other_price)
    Price.new(self.without_tax.cents - other_price.without_tax.cents, @currency, false) if @currency == other_price.currency
  end
  
  def *(fixnum)
    Price.new(@money.cents * fixnum, @currency, false)    
  end

  def /(fixnum)
    Price.new(@money.cents / fixnum, @currency, false)    
  end
  
  def tax_rate
    @@tax_rate.to_f / 10
  end
  
  def with_tax
    @money + @tax
  end
  
  def without_tax
    @money
  end
  
end