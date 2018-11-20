module FilesTestHelper
  extend self #tells that all methods will be "class" methods
  extend ActionDispatch::TestProcess

  def png_name; 'test-image.png' end
  def png; upload(png_name, 'image/png') end

  private

  def upload(name, type)
    file_path = Rails.root.join('spec', 'support', 'assets', name)
    fixture_file_upload(file_path, type)
  end
end
