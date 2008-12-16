class Price
  
  include Comparable
  
  @@tax_rate = 175
  cattr_accessor :tax_rate
  
  attr_accessor :money
  attr_accessor :tax
  
  def initialize(cents, currency, &block)
    @currency = currency
    @money    = Money.new(cents, @currency)
    @tax      = Money.new(0, @currency)
    yield self if block_given?
  end
  
  def tax_cents=(cents)
    @tax = Money.new(cents, @currency)
  end
  
  def take_tax_from_money
    tmp    = @money.cents.to_f / (1000 + @@tax_rate)
    @money = Money.new(tmp * 1000, @currency)
    @tax   = Money.new(tmp * @@tax_rate, @currency)
  end

  def ==(other_price)
    raise "Cannot perform comparison between prices of different currency" unless self.currency == other_price.currency
    self.with_tax == other_price.with_tax
  end
  
  def <=>(other_price)
    raise "Cannot perform comparison between prices of different currency" unless self.currency == other_price.currency
    self.with_tax <=> other_price.with_tax
  end
  
  def +(other_price)
    raise "Cannot perform arithmetic between prices of different currency" unless self.currency == other_price.currency
    Price.new(self.money.cents + other_price.money.cents, @currency) do |price|
      price.tax_cents = self.tax.cents + other_price.tax.cents
    end
  end

  def -(other_price)
    raise "Cannot perform arithmetic between prices of different currency" unless self.currency == other_price.currency
    Price.new(self.money.cents - other_price.money.cents, @currency) do |price|
      price.tax_cents = self.tax.cents - other_price.tax.cents
    end
  end

  def *(fixnum)
    Price.new(self.money.cents * fixnum, @currency) do |price|
      price.tax_cents = self.tax.cents.to_f * fixnum
    end
  end

  def /(fixnum)
    Price.new(self.money.cents / fixnum, @currency) do |price|
      price.tax_cents = self.tax.cents.to_f / fixnum
    end
  end
  
  def tax_rate
    @@tax_rate.to_f / 10
  end
  
  def with_tax
    self.money + self.tax
  end
  
  def without_tax
    self.money
  end
  
  def method_missing(method, *args)
    if self.money.send(:respond_to?, method)
      self.money.send(method, *args)
    else
      super
    end
  end
  
end