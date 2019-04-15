class ChangePhoneNumColumnNameForPassengers < ActiveRecord::Migration[5.2]
  def change
    rename_column :passengers, :phone_number, :phone_num
  end
end
