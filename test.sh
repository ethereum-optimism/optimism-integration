docker-compose -f docker-compose.local.yml rm;

docker-compose -f docker-compose.local.yml up --exit-code-from integration_tests;
