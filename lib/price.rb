class Price
  
  include Comparable
  
  @@tax_rate = 175
  cattr_accessor :tax_rate
  
  attr_accessor :money
  
  attr_accessor :currency
  
  attr_accessor :taxable
  
  def initialize(cents, currency, taxable = true, tax_inclusive = false)
    @currency = currency
    @taxable  = taxable
    
    raise "If something isn't taxable, you shouldn't be passing a tax inclusive price to it!" if taxable == false && tax_inclusive == true

    if tax_inclusive == true
      @money = Money.new((cents.to_f / (1000 + @@tax_rate) * 1000), self.currency)
    else
      @money = Money.new(cents, self.currency)
    end
  end
  
  def tax
    if self.taxable == true
      Money.new((self.money.cents.to_f / 1000 * @@tax_rate), self.currency)
    else
      Money.new(0, self.currency)
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
  
  alias :taxable? :taxable
  
end