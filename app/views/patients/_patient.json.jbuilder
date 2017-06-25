json.extract! patient, :id, :account_id, :name, :phone, :age, :month, :gender, :created_at, :updated_at
json.url patient_url(patient, format: :json)
