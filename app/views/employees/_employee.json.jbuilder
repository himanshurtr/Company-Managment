json.extract! employee, :id, :name, :last_name, :email, :address, :designation, :city, :mob_no, :salary, :technology, :created_at, :updated_at
json.url employee_url(employee, format: :json)
