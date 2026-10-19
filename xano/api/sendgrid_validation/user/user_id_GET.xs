// Get user record
query "user/{user_id}" verb=GET {
  api_group = "Sendgrid Validation"

  input {
    int user_id? filters=min:1
  }

  stack {
    db.get user {
      field_name = "id"
      field_value = $input.user_id
    } as $model
  
    precondition ($model != null) {
      error_type = "notfound"
      error = "Not Found"
    }
  }

  response = $model
  guid = "zgERj9V1i9cH8_FuDz4tOVsGg2w"
}