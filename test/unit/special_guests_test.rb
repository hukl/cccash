require 'test_helper'

class SpecialGuestsTest < ActiveSupport::TestCase

  test "special guest must have at least a name or uid" do
    assert_raise ActiveRecord::RecordInvalid do
      SpecialGuests.create!
    end
  end

  test "do not fail when only uuid is given" do
    SpecialGuests.create! :uid => "0xdeadbeef"
  end

  test "do not fail when only name is given" do
    SpecialGuests.create! :name => "Fnord"
  end

  test "do not fail when only forename is given" do
    SpecialGuests.create! :forename => "Fnord"
  end

  test "when uid is present then uid must be unique unless it's blank" do
    assert_raise ActiveRecord::RecordInvalid do
      SpecialGuests.create! :uid => "blablub0xfnord"
    end
  end

  test "when uid is blank do not fail when there is another blank uid" do
    SpecialGuests.create! :name => "fnord1"
    SpecialGuests.create! :name => "fnord2"
  end

end
