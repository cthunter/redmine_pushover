require File.expand_path('../../test_helper', __FILE__)

class PushoverNotificationTest < ActiveSupport::TestCase

  setup do
    @fixture_path = File.expand_path '../../../../../test/fixtures/mail_handler', __FILE__
  end

  test 'should strip header from mail' do
    Setting.emails_header  = "-- In your reply, please do not write anything below this line --\n"
    m = Mail.new
    m.body = "-- In your reply, please do not write anything below this line --\n\nLorem ipsum"
    n = RedminePushover::Notification.new(m)
    assert msg = n.instance_variable_get('@message')
    assert_equal 'Lorem ipsum', msg
  end

  test 'should get text from plain text mail and cut at 1024 chars' do
    m = Mail.new IO.read File.join @fixture_path, 'ticket_with_long_subject.eml'
    assert n = RedminePushover::Notification.new(m)
    assert msg = n.instance_variable_get('@message')
    assert msg.starts_with?('Lorem ipsum')
    assert_equal 1024, msg.length
  end

  test 'should get text from multipart mail' do
    m = Mail.new IO.read File.join @fixture_path, 'ticket_reply.eml'
    assert n = RedminePushover::Notification.new(m)
    assert_equal 'This is reply', n.instance_variable_get('@message')
  end
end

