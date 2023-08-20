class CsvRecord
  attr_accessor :lineno, :model

  def initialize(lineno, model)
    @lineno = lineno
    @model = model
  end
end
