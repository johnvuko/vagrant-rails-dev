function install {
    echo installing $1
    shift
    apt-get -y install "$@" >/dev/null 2>&1
}

update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

echo updating package information
apt-get -y update >/dev/null 2>&1

install "System tools" build-essential ntpdate logrotate htop screen openssl curl
install Git git
install SVN subversion
install SQLite sqlite3 libsqlite3-dev
install ImageMagick imagemagick
install Redis redis-server redis-client
install 'Nokogiri dependencies' libxslt-dev libxml2-dev

echo "
alias ls='ls --color'
alias grep='grep --color'
alias egrep='egrep --color'

if [[ \${EUID} == 0 ]] ; then
	PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
else
	PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
fi
" >> /home/vagrant/.bashrc

echo "#!/bin/sh

test -x /usr/sbin/ntpdate-debian || exit 0
/usr/sbin/ntpdate-debian
" > /etc/cron.hourly/ntpdate


install PostgreSQL postgresql postgresql-contrib libpq-dev
sudo -u postgres createuser --superuser vagrant

echo Intall RVM
su vagrant -c 'curl -sSL https://get.rvm.io | bash' >/dev/null 2>&1
su vagrant -c 'ssh-keygen -t rsa -b 4096 -f /home/vagrant/.ssh/id_rsa -N ""' >/dev/null 2>&1
su vagrant -c 'mkdir /home/vagrant/projects/' >/dev/null 2>&1

exit 0
