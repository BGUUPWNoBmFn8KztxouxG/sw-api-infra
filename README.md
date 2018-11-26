# Exam - PGR301
## Deployment
1. Fork sw-api-infra and sw-api - only master will be used by the pipeline.
2. In sw-api-infra, edit the credentials_example.yml file with your information. Leave `graphite_carbon_X` empty.
3. Rename the file to credentials.yml.
4. In sw-api-infra, edit the `terraform/variables.tf` file with desired application name (must match the one supplied in credentials.yml) and pipeline name. `Do not` append or prefix -ci, -staging or -production to the application name.
5. While in the sw-api-infra, run the following command (assuming concourse is properly set up):

`fly -t <TARGET> sp -p swapi_pipeline -c concourse/pipeline.yml -l credentials.yml`

_This pipeline was tested with concourse v4.2.1._

After unpausing the pipeline, build job should start automatically. Manually trigger the infra job. If build job finishes before infra job, restart the infra job and then run build job.

Once infra job is finished:
1. Log into heroku
2. Open the created pipeline
3. Open the ci application
4. Open the hostedgraphite addon
5. Find the carbon url (graphite host) and copy it
6. Paste it into `graphite_carbon_ci` in `credentials.yml`.
7. Repeat steps 1 to 6 for `staging` and `production` app.
8. While in sw-api-infra, run `fly -t <TARGET> sp -p swapi_pipeline -c concourse/pipeline.yml -l credentials.yml`
9. Run the `update-metric-keys` job in concourse.
    NOTE: If the update-metric-keys and build finishes around the same time, the application will fail to start due to it not picking up the environment variables. If this is the case, run the `restart-ci-app` job.
10. Go to root page of web application for further instructions.

## Tasks done
- Docker
    - Pipeline builds and deploys to Heroku with docker image
- Overvåkning, varsling og Metrics
    - StatusCake to monitor endpoints
    - HostedGraphite for metrics. 
    - Meter, counter and timer implemented in application.
- Applikasjonslogger
    - Use logback to log to logzio
## Known issues
- Due to using docker image and a hobby plan, the instance provided by heroku does not have enough memory to start the application within 60s on the first try. Therefore, swagger which is implemented, is disabled (as the application would never start in time). Even with swagger disabled, it might take a few tries before it succeeds. You can force a application restart by running the `update-metric-keys` job, if Heroku doesn't want to automatically retry.
- Free tier of hosted graphite does not have enough metrics to show all metrics added to application

## Improvements
Additional improvements made:
- Cache maven repositories
- Infrastructure job will never fail when ran several times
