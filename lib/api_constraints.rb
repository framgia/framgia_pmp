class ApiConstraints
  def initialize option
    @verison = option[:verison]
    @default = option[:default]
  end

  def matches? req
    @default || req.headers["Accept"].include?("application/crm.v#{@verison}")
  end
end
