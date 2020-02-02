docker container stop openwrt-build-env
docker container rm openwrt-build-env
docker run \
    -itd \
    --name openwrt-build-env \
    -h COMPILER \
    -p 10022:22 \
    -v /home/llwang/repos:/home/llwang/repos \
    nicephil/openwrt-build-env
