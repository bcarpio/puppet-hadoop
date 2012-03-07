# /etc/puppet/modules/hadoop/manafests/init.pp

class hadoop {

	require hadoop::params
	
	group { "hadoop":
		ensure => present,
		gid => "800"
	}

	user { "hduser":
		ensure => present,
		comment => "Hadoop",
		password => "!!",
		uid => "800",
		gid => "800",
		shell => "/bin/bash",
		home => "/home/hduser",
		require => Group["hadoop"],
	}
	
	file { "/home/hduser/.bash_profile":
		ensure => present,
		owner => "hduser",
		group => "hadoop",
		alias => "hduser-bash_profile",
		content => template("hadoop/home/bash_profile.erb"),
		require => User["hduser"]
	}
		
	file { "/home/hduser":
		ensure => "directory",
		owner => "hduser",
		group => "hadoop",
		alias => "hduser-home",
		require => [ User["hduser"], Group["hadoop"] ]
	}

	file {"$hadoop::params::hdfs_path":
		ensure => "directory",
		owner => "hduser",
		group => "hadoop",
		alias => "hdfs-dir",
		require => File["hduser-home"]
	}
	
	file {"$hadoop::params::hadoop_base":
		ensure => "directory",
		owner => "hduser",
		group => "hadoop",
		alias => "hadoop-base",
	}
	
	file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}.tar.gz":
		mode => 0644,
		owner => hduser,
		group => hadoop,
		source => "puppet:///modules/hadoop/hadoop-${hadoop::params::version}.tar.gz",
		alias => "hadoop-source-tgz",
		before => Exec["untar-hadoop"],
		require => File["hadoop-base"]
	}
	
	exec { "untar hadoop-${hadoop::params::version}.tar.gz":
		command => "tar -zxf hadoop-${hadoop::params::version}.tar.gz",
		cwd => "${hadoop::params::hadoop_base}",
		creates => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}",
		alias => "untar-hadoop",
		refreshonly => true,
		subscribe => File["hadoop-source-tgz"],
		user => "hduser",
		before => File["hadoop-symlink"]
	}
		
	file { "${hadoop::params::hadoop_base}/hadoop":
		force => true,
		ensure => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}",
		alias => "hadoop-symlink",
		owner => "hduser",
		group => "hadoop",
		require => File["hadoop-source-tgz"],
		before => [ File["core-site-xml"], File["hdfs-site-xml"], File["mapred-site-xml"], File["hadoop-env-sh"]]
	}
	
	file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/core-site.xml":
		owner => "hduser",
		group => "hadoop",
		mode => "644",
		alias => "core-site-xml",
		content => template("hadoop/conf/core-site.xml.erb"),
	}
	
	file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/hdfs-site.xml":
		owner => "hduser",
		group => "hadoop",
		mode => "644",
		alias => "hdfs-site-xml",
		content => template("hadoop/conf/hdfs-site.xml.erb"),
	}
	
	file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/hadoop-env.sh":
		owner => "hduser",
		group => "hadoop",
		mode => "644",
		alias => "hadoop-env-sh",
		content => template("hadoop/conf/hadoop-env.sh.erb"),
	}
	
	exec { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/bin/hadoop namenode -format":
		user => "hduser",
		alias => "format-hdfs",
		refreshonly => true,
		subscribe => File["hdfs-dir"],
		require => [ File["hadoop-symlink"], File["java-app-dir"], File["hduser-bash_profile"], File["mapred-site-xml"], File["hdfs-site-xml"], File["core-site-xml"], File["hadoop-env-sh"]]
	}
	
	file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/mapred-site.xml":
		owner => "hduser",
		group => "hadoop",
		mode => "644",
		alias => "mapred-site-xml",
		content => template("hadoop/conf/mapred-site.xml.erb"),		
	}
	
	file { "/home/hduser/.ssh/":
		owner => "hduser",
		group => "hadoop",
		mode => "700",
		ensure => "directory",
		alias => "hduser-ssh-dir",
	}
	
	file { "/home/hduser/.ssh/id_rsa.pub":
		ensure => present,
		owner => "hduser",
		group => "hadoop",
		mode => "644",
		source => "puppet:///modules/hadoop/ssh/id_rsa.pub",
		require => File["hduser-ssh-dir"],
	}
	
	file { "/home/hduser/.ssh/id_rsa":
		ensure => present,
		owner => "hduser",
		group => "hadoop",
		mode => "600",
		source => "puppet:///modules/hadoop/ssh/id_rsa",
		require => File["hduser-ssh-dir"],
	}
	
	file { "/home/hduser/.ssh/authorized_keys":
		ensure => present,
		owner => "hduser",
		group => "hadoop",
		mode => "644",
		source => "puppet:///modules/hadoop/ssh/id_rsa.pub",
		require => File["hduser-ssh-dir"],
	}	
}
