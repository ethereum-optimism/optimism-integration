docker-compose -f docker-compose.local.yml down -v --remove-orphans;

docker-compose -f docker-compose.local.yml up --exit-code-from integration_tests;
