class ErrorManager
  def self.load!
    @@errors = YAML.load_file("config/errors.yml")
  end

  def self.custom_errors
    @@errors
  end

  def self.status(exception)
    @@errors[exception].to_sym
  end
end
