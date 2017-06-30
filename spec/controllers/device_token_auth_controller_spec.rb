require 'rails_helper'

describe DeviseTokenAuth::RegistrationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  context 'client user with email' do
    let(:attrs) { {password: '123123', password_confirmation: '123123', about: 'BIO about', first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email} }

    it 'should properly register user with client role' do
      expect {
        json_query :post, :create, attrs
      }.to change{User.count}.by(1)
      expect(ActionMailer::Base.deliveries.size).to eq 1
      user = User.last
      # tokens not generated when need to confirm an email, see devise_token_auth_spec request
      # token_client = user.tokens.first[0]
      # expect(response.headers['access-token']).not_to be blank?
      # expect(user.uid).to eq response.headers['uid']
      # expect(user.tokens[token_client]['expiry'].to_s).to eq response.headers['expiry']
      expect(user.has_role?(:user)).to eq true
      expect(user.has_role?(:client)).to eq true
      attrs.each_pair do |k,v|
        next if [:password, :password_confirmation].include?(k)
        expect(user[k]).to eq v
      end
    end

    it 'should not register with duplicate email' do
      create :user, email: attrs[:email]
      expect {
        json_query :post, :create, attrs
      }.not_to change{User.count}
      expect(@json[:status]).to eq 'error'
      expect(ActionMailer::Base.deliveries.size).to eq 0
    end

    context 'should register carrier user' do
      it 'and check assigned invitations' do
        ship_invitation = create :ship_invitation, invitee_email: attrs[:email]
        expect {
          json_query :post, :create, attrs.merge({user_type: 'carrier'})
        }.to change{User.count}.by(1)
        user = User.last
        expect(user.ship_invitations.size).to eq 1
        expect(user.ship_invitations.first.id).to eq ship_invitation.id
        expect(user.has_role?(:user)).to eq true
        expect(user.has_role?(:carrier)).to eq true
        expect(user.has_role?(:client)).to eq false
      end

      it "and has no someone's else invitation" do
        ship_invitation = create :ship_invitation, invitee_email: FFaker::Internet.email
        expect {
          json_query :post, :create, attrs.merge({user_type: 'carrier'})
        }.to change{User.count}.by(1)
        user = User.last
        expect(user.ship_invitations.size).to eq 0
      end
    end

    it 'should not let with blank password' do
      attrs[:password] = ''
      expect {
        json_query :post, :create, attrs
        expect(@json[:errors]['password']).not_to be blank?
      }.not_to change{User.count}
    end

    it 'should not let with bad email' do
      attrs[:email] = 'bad'
      expect {
        json_query :post, :create, attrs
        expect(@json[:errors]['email']).not_to be blank?
      }.not_to change{User.count}
    end

    it 'should not let with mismatching password' do
      attrs[:password_confirmation] = 'zozosd'
      expect {
        json_query :post, :create, attrs
        expect(@json[:errors]['password_confirmation']).not_to be blank?
      }.not_to change{User.count}
    end
  end

  context 'client user with oauth' do
    let(:attrs) { {provider: 'facebook', about: 'BIO about', first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email} }

    # TODO
  end

end