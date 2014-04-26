class Mailer < ActionMailer::Base
  default from: ENV['GMAIL_EMAIL']

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.mailer.update_prices.subject
  #
  def update_prices( count )
    @date = Time.now.strftime("%d/%m/%Y, %H:%M")
    @count = count
    mail(to: ENV['ADMIN_EMAIL'], subject: 'Update of prices have been done!')
  end
end
