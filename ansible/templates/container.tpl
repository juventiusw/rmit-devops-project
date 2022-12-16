[Unit]
Description=db Docker Container
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a db
ExecStop=/usr/bin/docker stop -t 2 db

[Install]
WantedBy=default.target