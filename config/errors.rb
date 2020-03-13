class ErrorManager
  def self.load!
    @@errors = YAML.load_file("config/errors.yml")
  end

  def self.custom_errors
    @@errors.map do |k, v|
      [k, v[:status]]
    end.to_h
  end

  def self.find_exception(exception_class)
    @@errors[exception_class.to_s]
  end
end
