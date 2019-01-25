# YogSottot_infra  

YogSottot Infra repository  

## ДЗ №3  

<details><summary>Спойлер</summary><p>

### способ подключения к someinternalhost в одну команду из вашего рабочего устройства  

```ssh -A -t appuser@35.228.152.71 ssh 10.166.0.3```  

Где:  
- appuser — имя пользователя  
- 35.228.152.71 — bastion  
- 10.166.0.3 — someinternalhost  

### вариант решения для подключения из консоли при помощи команды вида ssh someinternalhost из локальной консоли рабочего устройства, чтобы подключение выполнялось по алиасу someinternalhost  

Добавляем в ~/.ssh/config  

```bash

Host bastion
    HostName 35.228.152.71
    User appuser

Host someinternalhost
    ProxyCommand ssh -A bastion -W 10.166.0.3:22
    User appuser

```

<details><summary>Выполнение команды</summary><p>

```bash

[user:~IdeaProjects/YogSottot_infra] $
>ssh someinternalhost
Welcome to Ubuntu 16.04.5 LTS (GNU/Linux 4.15.0-1025-gcp x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud

0 packages can be updated.
0 updates are security updates.


Last login: Thu Dec 20 20:32:38 2018 from 10.166.0.2
utrgroup@someinternalhost:~$

```

</p></details>

### подключение к vpn  

```bash

bastion_IP = 35.228.152.71
someinternalhost_IP = 10.166.0.3

```

</p></details>

## ДЗ №4  

<details><summary>Спойлер</summary><p>

### подключение к testapp  

```bash

testapp_IP = 35.228.131.18
testapp_port = 9292

```

### Дополнительные задания  

#### В результате применения данной команды gcloud мы должны получать инстанс с уже запущенным приложением  

```bash

gcloud compute instances create reddit-app \
--boot-disk-size=10GB \
--image-family ubuntu-1604-lts \
--image-project=ubuntu-os-cloud \
--machine-type=g1-small \
--tags puma-server \
--restart-on-failure \
--metadata-from-file startup-script=startup-script.sh

```

#### Добавление правила для firewall из консоли с помощью gcloud

```bash

gcloud compute firewall-rules create default-puma-server \
--direction=INGRESS \
--priority=1000 \
--network=default \
--action=ALLOW \
--rules=tcp:9292 \
--source-ranges=0.0.0.0/0 \
--target-tags=puma-server

```

</p></details>

## ДЗ №5  

<details><summary>Спойлер</summary><p>

параметризированы:  
- ID проекта (обязательно)  
- source_image_family (обязательно)  
- machine_type  
- описание образа  
- размер и тип диска  
- название сети  
- тег сети  

<details><summary>Пример переменных</summary><p>

```json

    "variables": {
        "project_id": null,
        "disk_size": "10",
        "disk_type": "pd-standard",
        "image_description": "reddit test package",
        "machine_type": "f1-micro",
        "network": "default",
        "source_image_family": null,
        "tags": "puma-server,http-server,https-server",
        "zone": "europe-west1-b"
        },

```

</p></details>

```bash

packer.io validate -var-file=variables.json ubuntu16.json
Template validated successfully.

```

Создан базовый образ семейства reddit-base.  

<details><summary>Создание образа</summary><p>

```bash

>packer.io build -var-file=variables.json ubuntu16.json
googlecompute output will be in this color.

==> googlecompute: Checking image does not exist...
==> googlecompute: Creating temporary SSH key for instance...
==> googlecompute: Using image: ubuntu-1604-xenial-v20181204
==> googlecompute: Creating instance...
    googlecompute: Loading zone: europe-north1-b
    googlecompute: Loading machine type: f1-micro
    googlecompute: Requesting instance creation...
    googlecompute: Waiting for creation operation to complete...
    googlecompute: Instance has been created!
==> googlecompute: Waiting for the instance to become running...
    googlecompute: IP: 35.228.152.71
==> googlecompute: Using ssh communicator to connect: 35.228.152.71
==> googlecompute: Waiting for SSH to become available...
==> googlecompute: Connected to SSH!
==> googlecompute: Provisioning with shell script: scripts/install_ruby.sh
    googlecompute:
    googlecompute: WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
    googlecompute:
    googlecompute: Hit:1 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial InRelease
    googlecompute: Get:2 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates InRelease [109 kB]
    googlecompute: Get:3 http://archive.canonical.com/ubuntu xenial InRelease [11.5 kB]
    googlecompute: Get:4 http://security.ubuntu.com/ubuntu xenial-security InRelease [107 kB]
    googlecompute: Get:5 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-backports InRelease [107 kB]
    googlecompute: Get:6 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main Sources [868 kB]
    googlecompute: Get:7 http://archive.canonical.com/ubuntu xenial/partner amd64 Packages [3,128 B]
    googlecompute: Get:8 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/restricted Sources [4,808 B]
    googlecompute: Get:9 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/universe Sources [7,728 kB]
    googlecompute: Get:10 http://archive.canonical.com/ubuntu xenial/partner Translation-en [1,616 B]
    googlecompute: Get:11 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/multiverse Sources [179 kB]
    googlecompute: Get:12 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/universe amd64 Packages [7,532 kB]
    googlecompute: Get:13 http://security.ubuntu.com/ubuntu xenial-security/main Sources [139 kB]
    googlecompute: Get:14 http://security.ubuntu.com/ubuntu xenial-security/restricted Sources [2,116 B]
    googlecompute: Get:15 http://security.ubuntu.com/ubuntu xenial-security/universe Sources [91.7 kB]
    googlecompute: Get:16 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/universe Translation-en [4,354 kB]
    googlecompute: Get:17 http://security.ubuntu.com/ubuntu xenial-security/multiverse Sources [2,464 B]
    googlecompute: Get:18 http://security.ubuntu.com/ubuntu xenial-security/main amd64 Packages [597 kB]
    googlecompute: Get:19 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/multiverse amd64 Packages [144 kB]
    googlecompute: Get:20 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/multiverse Translation-en [106 kB]
    googlecompute: Get:21 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main Sources [328 kB]
    googlecompute: Get:22 http://security.ubuntu.com/ubuntu xenial-security/main Translation-en [248 kB]
    googlecompute: Get:23 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/restricted Sources [2,528 B]
    googlecompute: Get:24 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/universe Sources [238 kB]
    googlecompute: Get:25 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/multiverse Sources [8,740 B]
    googlecompute: Get:26 http://security.ubuntu.com/ubuntu xenial-security/universe amd64 Packages [411 kB]
    googlecompute: Get:27 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 Packages [901 kB]
    googlecompute: Get:28 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main Translation-en [364 kB]
    googlecompute: Get:29 http://security.ubuntu.com/ubuntu xenial-security/universe Translation-en [161 kB]
    googlecompute: Get:30 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/universe amd64 Packages [718 kB]
    googlecompute: Get:31 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/universe Translation-en [294 kB]
    googlecompute: Get:32 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/multiverse amd64 Packages [16.6 kB]
    googlecompute: Get:33 http://security.ubuntu.com/ubuntu xenial-security/multiverse amd64 Packages [3,724 B]
    googlecompute: Get:34 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/multiverse Translation-en [8,440 B]
    googlecompute: Get:35 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-backports/main Sources [4,848 B]
    googlecompute: Get:36 http://security.ubuntu.com/ubuntu xenial-security/multiverse Translation-en [1,844 B]
    googlecompute: Get:37 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-backports/universe Sources [6,740 B]
    googlecompute: Get:38 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-backports/main amd64 Packages [7,280 B]
    googlecompute: Get:39 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-backports/main Translation-en [4,456 B]
    googlecompute: Get:40 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-backports/universe amd64 Packages [7,804 B]
    googlecompute: Get:41 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-backports/universe Translation-en [4,184 B]
    googlecompute: Fetched 25.8 MB in 6s (3,729 kB/s)
    googlecompute: Reading package lists...
    googlecompute: Building dependency tree...
    googlecompute: Reading state information...
    googlecompute: 26 packages can be upgraded. Run 'apt list --upgradable' to see them.
    googlecompute:
    googlecompute: WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
    googlecompute:
    googlecompute: Reading package lists...
    googlecompute: Building dependency tree...
    googlecompute: Reading state information...
    googlecompute: The following additional packages will be installed:
    googlecompute:   binutils cpp cpp-5 dpkg-dev fakeroot fontconfig-config fonts-dejavu-core
    googlecompute:   fonts-lato g++ g++-5 gcc gcc-5 gcc-5-base javascript-common
    googlecompute:   libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl
    googlecompute:   libasan2 libatomic1 libc-dev-bin libc6-dev libcc1-0 libcilkrts5 libdpkg-perl
    googlecompute:   libfakeroot libfile-fcntllock-perl libfontconfig1 libgcc-5-dev libgmp-dev
    googlecompute:   libgmpxx4ldbl libgomp1 libisl15 libitm1 libjs-jquery liblsan0 libmpc3
    googlecompute:   libmpx0 libquadmath0 libruby2.3 libstdc++-5-dev libstdc++6 libtcl8.6
    googlecompute:   libtcltk-ruby libtk8.6 libtsan0 libubsan0 libxft2 libxrender1 libxss1
    googlecompute:   linux-libc-dev make manpages-dev rake ri ruby ruby-dev ruby-did-you-mean
    googlecompute:   ruby-minitest ruby-molinillo ruby-net-http-persistent ruby-net-telnet
    googlecompute:   ruby-power-assert ruby-test-unit ruby-thor ruby2.3 ruby2.3-dev ruby2.3-doc
    googlecompute:   ruby2.3-tcltk rubygems-integration unzip x11-common zip
    googlecompute: Suggested packages:
    googlecompute:   binutils-doc cpp-doc gcc-5-locales debian-keyring g++-multilib
    googlecompute:   g++-5-multilib gcc-5-doc libstdc++6-5-dbg gcc-multilib autoconf automake
    googlecompute:   libtool flex bison gdb gcc-doc gcc-5-multilib libgcc1-dbg libgomp1-dbg
    googlecompute:   libitm1-dbg libatomic1-dbg libasan2-dbg liblsan0-dbg libtsan0-dbg
    googlecompute:   libubsan0-dbg libcilkrts5-dbg libmpx0-dbg libquadmath0-dbg apache2
    googlecompute:   | lighttpd | httpd glibc-doc gmp-doc libgmp10-doc libmpfr-dev
    googlecompute:   libstdc++-5-doc tcl8.6 tk8.6 make-doc bundler
    googlecompute: The following NEW packages will be installed:
    googlecompute:   binutils build-essential cpp cpp-5 dpkg-dev fakeroot fontconfig-config
    googlecompute:   fonts-dejavu-core fonts-lato g++ g++-5 gcc gcc-5 javascript-common
    googlecompute:   libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl
    googlecompute:   libasan2 libatomic1 libc-dev-bin libc6-dev libcc1-0 libcilkrts5 libdpkg-perl
    googlecompute:   libfakeroot libfile-fcntllock-perl libfontconfig1 libgcc-5-dev libgmp-dev
    googlecompute:   libgmpxx4ldbl libgomp1 libisl15 libitm1 libjs-jquery liblsan0 libmpc3
    googlecompute:   libmpx0 libquadmath0 libruby2.3 libstdc++-5-dev libtcl8.6 libtcltk-ruby
    googlecompute:   libtk8.6 libtsan0 libubsan0 libxft2 libxrender1 libxss1 linux-libc-dev make
    googlecompute:   manpages-dev rake ri ruby ruby-bundler ruby-dev ruby-did-you-mean ruby-full
    googlecompute:   ruby-minitest ruby-molinillo ruby-net-http-persistent ruby-net-telnet
    googlecompute:   ruby-power-assert ruby-test-unit ruby-thor ruby2.3 ruby2.3-dev ruby2.3-doc
    googlecompute:   ruby2.3-tcltk rubygems-integration unzip x11-common zip
    googlecompute: The following packages will be upgraded:
    googlecompute:   gcc-5-base libstdc++6
    googlecompute: 2 upgraded, 73 newly installed, 0 to remove and 24 not upgraded.
    googlecompute: Need to get 53.0 MB of archives.
    googlecompute: After this operation, 220 MB of additional disk space will be used.
    googlecompute: Get:1 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 fonts-lato all 2.0-1 [2,693 kB]
    googlecompute: Get:2 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 fonts-dejavu-core all 2.35-1 [1,039 kB]
    googlecompute: Get:3 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 fontconfig-config all 2.11.94-0ubuntu1.1 [49.9 kB]
    googlecompute: Get:4 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 libfontconfig1 amd64 2.11.94-0ubuntu1.1 [131 kB]
    googlecompute: Get:5 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 libxrender1 amd64 1:0.9.9-0ubuntu1 [18.5 kB]
    googlecompute: Get:6 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 libxft2 amd64 2.3.2-1 [36.1 kB]
    googlecompute: Get:7 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 x11-common all 1:7.7+13ubuntu3.1 [22.9 kB]
    googlecompute: Get:8 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 libxss1 amd64 1:1.2.2-1 [8,582 B]
    googlecompute: Get:9 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 libmpc3 amd64 1.0.3-1 [39.7 kB]
    googlecompute: Get:10 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 gcc-5-base amd64 5.4.0-6ubuntu1~16.04.11 [17.3 kB]
    googlecompute: Get:11 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 libstdc++6 amd64 5.4.0-6ubuntu1~16.04.11 [393 kB]
    googlecompute: Get:12 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 binutils amd64 2.26.1-1ubuntu1~16.04.7 [2,309 kB]
    googlecompute: Get:13 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 libc-dev-bin amd64 2.23-0ubuntu10 [68.7 kB]
    googlecompute: Get:14 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 linux-libc-dev amd64 4.4.0-141.167 [854 kB]
    googlecompute: Get:15 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 libc6-dev amd64 2.23-0ubuntu10 [2,079 kB]
    googlecompute: Get:16 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 libisl15 amd64 0.16.1-1 [524 kB]
    googlecompute: Get:17 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 cpp-5 amd64 5.4.0-6ubuntu1~16.04.11 [7,660 kB]
    googlecompute: Get:18 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 cpp amd64 4:5.3.1-1ubuntu1 [27.7 kB]
    googlecompute: Get:19 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 libcc1-0 amd64 5.4.0-6ubuntu1~16.04.11 [38.8 kB]
    googlecompute: Get:20 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 libgomp1 amd64 5.4.0-6ubuntu1~16.04.11 [55.0 kB]
    googlecompute: Get:21 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 libitm1 amd64 5.4.0-6ubuntu1~16.04.11 [27.4 kB]
    googlecompute: Get:22 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 libatomic1 amd64 5.4.0-6ubuntu1~16.04.11 [8,896 B]
    googlecompute: Get:23 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 libasan2 amd64 5.4.0-6ubuntu1~16.04.11 [264 kB]
    googlecompute: Get:24 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 liblsan0 amd64 5.4.0-6ubuntu1~16.04.11 [105 kB]
    googlecompute: Get:25 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 libtsan0 amd64 5.4.0-6ubuntu1~16.04.11 [244 kB]
    googlecompute: Get:26 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 libubsan0 amd64 5.4.0-6ubuntu1~16.04.11 [95.4 kB]
    googlecompute: Get:27 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 libcilkrts5 amd64 5.4.0-6ubuntu1~16.04.11 [40.1 kB]
    googlecompute: Get:28 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 libmpx0 amd64 5.4.0-6ubuntu1~16.04.11 [9,748 B]
    googlecompute: Get:29 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 libquadmath0 amd64 5.4.0-6ubuntu1~16.04.11 [131 kB]
    googlecompute: Get:30 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 libgcc-5-dev amd64 5.4.0-6ubuntu1~16.04.11 [2,229 kB]
    googlecompute: Get:31 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 gcc-5 amd64 5.4.0-6ubuntu1~16.04.11 [8,417 kB]
    googlecompute: Get:32 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 gcc amd64 4:5.3.1-1ubuntu1 [5,244 B]
    googlecompute: Get:33 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 libstdc++-5-dev amd64 5.4.0-6ubuntu1~16.04.11 [1,426 kB]
    googlecompute: Get:34 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 g++-5 amd64 5.4.0-6ubuntu1~16.04.11 [8,310 kB]
    googlecompute: Get:35 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 g++ amd64 4:5.3.1-1ubuntu1 [1,504 B]
    googlecompute: Get:36 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 make amd64 4.1-6 [151 kB]
    googlecompute: Get:37 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 libdpkg-perl all 1.18.4ubuntu1.5 [195 kB]
    googlecompute: Get:38 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 dpkg-dev all 1.18.4ubuntu1.5 [584 kB]
    googlecompute: Get:39 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 build-essential amd64 12.1ubuntu2 [4,758 B]
    googlecompute: Get:40 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 libfakeroot amd64 1.20.2-1ubuntu1 [25.5 kB]
    googlecompute: Get:41 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 fakeroot amd64 1.20.2-1ubuntu1 [61.8 kB]
    googlecompute: Get:42 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 javascript-common all 11 [6,066 B]
    googlecompute: Get:43 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 libalgorithm-diff-perl all 1.19.03-1 [47.6 kB]
    googlecompute: Get:44 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 libalgorithm-diff-xs-perl amd64 0.04-4build1 [11.0 kB]
    googlecompute: Get:45 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 libalgorithm-merge-perl all 0.08-3 [12.0 kB]
    googlecompute: Get:46 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 libfile-fcntllock-perl amd64 0.22-3 [32.0 kB]
    googlecompute: Get:47 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 libgmpxx4ldbl amd64 2:6.1.0+dfsg-2 [8,948 B]
    googlecompute: Get:48 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 libgmp-dev amd64 2:6.1.0+dfsg-2 [314 kB]
    googlecompute: Get:49 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 libjs-jquery all 1.11.3+dfsg-4 [161 kB]
    googlecompute: Get:50 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 libtcl8.6 amd64 8.6.5+dfsg-2 [875 kB]
    googlecompute: Get:51 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 rubygems-integration all 1.10 [4,966 B]
    googlecompute: Get:52 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 ruby2.3 amd64 2.3.1-2~16.04.11 [41.0 kB]
    googlecompute: Get:53 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 ruby all 1:2.3.0+1 [5,530 B]
    googlecompute: Get:54 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 rake all 10.5.0-2 [48.2 kB]
    googlecompute: Get:55 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 ruby-did-you-mean all 1.0.0-2 [8,390 B]
    googlecompute: Get:56 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 ruby-minitest all 5.8.4-2 [36.6 kB]
    googlecompute: Get:57 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 ruby-net-telnet all 0.1.1-2 [12.6 kB]
    googlecompute: Get:58 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 ruby-power-assert all 0.2.7-1 [7,668 B]
    googlecompute: Get:59 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 ruby-test-unit all 3.1.7-2 [60.3 kB]
    googlecompute: Get:60 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 libruby2.3 amd64 2.3.1-2~16.04.11 [2,958 kB]
    googlecompute: Get:61 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 libtk8.6 amd64 8.6.5-1 [693 kB]
    googlecompute: Get:62 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/universe amd64 ruby2.3-tcltk amd64 2.3.1-2~16.04.11 [276 kB]
    googlecompute: Get:63 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/universe amd64 libtcltk-ruby all 1:2.3.0+1 [4,138 B]
    googlecompute: Get:64 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 manpages-dev all 4.04-2 [2,048 kB]
    googlecompute: Get:65 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 ruby2.3-doc all 2.3.1-2~16.04.11 [3,383 kB]
    googlecompute: Get:66 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/universe amd64 ri all 1:2.3.0+1 [4,274 B]
    googlecompute: Get:67 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/universe amd64 ruby-molinillo all 0.4.3-1 [12.1 kB]
    googlecompute: Get:68 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/universe amd64 ruby-net-http-persistent all 2.9.4-1 [15.9 kB]
    googlecompute: Get:69 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/universe amd64 ruby-thor all 0.19.1-2 [43.7 kB]
    googlecompute: Get:70 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/universe amd64 ruby-bundler all 1.11.2-1 [122 kB]
    googlecompute: Get:71 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates/main amd64 ruby2.3-dev amd64 2.3.1-2~16.04.11 [1,034 kB]
    googlecompute: Get:72 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 ruby-dev amd64 1:2.3.0+1 [4,408 B]
    googlecompute: Get:73 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/universe amd64 ruby-full all 1:2.3.0+1 [2,558 B]
    googlecompute: Get:74 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 unzip amd64 6.0-20ubuntu1 [158 kB]
    googlecompute: Get:75 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial/main amd64 zip amd64 3.0-11 [158 kB]
    googlecompute: debconf: unable to initialize frontend: Dialog
    googlecompute: debconf: (Dialog frontend will not work on a dumb terminal, an emacs shell buffer, or without a controlling terminal.)
    googlecompute: debconf: falling back to frontend: Readline
    googlecompute: debconf: unable to initialize frontend: Readline
    googlecompute: debconf: (This frontend requires a controlling tty.)
    googlecompute: debconf: falling back to frontend: Teletype
    googlecompute: dpkg-preconfigure: unable to re-open stdin:
    googlecompute: Fetched 53.0 MB in 14s (3,760 kB/s)
    googlecompute: Selecting previously unselected package fonts-lato.
    googlecompute: (Reading database ... 71060 files and directories currently installed.)
    googlecompute: Preparing to unpack .../fonts-lato_2.0-1_all.deb ...
    googlecompute: Unpacking fonts-lato (2.0-1) ...
    googlecompute: Selecting previously unselected package fonts-dejavu-core.
    googlecompute: Preparing to unpack .../fonts-dejavu-core_2.35-1_all.deb ...
    googlecompute: Unpacking fonts-dejavu-core (2.35-1) ...
    googlecompute: Selecting previously unselected package fontconfig-config.
    googlecompute: Preparing to unpack .../fontconfig-config_2.11.94-0ubuntu1.1_all.deb ...
    googlecompute: Unpacking fontconfig-config (2.11.94-0ubuntu1.1) ...
    googlecompute: Selecting previously unselected package libfontconfig1:amd64.
    googlecompute: Preparing to unpack .../libfontconfig1_2.11.94-0ubuntu1.1_amd64.deb ...
    googlecompute: Unpacking libfontconfig1:amd64 (2.11.94-0ubuntu1.1) ...
    googlecompute: Selecting previously unselected package libxrender1:amd64.
    googlecompute: Preparing to unpack .../libxrender1_1%3a0.9.9-0ubuntu1_amd64.deb ...
    googlecompute: Unpacking libxrender1:amd64 (1:0.9.9-0ubuntu1) ...
    googlecompute: Selecting previously unselected package libxft2:amd64.
    googlecompute: Preparing to unpack .../libxft2_2.3.2-1_amd64.deb ...
    googlecompute: Unpacking libxft2:amd64 (2.3.2-1) ...
    googlecompute: Selecting previously unselected package x11-common.
    googlecompute: Preparing to unpack .../x11-common_1%3a7.7+13ubuntu3.1_all.deb ...
    googlecompute: dpkg-query: no packages found matching nux-tools
    googlecompute: Unpacking x11-common (1:7.7+13ubuntu3.1) ...
    googlecompute: Selecting previously unselected package libxss1:amd64.
    googlecompute: Preparing to unpack .../libxss1_1%3a1.2.2-1_amd64.deb ...
    googlecompute: Unpacking libxss1:amd64 (1:1.2.2-1) ...
    googlecompute: Selecting previously unselected package libmpc3:amd64.
    googlecompute: Preparing to unpack .../libmpc3_1.0.3-1_amd64.deb ...
    googlecompute: Unpacking libmpc3:amd64 (1.0.3-1) ...
    googlecompute: Preparing to unpack .../gcc-5-base_5.4.0-6ubuntu1~16.04.11_amd64.deb ...
    googlecompute: Unpacking gcc-5-base:amd64 (5.4.0-6ubuntu1~16.04.11) over (5.4.0-6ubuntu1~16.04.10) ...
    googlecompute: Processing triggers for man-db (2.7.5-1) ...
    googlecompute: Processing triggers for libc-bin (2.23-0ubuntu10) ...
    googlecompute: Processing triggers for systemd (229-4ubuntu21.10) ...
    googlecompute: Processing triggers for ureadahead (0.100.0-19) ...
    googlecompute: Setting up gcc-5-base:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: (Reading database ... 71244 files and directories currently installed.)
    googlecompute: Preparing to unpack .../libstdc++6_5.4.0-6ubuntu1~16.04.11_amd64.deb ...
    googlecompute: Unpacking libstdc++6:amd64 (5.4.0-6ubuntu1~16.04.11) over (5.4.0-6ubuntu1~16.04.10) ...
    googlecompute: Processing triggers for libc-bin (2.23-0ubuntu10) ...
    googlecompute: Setting up libstdc++6:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Processing triggers for libc-bin (2.23-0ubuntu10) ...
    googlecompute: Selecting previously unselected package binutils.
    googlecompute: (Reading database ... 71244 files and directories currently installed.)
    googlecompute: Preparing to unpack .../binutils_2.26.1-1ubuntu1~16.04.7_amd64.deb ...
    googlecompute: Unpacking binutils (2.26.1-1ubuntu1~16.04.7) ...
    googlecompute: Selecting previously unselected package libc-dev-bin.
    googlecompute: Preparing to unpack .../libc-dev-bin_2.23-0ubuntu10_amd64.deb ...
    googlecompute: Unpacking libc-dev-bin (2.23-0ubuntu10) ...
    googlecompute: Selecting previously unselected package linux-libc-dev:amd64.
    googlecompute: Preparing to unpack .../linux-libc-dev_4.4.0-141.167_amd64.deb ...
    googlecompute: Unpacking linux-libc-dev:amd64 (4.4.0-141.167) ...
    googlecompute: Selecting previously unselected package libc6-dev:amd64.
    googlecompute: Preparing to unpack .../libc6-dev_2.23-0ubuntu10_amd64.deb ...
    googlecompute: Unpacking libc6-dev:amd64 (2.23-0ubuntu10) ...
    googlecompute: Selecting previously unselected package libisl15:amd64.
    googlecompute: Preparing to unpack .../libisl15_0.16.1-1_amd64.deb ...
    googlecompute: Unpacking libisl15:amd64 (0.16.1-1) ...
    googlecompute: Selecting previously unselected package cpp-5.
    googlecompute: Preparing to unpack .../cpp-5_5.4.0-6ubuntu1~16.04.11_amd64.deb ...
    googlecompute: Unpacking cpp-5 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Selecting previously unselected package cpp.
    googlecompute: Preparing to unpack .../cpp_4%3a5.3.1-1ubuntu1_amd64.deb ...
    googlecompute: Unpacking cpp (4:5.3.1-1ubuntu1) ...
    googlecompute: Selecting previously unselected package libcc1-0:amd64.
    googlecompute: Preparing to unpack .../libcc1-0_5.4.0-6ubuntu1~16.04.11_amd64.deb ...
    googlecompute: Unpacking libcc1-0:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Selecting previously unselected package libgomp1:amd64.
    googlecompute: Preparing to unpack .../libgomp1_5.4.0-6ubuntu1~16.04.11_amd64.deb ...
    googlecompute: Unpacking libgomp1:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Selecting previously unselected package libitm1:amd64.
    googlecompute: Preparing to unpack .../libitm1_5.4.0-6ubuntu1~16.04.11_amd64.deb ...
    googlecompute: Unpacking libitm1:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Selecting previously unselected package libatomic1:amd64.
    googlecompute: Preparing to unpack .../libatomic1_5.4.0-6ubuntu1~16.04.11_amd64.deb ...
    googlecompute: Unpacking libatomic1:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Selecting previously unselected package libasan2:amd64.
    googlecompute: Preparing to unpack .../libasan2_5.4.0-6ubuntu1~16.04.11_amd64.deb ...
    googlecompute: Unpacking libasan2:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Selecting previously unselected package liblsan0:amd64.
    googlecompute: Preparing to unpack .../liblsan0_5.4.0-6ubuntu1~16.04.11_amd64.deb ...
    googlecompute: Unpacking liblsan0:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Selecting previously unselected package libtsan0:amd64.
    googlecompute: Preparing to unpack .../libtsan0_5.4.0-6ubuntu1~16.04.11_amd64.deb ...
    googlecompute: Unpacking libtsan0:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Selecting previously unselected package libubsan0:amd64.
    googlecompute: Preparing to unpack .../libubsan0_5.4.0-6ubuntu1~16.04.11_amd64.deb ...
    googlecompute: Unpacking libubsan0:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Selecting previously unselected package libcilkrts5:amd64.
    googlecompute: Preparing to unpack .../libcilkrts5_5.4.0-6ubuntu1~16.04.11_amd64.deb ...
    googlecompute: Unpacking libcilkrts5:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Selecting previously unselected package libmpx0:amd64.
    googlecompute: Preparing to unpack .../libmpx0_5.4.0-6ubuntu1~16.04.11_amd64.deb ...
    googlecompute: Unpacking libmpx0:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Selecting previously unselected package libquadmath0:amd64.
    googlecompute: Preparing to unpack .../libquadmath0_5.4.0-6ubuntu1~16.04.11_amd64.deb ...
    googlecompute: Unpacking libquadmath0:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Selecting previously unselected package libgcc-5-dev:amd64.
    googlecompute: Preparing to unpack .../libgcc-5-dev_5.4.0-6ubuntu1~16.04.11_amd64.deb ...
    googlecompute: Unpacking libgcc-5-dev:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Selecting previously unselected package gcc-5.
    googlecompute: Preparing to unpack .../gcc-5_5.4.0-6ubuntu1~16.04.11_amd64.deb ...
    googlecompute: Unpacking gcc-5 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Selecting previously unselected package gcc.
    googlecompute: Preparing to unpack .../gcc_4%3a5.3.1-1ubuntu1_amd64.deb ...
    googlecompute: Unpacking gcc (4:5.3.1-1ubuntu1) ...
    googlecompute: Selecting previously unselected package libstdc++-5-dev:amd64.
    googlecompute: Preparing to unpack .../libstdc++-5-dev_5.4.0-6ubuntu1~16.04.11_amd64.deb ...
    googlecompute: Unpacking libstdc++-5-dev:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Selecting previously unselected package g++-5.
    googlecompute: Preparing to unpack .../g++-5_5.4.0-6ubuntu1~16.04.11_amd64.deb ...
    googlecompute: Unpacking g++-5 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Selecting previously unselected package g++.
    googlecompute: Preparing to unpack .../g++_4%3a5.3.1-1ubuntu1_amd64.deb ...
    googlecompute: Unpacking g++ (4:5.3.1-1ubuntu1) ...
    googlecompute: Selecting previously unselected package make.
    googlecompute: Preparing to unpack .../archives/make_4.1-6_amd64.deb ...
    googlecompute: Unpacking make (4.1-6) ...
    googlecompute: Selecting previously unselected package libdpkg-perl.
    googlecompute: Preparing to unpack .../libdpkg-perl_1.18.4ubuntu1.5_all.deb ...
    googlecompute: Unpacking libdpkg-perl (1.18.4ubuntu1.5) ...
    googlecompute: Selecting previously unselected package dpkg-dev.
    googlecompute: Preparing to unpack .../dpkg-dev_1.18.4ubuntu1.5_all.deb ...
    googlecompute: Unpacking dpkg-dev (1.18.4ubuntu1.5) ...
    googlecompute: Selecting previously unselected package build-essential.
    googlecompute: Preparing to unpack .../build-essential_12.1ubuntu2_amd64.deb ...
    googlecompute: Unpacking build-essential (12.1ubuntu2) ...
    googlecompute: Selecting previously unselected package libfakeroot:amd64.
    googlecompute: Preparing to unpack .../libfakeroot_1.20.2-1ubuntu1_amd64.deb ...
    googlecompute: Unpacking libfakeroot:amd64 (1.20.2-1ubuntu1) ...
    googlecompute: Selecting previously unselected package fakeroot.
    googlecompute: Preparing to unpack .../fakeroot_1.20.2-1ubuntu1_amd64.deb ...
    googlecompute: Unpacking fakeroot (1.20.2-1ubuntu1) ...
    googlecompute: Selecting previously unselected package javascript-common.
    googlecompute: Preparing to unpack .../javascript-common_11_all.deb ...
    googlecompute: Unpacking javascript-common (11) ...
    googlecompute: Selecting previously unselected package libalgorithm-diff-perl.
    googlecompute: Preparing to unpack .../libalgorithm-diff-perl_1.19.03-1_all.deb ...
    googlecompute: Unpacking libalgorithm-diff-perl (1.19.03-1) ...
    googlecompute: Selecting previously unselected package libalgorithm-diff-xs-perl.
    googlecompute: Preparing to unpack .../libalgorithm-diff-xs-perl_0.04-4build1_amd64.deb ...
    googlecompute: Unpacking libalgorithm-diff-xs-perl (0.04-4build1) ...
    googlecompute: Selecting previously unselected package libalgorithm-merge-perl.
    googlecompute: Preparing to unpack .../libalgorithm-merge-perl_0.08-3_all.deb ...
    googlecompute: Unpacking libalgorithm-merge-perl (0.08-3) ...
    googlecompute: Selecting previously unselected package libfile-fcntllock-perl.
    googlecompute: Preparing to unpack .../libfile-fcntllock-perl_0.22-3_amd64.deb ...
    googlecompute: Unpacking libfile-fcntllock-perl (0.22-3) ...
    googlecompute: Selecting previously unselected package libgmpxx4ldbl:amd64.
    googlecompute: Preparing to unpack .../libgmpxx4ldbl_2%3a6.1.0+dfsg-2_amd64.deb ...
    googlecompute: Unpacking libgmpxx4ldbl:amd64 (2:6.1.0+dfsg-2) ...
    googlecompute: Selecting previously unselected package libgmp-dev:amd64.
    googlecompute: Preparing to unpack .../libgmp-dev_2%3a6.1.0+dfsg-2_amd64.deb ...
    googlecompute: Unpacking libgmp-dev:amd64 (2:6.1.0+dfsg-2) ...
    googlecompute: Selecting previously unselected package libjs-jquery.
    googlecompute: Preparing to unpack .../libjs-jquery_1.11.3+dfsg-4_all.deb ...
    googlecompute: Unpacking libjs-jquery (1.11.3+dfsg-4) ...
    googlecompute: Selecting previously unselected package libtcl8.6:amd64.
    googlecompute: Preparing to unpack .../libtcl8.6_8.6.5+dfsg-2_amd64.deb ...
    googlecompute: Unpacking libtcl8.6:amd64 (8.6.5+dfsg-2) ...
    googlecompute: Selecting previously unselected package rubygems-integration.
    googlecompute: Preparing to unpack .../rubygems-integration_1.10_all.deb ...
    googlecompute: Unpacking rubygems-integration (1.10) ...
    googlecompute: Selecting previously unselected package ruby2.3.
    googlecompute: Preparing to unpack .../ruby2.3_2.3.1-2~16.04.11_amd64.deb ...
    googlecompute: Unpacking ruby2.3 (2.3.1-2~16.04.11) ...
    googlecompute: Selecting previously unselected package ruby.
    googlecompute: Preparing to unpack .../ruby_1%3a2.3.0+1_all.deb ...
    googlecompute: Unpacking ruby (1:2.3.0+1) ...
    googlecompute: Selecting previously unselected package rake.
    googlecompute: Preparing to unpack .../archives/rake_10.5.0-2_all.deb ...
    googlecompute: Unpacking rake (10.5.0-2) ...
    googlecompute: Selecting previously unselected package ruby-did-you-mean.
    googlecompute: Preparing to unpack .../ruby-did-you-mean_1.0.0-2_all.deb ...
    googlecompute: Unpacking ruby-did-you-mean (1.0.0-2) ...
    googlecompute: Selecting previously unselected package ruby-minitest.
    googlecompute: Preparing to unpack .../ruby-minitest_5.8.4-2_all.deb ...
    googlecompute: Unpacking ruby-minitest (5.8.4-2) ...
    googlecompute: Selecting previously unselected package ruby-net-telnet.
    googlecompute: Preparing to unpack .../ruby-net-telnet_0.1.1-2_all.deb ...
    googlecompute: Unpacking ruby-net-telnet (0.1.1-2) ...
    googlecompute: Selecting previously unselected package ruby-power-assert.
    googlecompute: Preparing to unpack .../ruby-power-assert_0.2.7-1_all.deb ...
    googlecompute: Unpacking ruby-power-assert (0.2.7-1) ...
    googlecompute: Selecting previously unselected package ruby-test-unit.
    googlecompute: Preparing to unpack .../ruby-test-unit_3.1.7-2_all.deb ...
    googlecompute: Unpacking ruby-test-unit (3.1.7-2) ...
    googlecompute: Selecting previously unselected package libruby2.3:amd64.
    googlecompute: Preparing to unpack .../libruby2.3_2.3.1-2~16.04.11_amd64.deb ...
    googlecompute: Unpacking libruby2.3:amd64 (2.3.1-2~16.04.11) ...
    googlecompute: Selecting previously unselected package libtk8.6:amd64.
    googlecompute: Preparing to unpack .../libtk8.6_8.6.5-1_amd64.deb ...
    googlecompute: Unpacking libtk8.6:amd64 (8.6.5-1) ...
    googlecompute: Selecting previously unselected package ruby2.3-tcltk.
    googlecompute: Preparing to unpack .../ruby2.3-tcltk_2.3.1-2~16.04.11_amd64.deb ...
    googlecompute: Unpacking ruby2.3-tcltk (2.3.1-2~16.04.11) ...
    googlecompute: Selecting previously unselected package libtcltk-ruby.
    googlecompute: Preparing to unpack .../libtcltk-ruby_1%3a2.3.0+1_all.deb ...
    googlecompute: Unpacking libtcltk-ruby (1:2.3.0+1) ...
    googlecompute: Selecting previously unselected package manpages-dev.
    googlecompute: Preparing to unpack .../manpages-dev_4.04-2_all.deb ...
    googlecompute: Unpacking manpages-dev (4.04-2) ...
    googlecompute: Selecting previously unselected package ruby2.3-doc.
    googlecompute: Preparing to unpack .../ruby2.3-doc_2.3.1-2~16.04.11_all.deb ...
    googlecompute: Unpacking ruby2.3-doc (2.3.1-2~16.04.11) ...
    googlecompute: Selecting previously unselected package ri.
    googlecompute: Preparing to unpack .../ri_1%3a2.3.0+1_all.deb ...
    googlecompute: Unpacking ri (1:2.3.0+1) ...
    googlecompute: Selecting previously unselected package ruby-molinillo.
    googlecompute: Preparing to unpack .../ruby-molinillo_0.4.3-1_all.deb ...
    googlecompute: Unpacking ruby-molinillo (0.4.3-1) ...
    googlecompute: Selecting previously unselected package ruby-net-http-persistent.
    googlecompute: Preparing to unpack .../ruby-net-http-persistent_2.9.4-1_all.deb ...
    googlecompute: Unpacking ruby-net-http-persistent (2.9.4-1) ...
    googlecompute: Selecting previously unselected package ruby-thor.
    googlecompute: Preparing to unpack .../ruby-thor_0.19.1-2_all.deb ...
    googlecompute: Unpacking ruby-thor (0.19.1-2) ...
    googlecompute: Selecting previously unselected package ruby-bundler.
    googlecompute: Preparing to unpack .../ruby-bundler_1.11.2-1_all.deb ...
    googlecompute: Unpacking ruby-bundler (1.11.2-1) ...
    googlecompute: Selecting previously unselected package ruby2.3-dev:amd64.
    googlecompute: Preparing to unpack .../ruby2.3-dev_2.3.1-2~16.04.11_amd64.deb ...
    googlecompute: Unpacking ruby2.3-dev:amd64 (2.3.1-2~16.04.11) ...
    googlecompute: Selecting previously unselected package ruby-dev:amd64.
    googlecompute: Preparing to unpack .../ruby-dev_1%3a2.3.0+1_amd64.deb ...
    googlecompute: Unpacking ruby-dev:amd64 (1:2.3.0+1) ...
    googlecompute: Selecting previously unselected package ruby-full.
    googlecompute: Preparing to unpack .../ruby-full_1%3a2.3.0+1_all.deb ...
    googlecompute: Unpacking ruby-full (1:2.3.0+1) ...
    googlecompute: Selecting previously unselected package unzip.
    googlecompute: Preparing to unpack .../unzip_6.0-20ubuntu1_amd64.deb ...
    googlecompute: Unpacking unzip (6.0-20ubuntu1) ...
    googlecompute: Selecting previously unselected package zip.
    googlecompute: Preparing to unpack .../archives/zip_3.0-11_amd64.deb ...
    googlecompute: Unpacking zip (3.0-11) ...
    googlecompute: Processing triggers for libc-bin (2.23-0ubuntu10) ...
    googlecompute: Processing triggers for man-db (2.7.5-1) ...
    googlecompute: Processing triggers for mime-support (3.59ubuntu1) ...
    googlecompute: Setting up fonts-lato (2.0-1) ...
    googlecompute: Setting up fonts-dejavu-core (2.35-1) ...
    googlecompute: Setting up fontconfig-config (2.11.94-0ubuntu1.1) ...
    googlecompute: Setting up libfontconfig1:amd64 (2.11.94-0ubuntu1.1) ...
    googlecompute: Setting up libxrender1:amd64 (1:0.9.9-0ubuntu1) ...
    googlecompute: Setting up libxft2:amd64 (2.3.2-1) ...
    googlecompute: Setting up x11-common (1:7.7+13ubuntu3.1) ...
    googlecompute: debconf: unable to initialize frontend: Dialog
    googlecompute: debconf: (Dialog frontend will not work on a dumb terminal, an emacs shell buffer, or without a controlling terminal.)
    googlecompute: debconf: falling back to frontend: Readline
    googlecompute: update-rc.d: warning: start and stop actions are no longer supported; falling back to defaults
    googlecompute: Setting up libxss1:amd64 (1:1.2.2-1) ...
    googlecompute: Setting up libmpc3:amd64 (1.0.3-1) ...
    googlecompute: Setting up binutils (2.26.1-1ubuntu1~16.04.7) ...
    googlecompute: Setting up libc-dev-bin (2.23-0ubuntu10) ...
    googlecompute: Setting up linux-libc-dev:amd64 (4.4.0-141.167) ...
    googlecompute: Setting up libc6-dev:amd64 (2.23-0ubuntu10) ...
    googlecompute: Setting up libisl15:amd64 (0.16.1-1) ...
    googlecompute: Setting up cpp-5 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Setting up cpp (4:5.3.1-1ubuntu1) ...
    googlecompute: Setting up libcc1-0:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Setting up libgomp1:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Setting up libitm1:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Setting up libatomic1:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Setting up libasan2:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Setting up liblsan0:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Setting up libtsan0:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Setting up libubsan0:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Setting up libcilkrts5:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Setting up libmpx0:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Setting up libquadmath0:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Setting up libgcc-5-dev:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Setting up gcc-5 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Setting up gcc (4:5.3.1-1ubuntu1) ...
    googlecompute: Setting up libstdc++-5-dev:amd64 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Setting up g++-5 (5.4.0-6ubuntu1~16.04.11) ...
    googlecompute: Setting up g++ (4:5.3.1-1ubuntu1) ...
    googlecompute: update-alternatives: using /usr/bin/g++ to provide /usr/bin/c++ (c++) in auto mode
    googlecompute: Setting up make (4.1-6) ...
    googlecompute: Setting up libdpkg-perl (1.18.4ubuntu1.5) ...
    googlecompute: Setting up dpkg-dev (1.18.4ubuntu1.5) ...
    googlecompute: Setting up build-essential (12.1ubuntu2) ...
    googlecompute: Setting up libfakeroot:amd64 (1.20.2-1ubuntu1) ...
    googlecompute: Setting up fakeroot (1.20.2-1ubuntu1) ...
    googlecompute: update-alternatives: using /usr/bin/fakeroot-sysv to provide /usr/bin/fakeroot (fakeroot) in auto mode
    googlecompute: Setting up javascript-common (11) ...
    googlecompute: Setting up libalgorithm-diff-perl (1.19.03-1) ...
    googlecompute: Setting up libalgorithm-diff-xs-perl (0.04-4build1) ...
    googlecompute: Setting up libalgorithm-merge-perl (0.08-3) ...
    googlecompute: Setting up libfile-fcntllock-perl (0.22-3) ...
    googlecompute: Setting up libgmpxx4ldbl:amd64 (2:6.1.0+dfsg-2) ...
    googlecompute: Setting up libgmp-dev:amd64 (2:6.1.0+dfsg-2) ...
    googlecompute: Setting up libjs-jquery (1.11.3+dfsg-4) ...
    googlecompute: Setting up libtcl8.6:amd64 (8.6.5+dfsg-2) ...
    googlecompute: Setting up rubygems-integration (1.10) ...
    googlecompute: Setting up ruby-did-you-mean (1.0.0-2) ...
    googlecompute: Setting up ruby-minitest (5.8.4-2) ...
    googlecompute: Setting up ruby-net-telnet (0.1.1-2) ...
    googlecompute: Setting up ruby-power-assert (0.2.7-1) ...
    googlecompute: Setting up ruby-test-unit (3.1.7-2) ...
    googlecompute: Setting up libtk8.6:amd64 (8.6.5-1) ...
    googlecompute: Setting up manpages-dev (4.04-2) ...
    googlecompute: Setting up ruby2.3-doc (2.3.1-2~16.04.11) ...
    googlecompute: Setting up unzip (6.0-20ubuntu1) ...
    googlecompute: Setting up zip (3.0-11) ...
    googlecompute: Setting up ruby2.3 (2.3.1-2~16.04.11) ...
    googlecompute: Setting up ruby (1:2.3.0+1) ...
    googlecompute: Setting up ri (1:2.3.0+1) ...
    googlecompute: Setting up ruby-molinillo (0.4.3-1) ...
    googlecompute: Setting up ruby-net-http-persistent (2.9.4-1) ...
    googlecompute: Setting up ruby-thor (0.19.1-2) ...
    googlecompute: Setting up ruby-bundler (1.11.2-1) ...
    googlecompute: Setting up rake (10.5.0-2) ...
    googlecompute: Setting up libruby2.3:amd64 (2.3.1-2~16.04.11) ...
    googlecompute: Setting up ruby2.3-tcltk (2.3.1-2~16.04.11) ...
    googlecompute: Setting up libtcltk-ruby (1:2.3.0+1) ...
    googlecompute: Setting up ruby2.3-dev:amd64 (2.3.1-2~16.04.11) ...
    googlecompute: Setting up ruby-dev:amd64 (1:2.3.0+1) ...
    googlecompute: Setting up ruby-full (1:2.3.0+1) ...
    googlecompute: Processing triggers for libc-bin (2.23-0ubuntu10) ...
    googlecompute: Processing triggers for systemd (229-4ubuntu21.10) ...
    googlecompute: Processing triggers for ureadahead (0.100.0-19) ...
==> googlecompute: Provisioning with shell script: scripts/install_mongodb.sh
    googlecompute: Executing: /tmp/tmp.63z272OBbK/gpg.1.sh --keyserver
    googlecompute: hkp://keyserver.ubuntu.com:80
    googlecompute: --recv
    googlecompute: EA312927
    googlecompute: gpg: requesting key EA312927 from hkp server keyserver.ubuntu.com
    googlecompute: gpg: key EA312927: public key "MongoDB 3.2 Release Signing Key <packaging@mongodb.com>" imported
    googlecompute: gpg: key EA312927: public key "Totally Legit Signing Key <mallory@example.org>" imported
    googlecompute: gpg: Total number processed: 2
    googlecompute: gpg:               imported: 2  (RSA: 2)
    googlecompute:
    googlecompute: WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
    googlecompute:
    googlecompute: Hit:1 http://security.ubuntu.com/ubuntu xenial-security InRelease
    googlecompute: Ign:2 http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 InRelease
    googlecompute: Get:3 http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 Release [3,462 B]
    googlecompute: Get:4 http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 Release.gpg [801 B]
    googlecompute: Hit:5 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial InRelease
    googlecompute: Hit:6 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-updates InRelease
    googlecompute: Hit:7 http://archive.canonical.com/ubuntu xenial InRelease
    googlecompute: Hit:8 http://europe-north1-b.gce.clouds.archive.ubuntu.com/ubuntu xenial-backports InRelease
    googlecompute: Get:9 http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2/multiverse amd64 Packages [11.2 kB]
    googlecompute: Fetched 15.5 kB in 0s (24.4 kB/s)
    googlecompute: Reading package lists...
    googlecompute: Building dependency tree...
    googlecompute: Reading state information...
    googlecompute: 24 packages can be upgraded. Run 'apt list --upgradable' to see them.
    googlecompute:
    googlecompute: WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
    googlecompute:
    googlecompute: Reading package lists...
    googlecompute: Building dependency tree...
    googlecompute: Reading state information...
    googlecompute: The following additional packages will be installed:
    googlecompute:   mongodb-org-mongos mongodb-org-server mongodb-org-shell mongodb-org-tools
    googlecompute: The following NEW packages will be installed:
    googlecompute:   mongodb-org mongodb-org-mongos mongodb-org-server mongodb-org-shell
    googlecompute:   mongodb-org-tools
    googlecompute: 0 upgraded, 5 newly installed, 0 to remove and 24 not upgraded.
    googlecompute: Need to get 51.8 MB of archives.
    googlecompute: After this operation, 215 MB of additional disk space will be used.
    googlecompute: Get:1 http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2/multiverse amd64 mongodb-org-shell amd64 3.2.22 [5,278 kB]
    googlecompute: Get:2 http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2/multiverse amd64 mongodb-org-server amd64 3.2.22 [10.0 MB]
    googlecompute: Get:3 http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2/multiverse amd64 mongodb-org-mongos amd64 3.2.22 [4,679 kB]
    googlecompute: Get:4 http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2/multiverse amd64 mongodb-org-tools amd64 3.2.22 [31.8 MB]
    googlecompute: Get:5 http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2/multiverse amd64 mongodb-org amd64 3.2.22 [3,564 B]
    googlecompute: debconf: unable to initialize frontend: Dialog
    googlecompute: debconf: (Dialog frontend will not work on a dumb terminal, an emacs shell buffer, or without a controlling terminal.)
    googlecompute: debconf: falling back to frontend: Readline
    googlecompute: debconf: unable to initialize frontend: Readline
    googlecompute: debconf: (This frontend requires a controlling tty.)
    googlecompute: debconf: falling back to frontend: Teletype
    googlecompute: dpkg-preconfigure: unable to re-open stdin:
    googlecompute: Fetched 51.8 MB in 5s (9,451 kB/s)
    googlecompute: Selecting previously unselected package mongodb-org-shell.
    googlecompute: (Reading database ... 93964 files and directories currently installed.)
    googlecompute: Preparing to unpack .../mongodb-org-shell_3.2.22_amd64.deb ...
    googlecompute: Unpacking mongodb-org-shell (3.2.22) ...
    googlecompute: Selecting previously unselected package mongodb-org-server.
    googlecompute: Preparing to unpack .../mongodb-org-server_3.2.22_amd64.deb ...
    googlecompute: Unpacking mongodb-org-server (3.2.22) ...
    googlecompute: Selecting previously unselected package mongodb-org-mongos.
    googlecompute: Preparing to unpack .../mongodb-org-mongos_3.2.22_amd64.deb ...
    googlecompute: Unpacking mongodb-org-mongos (3.2.22) ...
    googlecompute: Selecting previously unselected package mongodb-org-tools.
    googlecompute: Preparing to unpack .../mongodb-org-tools_3.2.22_amd64.deb ...
    googlecompute: Unpacking mongodb-org-tools (3.2.22) ...
    googlecompute: Selecting previously unselected package mongodb-org.
    googlecompute: Preparing to unpack .../mongodb-org_3.2.22_amd64.deb ...
    googlecompute: Unpacking mongodb-org (3.2.22) ...
    googlecompute: Processing triggers for man-db (2.7.5-1) ...
    googlecompute: Setting up mongodb-org-shell (3.2.22) ...
    googlecompute: Setting up mongodb-org-server (3.2.22) ...
    googlecompute: Adding system user `mongodb' (UID 113) ...
    googlecompute: Adding new user `mongodb' (UID 113) with group `nogroup' ...
    googlecompute: Not creating home directory `/home/mongodb'.
    googlecompute: Adding group `mongodb' (GID 117) ...
    googlecompute: Done.
    googlecompute: Adding user `mongodb' to group `mongodb' ...
    googlecompute: Adding user mongodb to group mongodb
    googlecompute: Done.
    googlecompute: Setting up mongodb-org-mongos (3.2.22) ...
    googlecompute: Setting up mongodb-org-tools (3.2.22) ...
    googlecompute: Setting up mongodb-org (3.2.22) ...
    googlecompute: Created symlink from /etc/systemd/system/multi-user.target.wants/mongod.service to /lib/systemd/system/mongod.service.
==> googlecompute: Deleting instance...
    googlecompute: Instance has been deleted!
==> googlecompute: Creating image...
==> googlecompute: Deleting disk...
    googlecompute: Disk has been deleted!
Build 'googlecompute' finished.

==> Builds finished. The artifacts of successful builds are:
--> googlecompute: A disk image was created: reddit-base-1547198228

```

</p></details>

### Задание со *  

- Добавлен шаблон полного образа — immutable.json  
- Добавлен скрипт для установки всех зависимостей в образ — backed.sh  
- Добавлен systemd unit для puma  
- Добавлен скрипт для создания вм на базе полного образа — create-reddit-vm.sh  

</p></details>

## ДЗ №6  

<details><summary>Спойлер</summary><p>

- установлен terraform и tflint  
- создан инстанс с помощью tf
- добавлен ssh-ключ
- добавлен тег файрволла
- добавлен скрипт деплоя
- переразвёрнут инстанс с деплоем приложения
- добавлены входные переменные
- переменные определены в terraform.tfvars
- удалён и создан инстанс

<details><summary>Создание инстанса</summary><p>

```bash

>terraform apply -auto-approve=true
google_compute_firewall.firewall_puma: Creating...
  allow.#:                  "" => "1"
  allow.931060522.ports.#:  "" => "1"
  allow.931060522.ports.0:  "" => "9292"
  allow.931060522.protocol: "" => "tcp"
  creation_timestamp:       "" => "<computed>"
  destination_ranges.#:     "" => "<computed>"
  direction:                "" => "<computed>"
  name:                     "" => "allow-puma-default"
  network:                  "" => "default"
  priority:                 "" => "1000"
  project:                  "" => "<computed>"
  self_link:                "" => "<computed>"
  source_ranges.#:          "" => "1"
  source_ranges.1080289494: "" => "0.0.0.0/0"
  target_tags.#:            "" => "1"
  target_tags.1799682348:   "" => "reddit-app"
google_compute_instance.app: Creating...
  boot_disk.#:                                         "" => "1"
  boot_disk.0.auto_delete:                             "" => "true"
  boot_disk.0.device_name:                             "" => "<computed>"
  boot_disk.0.disk_encryption_key_sha256:              "" => "<computed>"
  boot_disk.0.initialize_params.#:                     "" => "1"
  boot_disk.0.initialize_params.0.image:               "" => "reddit-base"
  boot_disk.0.initialize_params.0.size:                "" => "<computed>"
  boot_disk.0.initialize_params.0.type:                "" => "<computed>"
  can_ip_forward:                                      "" => "false"
  cpu_platform:                                        "" => "<computed>"
  create_timeout:                                      "" => "4"
  deletion_protection:                                 "" => "false"
  guest_accelerator.#:                                 "" => "<computed>"
  instance_id:                                         "" => "<computed>"
  label_fingerprint:                                   "" => "<computed>"
  machine_type:                                        "" => "g1-small"
  metadata.%:                                          "" => "1"
  metadata.ssh-keys:                                   "" => "appuser:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzAKLEMEY20W7voyjl6OAPfDmpc95FLpX8SV4vP/opd support@localhost\n"
  metadata_fingerprint:                                "" => "<computed>"
  name:                                                "" => "reddit-app"
  network_interface.#:                                 "" => "1"
  network_interface.0.access_config.#:                 "" => "1"
  network_interface.0.access_config.0.assigned_nat_ip: "" => "<computed>"
  network_interface.0.access_config.0.nat_ip:          "" => "<computed>"
  network_interface.0.access_config.0.network_tier:    "" => "<computed>"
  network_interface.0.address:                         "" => "<computed>"
  network_interface.0.name:                            "" => "<computed>"
  network_interface.0.network:                         "" => "default"
  network_interface.0.network_ip:                      "" => "<computed>"
  network_interface.0.subnetwork_project:              "" => "<computed>"
  project:                                             "" => "<computed>"
  scheduling.#:                                        "" => "<computed>"
  self_link:                                           "" => "<computed>"
  tags.#:                                              "" => "1"
  tags.1799682348:                                     "" => "reddit-app"
  tags_fingerprint:                                    "" => "<computed>"
  zone:                                                "" => "europe-north1-b"
google_compute_firewall.firewall_puma: Still creating... (10s elapsed)
google_compute_instance.app: Still creating... (10s elapsed)
google_compute_firewall.firewall_puma: Still creating... (20s elapsed)
google_compute_instance.app: Still creating... (20s elapsed)
google_compute_firewall.firewall_puma: Creation complete after 23s (ID: allow-puma-default)
google_compute_instance.app: Provisioning with 'file'...
google_compute_instance.app: Still creating... (30s elapsed)
google_compute_instance.app: Still creating... (40s elapsed)
google_compute_instance.app: Still creating... (50s elapsed)
google_compute_instance.app: Provisioning with 'remote-exec'...
google_compute_instance.app (remote-exec): Connecting to remote host via SSH...
google_compute_instance.app (remote-exec):   Host: 35.228.131.18
google_compute_instance.app (remote-exec):   User: appuser
google_compute_instance.app (remote-exec):   Password: false
google_compute_instance.app (remote-exec):   Private key: true
google_compute_instance.app (remote-exec):   SSH Agent: false
google_compute_instance.app (remote-exec):   Checking Host Key: false
google_compute_instance.app (remote-exec): Connected!
google_compute_instance.app (remote-exec): Cloning into '/home/appuser/reddit'...
google_compute_instance.app (remote-exec): remote: Enumerating objects: 335, done.
google_compute_instance.app (remote-exec): Receiving objects:   0% (1/335)
...
google_compute_instance.app (remote-exec): Resolving deltas: 100% (185/185), done.
google_compute_instance.app (remote-exec): Checking connectivity... done.
google_compute_instance.app: Still creating... (1m0s elapsed)
google_compute_instance.app (remote-exec): Warning: the running version of Bundler is older than the version that created the lockfile. We suggest you upgrade to the latest version of Bundler by running `gem install bundler`.                                                                                                                                                                                               
google_compute_instance.app (remote-exec): 
google_compute_instance.app (remote-exec): Fetching gem metadata from https://rubygems.org/.
google_compute_instance.app (remote-exec): .
google_compute_instance.app (remote-exec): .
google_compute_instance.app (remote-exec): .
google_compute_instance.app (remote-exec): .
google_compute_instance.app (remote-exec): .
google_compute_instance.app (remote-exec): .
google_compute_instance.app (remote-exec): .
google_compute_instance.app (remote-exec): .
google_compute_instance.app (remote-exec): .
google_compute_instance.app (remote-exec): Fetching version metadata from https://rubygems.org/.
google_compute_instance.app (remote-exec): .
google_compute_instance.app (remote-exec): Installing rake 12.0.0
google_compute_instance.app (remote-exec): Installing net-ssh 4.1.0
google_compute_instance.app (remote-exec): Installing bcrypt 3.1.11 with native extensions
google_compute_instance.app: Still creating... (1m10s elapsed)
google_compute_instance.app (remote-exec): Installing bson 4.2.2 with native extensions
google_compute_instance.app (remote-exec): Installing bson_ext 1.5.1 with native extensions
google_compute_instance.app (remote-exec): Installing i18n 0.8.6
google_compute_instance.app (remote-exec): Installing puma 3.10.0 with native extensions
google_compute_instance.app (remote-exec): Installing temple 0.8.0
google_compute_instance.app (remote-exec): Installing tilt 2.0.8
google_compute_instance.app (remote-exec): Installing json 2.1.0 with native extensions
google_compute_instance.app: Still creating... (1m20s elapsed)
google_compute_instance.app (remote-exec): Installing mustermann 1.0.2
google_compute_instance.app (remote-exec): Installing rack 2.0.5
google_compute_instance.app (remote-exec): Using bundler 1.11.2
google_compute_instance.app (remote-exec): Installing net-scp 1.2.1
google_compute_instance.app (remote-exec): Installing mongo 2.4.3
google_compute_instance.app (remote-exec): Installing haml 5.0.2
google_compute_instance.app (remote-exec): Installing rack-protection 2.0.2
google_compute_instance.app (remote-exec): Installing sshkit 1.14.0
google_compute_instance.app (remote-exec): Installing sinatra 2.0.2
google_compute_instance.app (remote-exec): Installing airbrussh 1.3.0
google_compute_instance.app (remote-exec): Installing capistrano 3.9.0
google_compute_instance.app (remote-exec): Installing capistrano-bundler 1.2.0
google_compute_instance.app (remote-exec): Installing capistrano-rvm 0.1.2
google_compute_instance.app (remote-exec): Installing capistrano3-puma 3.1.1
google_compute_instance.app (remote-exec): Bundle complete! 11 Gemfile dependencies, 24 gems now installed.
google_compute_instance.app (remote-exec): Use `bundle show [gemname]` to see where a bundled gem is installed.
google_compute_instance.app (remote-exec): Post-install message from capistrano3-puma:

google_compute_instance.app (remote-exec):     All plugins need to be explicitly installed with install_plugin.
google_compute_instance.app (remote-exec):     Please see README.md

google_compute_instance.app (remote-exec): Created symlink from /etc/systemd/system/multi-user.target.wants/puma.service to /etc/systemd/system/puma.service.
google_compute_instance.app: Creation complete after 1m24s (ID: reddit-app)

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

app_external_ip = 35.228.131.18

```

</p></details>

### Самостоятельные задания  

- Определена input переменная для приватного ключа, использующегося в определении подключения для провижинеров (connection)  
- Определена input переменная для задания зоны в ресурсе "google_compute_instance" "app". У нее должно быть значение по умолчанию  
- Отформатированы все конфигурационные файлы через terraform fmt  
- Добавлен файл terraform.tfvars.example в котором указаны переменные для образца

### Задание со * №1  

- Опишите в коде терраформа добавление ssh ключа пользователя appuser1 в метаданные проекта  

```bash

resource "google_compute_project_metadata_item" "default" {
  key   = "ssh-keys"
  value = "appuser1:${file(var.public_key_path)}"
}

```

- Выполните terraform apply и проверьте результат (публичный ключ можно брать пользователя appuser)  

<details><summary>Обновление метаданных</summary><p>

```bash

>terraform apply -auto-approve=true
google_compute_firewall.firewall_puma: Refreshing state... (ID: allow-puma-default)
google_compute_instance.app: Refreshing state... (ID: reddit-app)
google_compute_project_metadata_item.default: Creating...
  key:     "" => "ssh-keys"
  project: "" => "<computed>"
  value:   "" => "appuser1:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzAKLEMEY20W7voyjl6OAPfDmpc95FLpX8SV4vP/opd support@localhost\n"
google_compute_project_metadata_item.default: Still creating... (10s elapsed)
google_compute_project_metadata_item.default: Creation complete after 14s (ID: ssh-keys)

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

app_external_ip = 35.228.131.18

```

![SSHKeys](https://i.imgur.com/vIX7XpW.png)

</p></details>



<details><summary>Проверка результата</summary><p>

```bash

>ssh appuser@35.228.131.18
Welcome to Ubuntu 16.04.5 LTS (GNU/Linux 4.15.0-1025-gcp x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud

9 packages can be updated.
0 updates are security updates.

New release '18.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


*** System restart required ***
appuser@reddit-app:~$ exit
logout
Connection to 35.228.131.18 closed.

>ssh appuser1@35.228.131.18
Welcome to Ubuntu 16.04.5 LTS (GNU/Linux 4.15.0-1025-gcp x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud

9 packages can be updated.
0 updates are security updates.

New release '18.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


*** System restart required ***
appuser1@reddit-app:~$ 
logout
Connection to 35.228.131.18 closed.

```

</p></details>

- Опишите в коде терраформа добавление ssh ключей нескольких пользователей в метаданные проекта, например appuser1, appuser2 и т.д.). Выполните terraform apply и проверьте результат

```bash

resource "google_compute_project_metadata_item" "default" {
  key   = "ssh-keys"
  value = "appuser1:${file(var.public_key_path)}\nappuser2:${file(var.public_key_path)}\nappuser3:${file(var.public_key_path)}\nappuser4:${file(var.public_key_path)}"
}

```

<details><summary>Обновление метаданных</summary><p>

```bash 

>terraform apply -auto-approve=true
google_compute_firewall.firewall_puma: Refreshing state... (ID: allow-puma-default)
google_compute_project_metadata_item.default: Refreshing state... (ID: ssh-keys)
google_compute_instance.app: Refreshing state... (ID: reddit-app)
google_compute_project_metadata_item.default: Modifying... (ID: ssh-keys)
  value: "appuser1:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzAKLEMEY20W7voyjl6OAPfDmpc95FLpX8SV4vP/opd support@localhost\n" => "appuser1:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzAKLEMEY20W7voyjl6OAPfDmpc95FLpX8SV4vP/opd support@localhost\n\nappuser2:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzAKLEMEY20W7voyjl6OAPfDmpc95FLpX8SV4vP/opd support@localhost\n\nappuser3:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzAKLEMEY20W7voyjl6OAPfDmpc95FLpX8SV4vP/opd support@localhost\n\nappuser4:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzAKLEMEY20W7voyjl6OAPfDmpc95FLpX8SV4vP/opd support@localhost\n"
google_compute_project_metadata_item.default: Still modifying... (ID: ssh-keys, 10s elapsed)
google_compute_project_metadata_item.default: Modifications complete after 15s (ID: ssh-keys)

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

Outputs:

app_external_ip = 35.228.131.18

```

![SSHKeys](https://i.imgur.com/XR3XzLA.png)

</p></details>

<details><summary>Проверка результата</summary><p>

```bash

>ssh appuser@35.228.131.18 
appuser@reddit-app:~$ exit
logout
Connection to 35.228.131.18 closed.

>ssh appuser1@35.228.131.18
appuser1@reddit-app:~$ exit
logout
Connection to 35.228.131.18 closed.

>ssh appuser2@35.228.131.18
appuser2@reddit-app:~$ exit
logout
Connection to 35.228.131.18 closed.

>ssh appuser3@35.228.131.18
appuser3@reddit-app:~$ exit
logout
Connection to 35.228.131.18 closed.

>ssh appuser4@35.228.131.18
appuser4@reddit-app:~$ ls ../
appuser  appuser1  appuser2  appuser3  appuser4  ubuntu  utrgroup
appuser4@reddit-app:~$ exit
logout
Connection to 35.228.131.18 closed.

```

</p></details>

- Добавьте в веб интерфейсе ssh ключ пользователю appuser_web в метаданные проекта. Выполните terraform apply и проверьте результат;

<details><summary>Обновление метаданных</summary><p>

```bash

>terraform apply -auto-approve=true
google_compute_instance.app: Refreshing state... (ID: reddit-app)
google_compute_firewall.firewall_puma: Refreshing state... (ID: allow-puma-default)
google_compute_project_metadata_item.default: Refreshing state... (ID: ssh-keys)
google_compute_project_metadata_item.default: Modifying... (ID: ssh-keys)
  value: "appuser1:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzAKLEMEY20W7voyjl6OAPfDmpc95FLpX8SV4vP/opd support@localhost\nappuser2:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzAKLEMEY20W7voyjl6OAPfDmpc95FLpX8SV4vP/opd support@localhost\nappuser3:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzAKLEMEY20W7voyjl6OAPfDmpc95FLpX8SV4vP/opd support@localhost\nappuser4:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzAKLEMEY20W7voyjl6OAPfDmpc95FLpX8SV4vP/opd support@localhost\nappuser_web:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzAKLEMEY20W7voyjl6OAPfDmpc95FLpX8SV4vP/opd appuser_web@localhost" => "appuser1:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzAKLEMEY20W7voyjl6OAPfDmpc95FLpX8SV4vP/opd support@localhost\n\nappuser2:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzAKLEMEY20W7voyjl6OAPfDmpc95FLpX8SV4vP/opd support@localhost\n\nappuser3:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzAKLEMEY20W7voyjl6OAPfDmpc95FLpX8SV4vP/opd support@localhost\n\nappuser4:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzAKLEMEY20W7voyjl6OAPfDmpc95FLpX8SV4vP/opd support@localhost\n"
google_compute_project_metadata_item.default: Still modifying... (ID: ssh-keys, 10s elapsed)
google_compute_project_metadata_item.default: Modifications complete after 11s (ID: ssh-keys)

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

Outputs:

app_external_ip = 35.228.131.18

```

![SSHKeys](https://i.imgur.com/XR3XzLA.png)

</p></details>

<details><summary>Проверка результата</summary><p>

```bash

>ssh appuser_web@35.228.131.18
appuser_web@35.228.131.18: Permission denied (publickey).

```

</p></details>

- Какие проблемы вы обнаружили?  

Ключи из кода терраформа добавляются в метаданные проекта и перезаписывают существующие ключи.  
Поэтому был удалён ключ добавленный через web-интерфейс.  

### Задание со * №2  

- Создайте файл lb.tf и опишите в нем в коде terraform создание HTTP балансировщика, направляющего трафик на наше развернутое приложение на инстансе reddit-app. Проверьте доступность приложения по адресу балансировщика. Добавьте в output переменные адрес балансировщика.

Добавлено.  

- Добавьте в код еще один terraform ресурс для нового инстанса приложения, например reddit-app2, добавьте его в балансировщик и проверьте, что при остановке на одном из инстансов приложения (например systemctl stop puma), приложение продолжает быть доступным по адресу балансировщика;  

Приложение доступно.  

Добавьте в output переменные адрес второго инстанса;  

Добавлено.  

Какие проблемы вы видите в такой конфигурации приложения?

    1. Нет синхронизации баз данных.  
    2. Нет синхронизации сессий пользователей.  


- Удалите описание reddit-app2 и попробуйте подход с заданием количества инстансов через параметр ресурса count. Переменная count должна задаваться в параметрах и по умолчанию равна 1.

Добавлено.

</p></details>

## ДЗ №7  

<details><summary>Спойлер</summary><p>

- Добавлено правило файрволла для ssh  
- Добавлен IP для инстанса с приложением  
- Добавлены шаблоны packer для билда VM: db.json и app.json  
- Добавлены шаблоны terraform для развёртывания VM: db.tf и app.tf  
- Добавлены модули terraform на основе шаблонов db.tf, app.tf и vpc.tf

<details><summary>Загруженные модули</summary><p>

```bash

>terraform get
- module.app
  Getting source "modules/app"
- module.db
  Getting source "modules/db"
- module.vpc
  Getting source "modules/vpc"


>tree .terraform/modules/
.terraform/modules/
├── 154ec150a1e158c95e9ac16db7935dea -> ~/YogSottot_infra/terraform/modules/vpc
├── a9aa53bac9b6b12943ed0fbaf231f446 -> ~/YogSottot_infra/terraform/modules/db
├── d52edfb6d63db99f07875dd8b80211c3 -> ~/YogSottot_infra/terraform/modules/app
└── modules.json

3 directories, 1 file

```

</p></details>

### Самостоятельные задание №1  

1. Проверил работу параметризованного модуля vpc. Ввёл в source_ranges чужой IP адрес, применил правило и проверил отсутствие соединения к обоим хостам по ssh. Проконтролировал, как изменилось правило файрвола в веб консоли.  

<details><summary>Применение правила</summary><p>

```bash

>terraform apply -auto-approve=true
google_compute_firewall.firewall_puma: Refreshing state... (ID: allow-puma-default)
google_compute_project_metadata_item.default: Refreshing state... (ID: ssh-keys)
google_compute_firewall.firewall_ssh: Refreshing state... (ID: default-allow-ssh)
google_compute_instance.db: Refreshing state... (ID: reddit-db-01)
google_compute_firewall.firewall_mongo: Refreshing state... (ID: allow-mongo-default)
google_compute_address.app_ip: Refreshing state... (ID: infra-226118/europe-north1/reddit-app-ip)
google_compute_instance.app: Refreshing state... (ID: reddit-app-01)
module.vpc.google_compute_firewall.firewall_ssh: Modifying... (ID: default-allow-ssh)
  source_ranges.1080289494: "0.0.0.0/0" => ""
  source_ranges.4195971197: "" => "1.2.3.4/32"
module.vpc.google_compute_firewall.firewall_ssh: Still modifying... (ID: default-allow-ssh, 10s elapsed)
module.vpc.google_compute_firewall.firewall_ssh: Modifications complete after 11s (ID: default-allow-ssh)

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

Outputs:

apps_external_ip = [
    35.228.152.71
]
db_external_ip = [
    35.228.131.18
]

```

```bash

>ssh appuser@35.228.152.71
^C

```

![firelwall](https://i.imgur.com/uW6tVcs.png)

</p></details>


2. Ввёл в source_ranges свой IP адрес, применил правило и проверил наличие соединения к обоим хостам по ssh.

<details><summary>Результат проверки</summary><p>

```bash

>terraform apply -auto-approve=true
google_compute_address.app_ip: Refreshing state... (ID: infra-226118/europe-north1/reddit-app-ip)
google_compute_firewall.firewall_ssh: Refreshing state... (ID: default-allow-ssh)
google_compute_firewall.firewall_puma: Refreshing state... (ID: allow-puma-default)
google_compute_instance.db: Refreshing state... (ID: reddit-db-01)
google_compute_firewall.firewall_mongo: Refreshing state... (ID: allow-mongo-default)
google_compute_project_metadata_item.default: Refreshing state... (ID: ssh-keys)
google_compute_instance.app: Refreshing state... (ID: reddit-app-01)
module.vpc.google_compute_firewall.firewall_ssh: Modifying... (ID: default-allow-ssh)
  source_ranges.340670481:  "" => "197.15.35.183/32"
  source_ranges.4195971197: "1.2.3.4/32" => ""
module.vpc.google_compute_firewall.firewall_ssh: Still modifying... (ID: default-allow-ssh, 10s elapsed)
module.vpc.google_compute_firewall.firewall_ssh: Modifications complete after 12s (ID: default-allow-ssh)

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

Outputs:

apps_external_ip = [
    35.228.152.71
]
db_external_ip = [
    35.228.131.18
]

```

```bash

>ssh appuser@35.228.152.71
The authenticity of host '35.228.152.71 (35.228.152.71)' can't be established.
ECDSA key fingerprint is SHA256:LW9YC0c5uTW71K3uGTi6ZsJGnx423tvXuVKnrVRaO2Q.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '35.228.152.71' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 16.04.5 LTS (GNU/Linux 4.15.0-1026-gcp x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud

9 packages can be updated.
9 updates are security updates.

New release '18.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

```

</p></details>

3. Вернул 0.0.0.0/0 в source_ranges.

<details><summary>Результат применения</summary><p>

```bash

>terraform apply -auto-approve=true
google_compute_firewall.firewall_puma: Refreshing state... (ID: allow-puma-default)
google_compute_address.app_ip: Refreshing state... (ID: infra-226118/europe-north1/reddit-app-ip)
google_compute_firewall.firewall_mongo: Refreshing state... (ID: allow-mongo-default)
google_compute_instance.db: Refreshing state... (ID: reddit-db-01)
google_compute_firewall.firewall_ssh: Refreshing state... (ID: default-allow-ssh)
google_compute_project_metadata_item.default: Refreshing state... (ID: ssh-keys)
google_compute_instance.app: Refreshing state... (ID: reddit-app-01)
module.vpc.google_compute_firewall.firewall_ssh: Modifying... (ID: default-allow-ssh)
  source_ranges.1080289494: "" => "0.0.0.0/0"
  source_ranges.340670481:  "197.15.35.183/32" => ""
module.vpc.google_compute_firewall.firewall_ssh: Still modifying... (ID: default-allow-ssh, 10s elapsed)
module.vpc.google_compute_firewall.firewall_ssh: Modifications complete after 12s (ID: default-allow-ssh)

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

Outputs:

apps_external_ip = [
    35.228.152.71
]
db_external_ip = [
    35.228.131.18
]

```

![firelwall](https://i.imgur.com/ADZCm4S.png)

</p></details>

### Самостоятельные задания №2  

1. Удалил из папки terraform файлы main.tf, outputs.tf, terraform.tfvars, variables.tf, так как они теперь перенесены в stage и prod
2. Параметризировал конфигурацию модулей насколько считаю нужным:  
   Добавил настройки количества и имён инстансов через переменные.  
3. Отформатировал конфигурационные файлы, используя команду terraform fmt

### Работа с реестром модулей  

- Добавил модуль SweetOps/storage-bucket/google  
- Создал бакет  

  <details><summary>Результат применения</summary><p>

  ![bucket](https://i.imgur.com/vFERN3g.png)

  </p></details>

### Задание со * №1  

1. Настроил хранение стейт файла в удаленном бекенде (remote backends) для окружений stage и prod, используя Google Cloud Storage в качестве бекенда. Описание бекенда вынес в отдельный файл backend.tf  

    <details><summary>Подключение бакета</summary><p>

    ```bash

    >terraform init
    Initializing modules...
      - module.app
      - module.db
      - module.vpc

    Initializing the backend...

    Successfully configured the backend "gcs"! Terraform will automatically
    use this backend unless the backend configuration changes.

    Initializing provider plugins...

    Terraform has been successfully initialized!

    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.

    If  you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.

    ```

    </p></details>

2. Перенёс конфигурационные файлы Terraform в другую директорию (вне репозитория). Проверил, что state-файл (terraform.tfstate) отсутствует. Запустил Terraform в обеих директориях и проконтролировал, что он "видит" текущее состояние независимо от директории, в которой запускается  

3. Попробовал запустить применение конфигурации одновременно, чтобы проверить работу блокировок  

    <details><summary>Блокировка</summary><p>

    ```bash
    >terraform apply -auto-approve=true

    Error: Error locking state: Error acquiring the state lock: writing "gs://terraform-reddit-storage-bucket/reddit/prod/default.tflock" failed: googleapi: Error 412: Precondition Failed, conditionNotMet
    Lock Info:
      ID:        1548074046214749
      Path:      gs://terraform-reddit-storage-bucket/reddit/prod/default.tflock
      Operation: OperationTypeApply
      Who:       user@user.localdomain
      Version:   0.11.11
      Created:   2019-01-21 12:34:06.121335176 +0000 UTC
      Info:      


    Terraform acquires a state lock to protect the state from being written
    by multiple users at the same time. Please resolve the issue above and try
    again. For most commands, you can disable locking with the "-lock=false"
    flag, but this is not recommended.

    ```

    </p></details>

### Задание с ** №2  

1. Добавил необходимые provisioner в модули для деплоя и работы приложения и бд. Файлы, используемые в provisioner, расположены в директории модулей  

    БД слушает на ip локальной сети. Приложение подключается к БД по локальной сети.

    <details><summary>Результат</summary><p>

    ![bucket](https://i.imgur.com/lzqiRgM.png)

    </p></details>

</p></details>

## ДЗ №8  

<details><summary>Спойлер</summary><p>

- Создал инвентори файл и ansible.cfg. Убедился, что Ansible может управлять хостами.  
- Сравнил работу модулей command, shell и service.  
- Создал базовый плейбук.  
- Выполнил ```ansible app -m command -a 'rm -rf ~/reddit'``` и проверил ещё раз выполнение плейбука.  

    <details><summary>Результат</summary><p>

    ```bash

    >ansible-playbook clone.yml

    PLAY [Clone] ***************************************************************************************************************************************************************************************************

    TASK 1/1 [Clone repo] ******************************************************************************************************************************************************************************************
    changed: 1/1 [appserver]

    PLAY RECAP *****************************************************************************************************************************************************************************************************
    appserver                  : ok=1    changed=1    unreachable=0    failed=0

    ```

    </p></details>

    Изменилось состояние ```changed=1```, так как директория отсутствовала и ansible склонировал её.  

</p></details>

## ДЗ №9  

### Один playbook, один сценарий  

- Добавлен reddit_app.yml  
- Добавлены шаблоны  
- Добавлены handlers  
- Добавлены задачи надеплой кода и установку зависимостей 
- Проведён деплой

  <details><summary>Результат</summary><p>

  ![deploy](https://i.imgur.com/ZPsJGdh.png)

  </p></details>

### Один плейбук, несколько сценариев  

- Добавлен reddit_app2.yml с разбивкой задач по хостам
- Проведён деплой

  <details><summary>Результат</summary><p>

  ![deploy](https://i.imgur.com/Opjdr2d.png)

  </p></details>

### Несколько плейбуков

- Добавлены отдельные playbooks для разных хостов  
- Добавлен site.yml объединяющий запуск playbooks
- Проведён деплой

  <details><summary>Результат</summary><p>

  ![deploy](https://i.imgur.com/g89GlUY.png)

  </p></details>

### Провижининг в Packer  

- Добавлены packer_app.yml и packer_db.yml  
- Выполнен билд образов с использованием ansible  

  <details><summary>Результат</summary><p>

  ```bash

  >packer.io build -var-file=packer/variables.json packer/app.json
  googlecompute output will be in this color.

  ==> googlecompute: Checking image does not exist...
  ==> googlecompute: Creating temporary SSH key for instance...
  ==> googlecompute: Using image: ubuntu-1604-xenial-v20190122a
  ==> googlecompute: Creating instance...
      googlecompute: Loading zone: europe-north1-b
      googlecompute: Loading machine type: f1-micro
      googlecompute: Requesting instance creation...
      googlecompute: Waiting for creation operation to complete...
      googlecompute: Instance has been created!
  ==> googlecompute: Waiting for the instance to become running...
      googlecompute: IP: 35.228.131.18
  ==> googlecompute: Using ssh communicator to connect: 35.228.131.18
  ==> googlecompute: Waiting for SSH to become available...
  ==> googlecompute: Connected to SSH!
  ==> googlecompute: Provisioning with Ansible...
  ==> googlecompute: Executing Ansible: ansible-playbook --extra-vars packer_build_name=googlecompute packer_builder_type=googlecompute -i /tmp/packer-provisioner-ansible433725229 ~/YogSottot_infra/ansible/packer_app.yml -e ansible_ssh_private_key_file=/tmp/ansible-key581752198
      googlecompute:
      googlecompute: PLAY [Install Ruby and Bundler] ************************************************
      googlecompute:
      googlecompute: TASK [Gathering Facts] *********************************************************
      googlecompute: ok: [default]
      googlecompute:
      googlecompute: TASK [Install ruby and rubygems and required packages] *************************
      googlecompute: changed: [default]
      googlecompute:
      googlecompute: PLAY RECAP *********************************************************************
      googlecompute: default                    : ok=2    changed=1    unreachable=0    failed=0
      googlecompute:
  ==> googlecompute: Deleting instance...
      googlecompute: Instance has been deleted!
  ==> googlecompute: Creating image...
  ==> googlecompute: Deleting disk...
      googlecompute: Disk has been deleted!
  Build 'googlecompute' finished.

  ==> Builds finished. The artifacts of successful builds are:
  --> googlecompute: A disk image was created: reddit-app-1548405692

  ```

  </p></details>

- На основе созданных app и db образов запущено stage окружение  
- Проверено, что c помощью плейбука site.yml окружение конфигурируется, а приложение деплоится и работает 

### Задание со ⭐  

- Исследованы возможности использования dynamic inventory для GCP  
- Выбран скрипт [```gce_googleapiclient.py```](https://github.com/ansible/ansible/pull/24505)  
  Отличается от ```gce.py``` возможностью фильтрации по labels и тем, что использует для авторизации тот же файл, что и утилиты gcloud. Нет необходимости создавать service_account.json  
  
  <details><summary>Проверка скрипта</summary><p>

  ```bash

  >ansible all -i gce_googleapiclient.py -m ping
  reddit-app-stage-01 | SUCCESS => {
      "changed": false,
      "ping": "pong"
  }
  reddit-db-stage-01 | SUCCESS => {
      "changed": false,
      "ping": "pong"
  }

  ```


  ```bash

  >ansible-inventory --list -i gce_googleapiclient.py
  {
      "10.166.15.203": {
          "hosts": [
              "reddit-db-stage-01"
          ]
      },
      "10.166.15.204": {
          "hosts": [
              "reddit-app-stage-01"
          ]
      },
      "35.228.152.71": {
          "hosts": [
              "reddit-db-stage-01"
          ]
      },
      "35.228.50.122": {
          "hosts": [
              "reddit-app-stage-01"
          ]
      },
      "_meta": {
          "hostvars": {
              "reddit-app-stage-01": {
                  "ansible_ssh_host": "35.228.50.122",
                  "gce_description": null,
                  "gce_id": "84892968559227027",
                  "gce_image": "reddit-app-1548405692",
                  "gce_machine_type": "g1-small",
                  "gce_metadata": {
                      "ssh-keys": "appuser:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzAKLEMEY20W7voyjl6OAPfDmpc95FLpX8SV4vP/opd support@localhost\n"
                  },
                  "gce_name": "reddit-app-stage-01",
                  "gce_network": "default",
                  "gce_private_ip": "10.166.15.204",
                  "gce_project": "infra-226118",
                  "gce_public_ip": "35.228.50.122",
                  "gce_status": "RUNNING",
                  "gce_subnetwork": "default",
                  "gce_tags": [
                      "reddit-app"
                  ],
                  "gce_uuid": "296a106275e9777ee6849e3cf3dd4b0a74eb493f",
                  "gce_zone": "europe-north1-b"
              },
              "reddit-db-stage-01": {
                  "ansible_ssh_host": "35.228.152.71",
                  "gce_description": null,
                  "gce_id": "8614816361944101023",
                  "gce_image": "reddit-db-1548406166",
                  "gce_machine_type": "g1-small",
                  "gce_metadata": {
                      "ssh-keys": "appuser:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzAKLEMEY20W7voyjl6OAPfDmpc95FLpX8SV4vP/opd support@localhost\n"
                  },
                  "gce_name": "reddit-db-stage-01",
                  "gce_network": "default",
                  "gce_private_ip": "10.166.15.203",
                  "gce_project": "infra-226118",
                  "gce_public_ip": "35.228.152.71",
                  "gce_status": "RUNNING",
                  "gce_subnetwork": "default",
                  "gce_tags": [
                      "reddit-db"
                  ],
                  "gce_uuid": "724d91495100ad4e46675209cea97bb2559796f2",
                  "gce_zone": "europe-north1-b"
              }
          }
      },
      "all": {
          "children": [
              "10.166.15.203",
              "10.166.15.204",
              "35.228.152.71",
              "35.228.50.122",
              "europe-north1-b",
              "g1-small",
              "network_default",
              "project_infra-226118",
              "reddit-app-1548405692",
              "reddit-db-1548406166",
              "status_running",
              "tag_reddit-app",
              "tag_reddit-db",
              "ungrouped"
          ]
      },
      "europe-north1-b": {
          "hosts": [
              "reddit-app-stage-01",
              "reddit-db-stage-01"
          ]
      },
      "g1-small": {
          "hosts": [
              "reddit-app-stage-01",
              "reddit-db-stage-01"
          ]
      },
      "network_default": {
          "hosts": [
              "reddit-app-stage-01",
              "reddit-db-stage-01"
          ]
      },
      "project_infra-226118": {
          "hosts": [
              "reddit-app-stage-01",
              "reddit-db-stage-01"
          ]
      },
      "reddit-app-1548405692": {
          "hosts": [
              "reddit-app-stage-01"
          ]
      },
      "reddit-db-1548406166": {
          "hosts": [
              "reddit-db-stage-01"
          ]
      },
      "status_running": {
          "hosts": [
              "reddit-app-stage-01",
              "reddit-db-stage-01"
          ]
      },
      "tag_reddit-app": {
          "hosts": [
              "reddit-app-stage-01"
          ]
      },
      "tag_reddit-db": {
          "hosts": [
              "reddit-db-stage-01"
          ]
      },
      "ungrouped": {}
  }

  ```

  </p></details>  

- Скрипт добавлен в ansible.cfg и добавлены плейбуки site_dynamic.yml db_dynamic.yml app_dynamic.yml deploy_dynamic.yml которые используют его  

  <details><summary>Результат деплоя</summary><p>

  ![deploy](https://i.imgur.com/4co3Xj8.png)

  ```bash

  >ansible-playbook site_dynamic.yml 

   PLAY [Configure MongoDB] ***************************************************************************************************************************************************************************************

   TASK 1/1 [Gathering Facts] *************************************************************************************************************************************************************************************
   ok: 1/1 [reddit-db-stage-01]

   TASK 2/1 [Change mongo config file] ****************************************************************************************************************************************************************************
   changed: 1/1 [reddit-db-stage-01]
   changed: 2/1 [reddit-db-stage-01]

   PLAY [Configure App] *******************************************************************************************************************************************************************************************

   TASK 3/3 [Gathering Facts] *************************************************************************************************************************************************************************************
   ok: 1/1 [reddit-app-stage-01]

   TASK 4/3 [Add unit file for Puma] ******************************************************************************************************************************************************************************
   changed: 1/1 [reddit-app-stage-01]

   TASK 5/3 [Add config for DB connection] ************************************************************************************************************************************************************************
   changed: 1/1 [reddit-app-stage-01]

   TASK 6/3 [enable puma] *****************************************************************************************************************************************************************************************
   changed: 1/1 [reddit-app-stage-01]
   changed: 2/1 [reddit-app-stage-01]

   PLAY [Deploy App] **********************************************************************************************************************************************************************************************

   TASK 7/2 [Fetch the latest version of application code] ********************************************************************************************************************************************************
   changed: 1/1 [reddit-app-stage-01]

   TASK 8/2 [Bundle install] **************************************************************************************************************************************************************************************
   changed: 1/1 [reddit-app-stage-01]
   changed: 2/1 [reddit-app-stage-01]

   PLAY RECAP *****************************************************************************************************************************************************************************************************
   reddit-app-stage-01        : ok=8    changed=7    unreachable=0    failed=0   
   reddit-db-stage-01         : ok=3    changed=2    unreachable=0    failed=0   

  ```

  </p></details>
