require 'rails_helper'
require 'shifts_controller'

RSpec.describe ShiftsController, type: :controller do
  describe "GET #new" do
    it "returns http success" do
      user = FactoryBot.create(:user)
      sign_in user
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #create" do
    let(:params) { { shift: { name: 'New Shift' }, start_time_hour: '9', start_time_minute: '00', start_time_period: 'AM', end_time_hour: '5', end_time_minute: '00', end_time_period: 'PM' } }

    it "returns http success" do
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: params
      expect(Shift.last.start_time).to eq('9:00 AM')
      expect(Shift.last.end_time).to eq('5:00 PM')
      expect(response).to redirect_to customers_path
    end
  end


  describe "GET #update" do
    let(:shift) { FactoryBot.create(:shift) }
    let(:params) { { shift: { name: 'New Name' }, id: shift.id, start_time_hour: '9', start_time_minute: '00', start_time_period: 'AM', end_time_hour: '5', end_time_minute: '00', end_time_period: 'PM' } }
    it "updates the shift and redirects" do
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: params

      expect(Shift.find(shift.id).name).to eq('New Name')
      expect(Shift.last.start_time).to eq('9:00 AM')
      expect(Shift.last.end_time).to eq('5:00 PM')
      expect(response).to redirect_to(customers_path)
    end
  end

  describe "DELETE #destroy" do
    let!(:shift) { FactoryBot.create(:shift) }
    let(:params) { { shift: { name: 'New Name', id: shift.id }, id: shift.id , start_time_hour: '9', start_time_minute: '00', start_time_period: 'AM', end_time_hour: '5', end_time_minute: '00', end_time_period: 'PM' } }
    let(:new_shift_id) { new_shift.id }
    it "deletes the shift and redirects" do
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: params
      expect(Shift.where(id: shift.id).count).to eq(0)
      expect(response).to redirect_to(customers_path)
    end
  end

end