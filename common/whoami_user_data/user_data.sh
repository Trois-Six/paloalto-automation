#!/bin/sh

until wget -q -O- http://ifconfig.io/ip >/dev/null 2>&1; do
    sleep 1
done

cat > /etc/apk/repositories <<-__EOF__
http://dl-cdn.alpinelinux.org/alpine/v$(cat /etc/alpine-release | cut -d'.' -f1,2)/main
http://dl-cdn.alpinelinux.org/alpine/v$(cat /etc/alpine-release | cut -d'.' -f1,2)/community
__EOF__

apk add docker
rc-update add cgroups boot
rc-update add docker default
service cgroups start
service docker start

until docker ps >/dev/null 2>&1; do
    sleep 1
done

docker run -d --restart always -p 80:80 traefik/whoami
