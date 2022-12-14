# a test with the elastic terraform provider


provider "elasticstack" {
  elasticsearch {
    username  = "elastic"
    password  = resource.random_password.basic_auth_password.result
    endpoints = ["https://elastic.great-demo.com"]
  }
}

# an ingest pipeline will convert some field from our DataStream
# as datastream is doing some tests but not sending any date or cliIP let's ignore that for now
# https://registry.terraform.io/providers/elastic/elasticstack/latest/docs/resources/elasticsearch_ingest_pipeline
resource "elasticstack_elasticsearch_ingest_pipeline" "my_ingest_pipeline" {
  name        = var.ingest_pipeline
  description = "Akamai DataStream Washing Machine ingest pipeline managed by Terraform"

  processors = [
    // using the jsonencode function, which is the recommended way if you want to provide JSON object by yourself
    jsonencode({
      date = {
        description    = "convert reqTimeSec to UNIX in @timestamp field"
        field          = "reqTimeSec"
        formats        = ["UNIX"]
        ignore_failure = true
      }
    }),
    jsonencode({
      geoip = {
        description    = "Add some fancy geoIP info"
        field          = "cliIP"
        ignore_failure = true
      }
  })]
}

# create our index with a default ingest pipeline attached to it.
# https://registry.terraform.io/providers/elastic/elasticstack/latest/docs/resources/elasticsearch_index
resource "elasticstack_elasticsearch_index" "my_index" {
  name = var.index_name

  mappings = jsonencode({
    properties = {
      geoip = { properties = {
        location = { type = "geo_point", index = false }
      } }
    }
  })

  default_pipeline = resource.elasticstack_elasticsearch_ingest_pipeline.my_ingest_pipeline.name
}

