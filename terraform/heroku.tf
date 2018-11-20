##### CI
resource "heroku_app" "ci" {
  name = "${var.app_name}-ci"
  region = "eu"
}

## CI DB
resource "heroku_addon" "db_ci" {
  app = "${heroku_app.ci.name}"
  plan = "heroku-postgresql:hobby-dev"
}

#### Staging
resource "heroku_app" "staging" {
  name = "${var.app_name}-staging"
  region = "eu"
}

## Staging DB
resource "heroku_addon" "db_staging" {
  app = "${heroku_app.staging.name}"
  plan = "heroku-postgresql:hobby-dev"
}

#### Production
resource "heroku_app" "production" {
  name = "${var.app_name}-production"
  region = "eu"
}

## Production DB
resource "heroku_addon" "db_production" {
  app = "${heroku_app.production.name}"
  plan = "heroku-postgresql:hobby-dev"
}


##### Pipelines
resource "heroku_pipeline" "exam-app" {
  name = "${var.pipeline_name}"
}

# Connect apps to different pipeline stages
resource "heroku_pipeline_coupling" "ci" {
  app = "${heroku_app.ci.name}"
  pipeline = "${heroku_pipeline.exam-app.id}"
  stage = "development"
}

resource "heroku_pipeline_coupling" "staging" {
  app = "${heroku_app.staging.name}"
  pipeline = "${heroku_pipeline.exam-app.id}"
  stage = "staging"
}

resource "heroku_pipeline_coupling" "production" {
  app = "${heroku_app.production.name}"
  pipeline = "${heroku_pipeline.exam-app.id}"
  stage = "production"
 }


##### HostedGraphite
resource "heroku_addon" "hostedgraphite-ci" {
  app = "${heroku_app.ci.name}"
  plan = "hostedgraphite"
}

resource "heroku_addon" "hostedgraphite-staging" {
  app = "${heroku_app.staging.name}"
  plan = "hostedgraphite"
}

resource "heroku_addon" "hostedgraphite-prod" {
  app = "${heroku_app.production.name}"
  plan = "hostedgraphite"
}