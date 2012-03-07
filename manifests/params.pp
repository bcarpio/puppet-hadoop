# /etc/puppet/modules/hadoop/manifests/params.pp

class hadoop::params {

	include java::params

	$version = $::hostname ? {
		default			=> "0.20.203.0",
	}
        
	$master = $::hostname ? {
		default			=> "hadoop01",
	}
        
	$slaves = $::hostname ? {
		default			=> [hadoop01, hadoop-02, hadoop-03] 
	}
	$hdfsport = $::hostname ? {
		default			=> "8020",
	}

	$replication = $::hostname ? {
		default			=> "3",
	}

	$jobtrackerport = $::hostname ? {
		default			=> "8021",
	}
	$java_home = $::hostname ? {
		default			=> "${java::params::java_base}/jdk${java::params::java_version}",
	}
	$hadoop_base = $::hostname ? {
		default			=> "/opt/hadoop",
	}
	$hdfs_path = $::hostname ? {
		default			=> "/home/hduser/hdfs",
	}
}
