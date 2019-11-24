To use vanilla setup for WordPress i.e. without specific CI configuration, follow these steps:

1. Start `docker-machine`, e.g.: `docker-machine start default`
2. Load docker environment variables, e.g. `eval "$(docker-machine env default)"`
3. Start docker containers, e.g. `docker-compose up --abort-on-container-exit`
4. Execute tests, e.g. `docker exec wordpress bash -c 'cd /wp-browser && vendor/bin/codecept run <test_type>'` where `<test_type>` is:
    1. acceptance: `acceptance`
    2. functional: `functional`
    3. unit: `unit`
    4. wpunit: `wpunit`
5. Stop docker containers, e.g. `docker-compose down`
