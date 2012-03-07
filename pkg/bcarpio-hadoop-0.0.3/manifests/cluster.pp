# /etc/puppet/modules/hadoop/manifests/master.pp

class hadoop::cluster {
	# do nothing, magic lookup helper
}

class hadoop::cluster::master {
	
        file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/masters":
		owner => "hduser",
		group => "hadoop",
		mode => "644",
		alias => "hadoop-master",
		content => template("hadoop/conf/masters.erb"),		
	}

}

class hadoop::cluster::slave {
        file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/slaves":
		owner => "hduser",
		group => "hadoop",
		mode => "644",
		alias => "hadoop-slave",
		content => template("hadoop/conf/slaves.erb"),		
	}
}