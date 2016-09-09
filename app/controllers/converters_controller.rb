class ConvertersController < ApplicationController
  def index
    @converter = Converter.new
  end

  def upload
    @converter = Converter.new(converter_params)

    if @converter.valid? && @converter.valid?(:parse!)
      @converter.parse!
      flash.now[:success] = 'Done job, we converted your file. Take a look in statistics.'
    else
      render :index
    end
  end

  private
  def converter_params
    params.permit(:file)
  end

end
