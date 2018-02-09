namespace :update_employment_for_users do
	desc "update employemt id for users"
	task :update => :environment do
		User.all.each do |u|
			if u.customer_id.present?
				customer = Customer.find u.customer_id
				u.employment_type = customer.employment_types.first.id if customer.employment_types.present?
				u.save
			end
		end
	end
	
end