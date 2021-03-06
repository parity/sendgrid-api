class Online

  attr_reader :client

  def initialize(user, key)
    @client = Sendgrid::API::Client.new(user, key)
  end

  def sender_address_example
    Sendgrid::API::Entities::SenderAddress.new(
      :identity => 'sendgrid-api sender address test',
      :name     => 'Sendgrid',
      :email    => 'contact@sendgrid.com',
      :address  => '1065 N Pacificenter Drive, Suite 425',
      :city     => 'Anaheim',
      :state    => 'CA',
      :zip      => '92806',
      :country  => 'US'
    )
  end

  def marketing_email_example
    identity = sender_address_example.identity
    Sendgrid::API::Entities::MarketingEmail.new(
      :identity => identity, 
      :name     => 'sendgrid-api marketing email test', 
      :subject  => 'My Marketing Email Test', 
      :text     => 'My text', 
      :html     => 'My HTML'
    )
  end

  def category_example
    Sendgrid::API::Entities::Category.new(
      :category => 'sendgrid-api test'
    )
  end

  def list_example
    Sendgrid::API::Entities::List.new(
      :list => 'sendgrid-api list test'
    )
  end

  def emails_example
    [
      Sendgrid::API::Entities::Email.new(:email => 'john@example.com', :name => 'John'),
      Sendgrid::API::Entities::Email.new(:email => 'brian@example.com', :name => 'Brian')
    ]
  end

  def add_marketing_email
    client.sender_addresses.add(sender_address_example)
    client.marketing_emails.add(marketing_email_example)
  end

  def delete_marketing_email
    client.marketing_emails.delete(marketing_email_example)
    client.sender_addresses.delete(sender_address_example)
  end

  def add_list
    client.lists.add(list_example)
    client.emails.add(list_example, emails_example)
  end

  def delete_list
    client.lists.delete(list_example)
  end

  def add_recipient_list
    check_completed do
      begin
        client.recipients.add(list_example, marketing_email_example).success? 
      rescue Sendgrid::API::REST::Errors::UnprocessableEntity
        false
      end
    end
  end

  def add_marketing_email_with_list
    add_marketing_email
    add_list
    add_recipient_list
  end

  def delete_marketing_email_with_list
    delete_marketing_email
    delete_list
  end

  private

  # Check if some operation is completed or not.
  #
  # @see http://support.sendgrid.com/hc/en-us/articles/200185208-SendGrid-Web-API-may-return-successful-but-doesn-t-mean-it-has-completed
  # @param timeout [Fixnum] The maximum number of seconds to check the operation status. Default: 60 seconds.
  # @param delay [Fixnum] The number of seconds between each check. Default: 3 seconds.
  # @param &block [Block] The given block should return true if completed, otherwise false.
  # @return [Bool] The operation status
  def check_completed(timeout = 60, delay = 3)
    start = Time.now
    response = nil
    loop do
      response = yield
      duration = Time.now - start
      # puts "Checking operation - status: #{response.inspect} - duration: #{duration} seconds"
      break if response || (duration > timeout)
      sleep delay
    end
    response
  end

end