require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }

  it { should validate_presence_of :value }
  it { should validate_presence_of :user }
  it { should validate_uniqueness_of(:user).scoped_to(%i[votable_id votable_type]) }

  it { should validate_inclusion_of(:value).in_array(%w[-1 1]) }
end
