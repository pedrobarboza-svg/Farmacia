// Delete FAQ record.
query "faq/{faq_id}" verb=DELETE {
  api_group = "APIs SaborLocal"

  input {
    int faq_id? filters=min:1
  }

  stack {
    db.del FAQ {
      field_name = "id"
      field_value = $input.faq_id
    }
  }

  response = null
  guid = "1-nxEbroqW7hFklD3QZBYZx8iDg"
}