About github actions: https://docs.docker.com/ci-cd/github-actions/

About server actions: https://gitlab.com/MatthiasLohr/omnibus-gitlab-management-scripts/-/tree/master

Cron script

1. `crontab -e`

2. `*/1 * * * * cd /home/vladfcat/Projects/trip-bot/; ./docker-image-update-check.sh ilkhr/trip-bot ./update-github.sh`