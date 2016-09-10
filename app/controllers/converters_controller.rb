class ConvertersController < ApplicationController
  def index
    @converter = Converter.new
  end

  def upload
    @converter = Converter.new(converter_params)

    if @converter.valid? && @converter.valid?(:parse!)
      @converter.parse!
      save_resume
      flash.now[:success] = 'Done job, we converted your file. Take a look in statistics.'
    else
      render :index
    end
  end

  private
  def converter_params
    params.permit(:file)
  end

  def save_resume
    resume = Resume.new(file_name: @converter.file.original_filename,
                     cards: @converter.to_card.size,
                     questions: @converter.resume[:questions],
                     answers: @converter.resume[:answers],
                     content: @converter.buffer)

    resume.save if resume.valid?
  end

end
