# YogSottot_infra  

YogSottot Infra repository  

## ДЗ №3  

### способ подключения к someinternalhost в одну команду из вашего рабочего устройства  

```ssh -A -t utrgroup@35.228.152.71 ssh 10.166.0.3```  

Где:  
- utrgroup — имя пользователя  
- 35.228.152.71 — bastion  
- 10.166.0.3 — someinternalhost  

### вариант решения для подключения из консоли при помощи команды вида ssh someinternalhost из локальной консоли рабочего устройства, чтобы подключение выполнялось по алиасу someinternalhost  

Добавляем в ~/.ssh/config  

```bash

Host bastion
    HostName 35.228.152.71
    User utrgroup

Host someinternalhost
    ProxyCommand ssh -A bastion -W 10.166.0.3:22
    User utrgroup

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
