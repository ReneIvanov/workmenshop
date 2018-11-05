# Preview all emails at http://localhost:3000/rails/mailers/work
class WorkPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/work/created
  def created
    WorkMailer.created
  end

end
