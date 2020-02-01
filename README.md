# openwrt-build-env

[![LICENSE](https://img.shields.io/github/license/mashape/apistatus.svg?style=flat-square&label=LICENSE)](https://github.com/P3TERX/openwrt-build-env/blob/master/LICENSE)

OpenWrt build environment in docker.

## Usage

### Pull or build image

- Pull image from docker hub.
  
  ```shell
  docker pull nicephil/openwrt-build-env
  ```

- Build image.
  
  ```shell
  docker build -t nicephil/openwrt-build-env .
  ```

### Run container

```shell
docker run \
    -itd \
    --name openwrt-build-env \
    -h COMPILER \
    -p 10022:22 \
    -v /home/llwang/repos/openwrt:/home/user/openwrt \
    nicephil/openwrt-build-env
```

### Set the mount directory file permissions

- Enter the `id` command to check UID and GID
  
  ```shell
  $ id
  uid=1001(llwang) gid=1001(asmc)
  ```

- Modify the UID and GID
  
  ```shell
  docker exec openwrt-build-env sudo usermod -u 1001 user
  docker exec openwrt-build-env sudo groupmod -g 1001 user
  ```

- Modify the file ownership
  
  ```shell
  docker exec openwrt-build-env sudo chown -hR user:user .
  ```

- Restart container
  
  ```shell
  docker restart openwrt-build-env
  ```

### SSH security settings

The default SSH user name and password is `user`. If you are making the container accessible from the internet you'll probably want to secure it bit. You can do one of the following two things after launching the container:

- Change password:
  
  ```shell
  docker exec -it openwrt-build-env sudo passwd user
  ```

- Don't allow passwords at all, use keys instead:
  
  ```shell
  docker cp ~/.ssh/authorized_keys openwrt-build-env:/home/user/.ssh
  docker exec openwrt-build-env sudo chown user:user /home/user/.ssh/authorized_keys
  docker exec openwrt-build-env sudo sed -i '/PasswordAuthentication /c\PasswordAuthentication no' /etc/ssh/sshd_config
  docker restart openwrt-build-env
  ```

### Enter container

- Enter from the host.
  
  ```shell
  docker exec -it openwrt-build-env zsh
  ```

- Connect via SSH.
  
  ```shell
  ssh user@IP -p 10022
  ```

### Clone source code and build

```shell
git clone woolink/openwrt_lora.git
cd openwrt
./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig
make download -j8
make V=s
```
