ActiveAdmin.register UserAddress do
  belongs_to  :user

  form do |f|
    f.inputs do
      f.input :user_id,     :as => :hidden, :value => params[:user_id]
      f.input :fullname
      f.input :address_line1
      f.input :address_line2
      f.input :city
      f.input :state
      f.input :zipcode
      f.input :country
    end
    f.buttons :commit
  end
end

