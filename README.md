# bash_profile

Добавлены темы для vim

- newhost
- host

Добавлена установка zabbix-agent. Папка zabbix-agent.

Добавлена установка aide

Профиль для тех хостов, где нельзя использовать общий профиль.

- mc
- Копирование

git clone https://github.com/n0rvik/bash_profile.git

# Установка

```
cd /usr/local/src
git clone https://github.com/n0rvik/bash_profile.git
cd bash_profile
sh cp2home.sh
sh cp2vim.sh
sh cp2skel.sh
```

# Восстановление старых настроек

```
sh cp2orig.sh
```

# Установка цвета xoria для mc

```
cd mc
sh ./1.sh
```

------------------------------------------------------------------------------