class SampleMail < MailForm::Base
  attributes :name, :email
  attributes :nickname
  validates :nickname, absence: true

  before_deliver do
    evaluated_callbacks << :before
  end

  after_deliver do
    evaluated_callbacks << :after
  end

  def evaluated_callbacks
    @evaluated_callbacks ||= []
  end

  # NOTE: This code below is equivalent to what is shown above.

  # before_deliver :evaluate_before_callback
  # after_deliver :evaluate_after_callback

  # def evaluate_before_callback
  #   evaluated_callbacks << :before
  # end

  # def evaluate_after_callback
  #   evaluated_callbacks << :after
  # end

  # def evaluated_callbacks
  #   @evaluated_callbacks ||= []
  # end

  def headers
    { to: "recipient@example.com", from: self.email }
  end
end