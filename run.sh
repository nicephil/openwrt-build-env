docker container stop openwrt-build-env
docker container rm openwrt-build-env
docker run \
    -itd \
    --restart=always \
    --name openwrt-build-env \
    -h COMPILER \
    -p 10022:22 \
    -v /home/llwang:/home/llwang \
    nicephil/openwrt-build-env
