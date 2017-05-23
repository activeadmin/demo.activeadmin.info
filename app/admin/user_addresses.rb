ActiveAdmin.register UserAddress do
  belongs_to :user
  permit_params :fullname, :address_line1, :address_line2, :city,
                :state, :zipcode, :country

  form do |f|
    f.inputs do
      f.input :fullname
      f.input :address_line1
      f.input :address_line2
      f.input :city
      f.input :state
      f.input :zipcode
      f.input :country
    end
    f.actions
  end
end
