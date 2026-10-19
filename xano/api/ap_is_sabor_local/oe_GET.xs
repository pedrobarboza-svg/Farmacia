// Query all OE records
query oe verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query OE {
      return = {type: "list"}
    } as $oe
  }

  response = $oe
  guid = "d3nCDec4JCv1PXpAM9D2gT6mCjI"
}