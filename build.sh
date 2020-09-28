docker-compose -f docker-compose.local.yml rm;

docker-compose -f docker-compose.local.yml --env-file=docker-compose.build.env up
