exec {'yum update -y':
path => '/usr/bin',
}
->
package {'java-1.8.0-openjdk-headless.x86_64':
ensure => present,
}
->
package {'epel-release':
ensure => present,
}
->
package{'pwgen':
ensure => present,
}
->
file {'/etc/yum.repos.d/mongodb-org-3.2.repo':
ensure => present,
source => '/var/mongodbrepo',
}
->
package {'mongodb-org':
ensure => present,
}
->
exec {'chkconfig --add mongod':
path => '/sbin',
}
->
exec {'systemctl daemon-reload':
path => '/bin',
}
->
exec {'systemctl enable mongod.service':
path => '/bin',
}
service {'mongod.service':
ensure => running,
hasrestart => true,
}
->
exec {'rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch':
path => '/bin',
}
->
file {'/etc/yum.repos.d/elasticsearch.repo':
ensure => present,
source => '/var/elasticsearch',
}
->
package {'elasticsearch':
ensure => present,
}
->
exec {'cp /var/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml && touch /tmp/flagfile':
path => '/bin',
creates => '/tmp/flagfile',
}
->
exec {'chkconfig --add elasticsearch':
path => '/sbin',
}
->
exec {'systemctl enable elasticsearch.service':
path => '/bin',
}
service {'elasticsearch.service':
ensure => running,
hasrestart => true,
}
package {'graylog-server':
ensure => present,
}
->
exec {'rm -f /etc/graylog/server/server.conf':
path => '/bin',
}
->
file {'/etc/graylog/server/server.conf':
ensure => present,
source => '/var/server.conf',
}
->
exec {'chkconfig --add graylog-server':
path => '/sbin',
}
->
exec {'systemctl enable graylog-server.service':
path => '/bin',
}
service {'graylog-server.service':
ensure => running,
hasrestart => true,
}
->
exec {'firewall-cmd --permanent --zone=public --add-port=9000/tcp':
path => '/bin',
}
->
exec {'firewall-cmd --permanent --zone=public --add-port=12900/tcp':
path => '/bin',
}
->
exec {'firewall-cmd --permanent --zone=public --add-port=1514/tcp':
path => '/bin',
}
->
exec {'firewall-cmd --reload':
path => '/bin',
}
->
package {'policycoreutils-python':
ensure => present,
}
->
exec {'setsebool -P httpd_can_network_connect 1':
path => '/sbin',
}
->
exec {'semanage port -a -t mongod_port_t -p tcp 27017 && touch /tmp/flagfile1':
path => '/sbin',
creates => '/tmp/flagfile1',
}
