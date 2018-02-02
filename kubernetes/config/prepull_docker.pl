#!/usr/bin/perl

use strict;

use Getopt::Std;

#autoflush to logs
$| = 1;
my %opts = ();

getopts("l:c:u:p:d:r:?", \%opts);

if ($opts{'?'}) {
    usage();
    exit;
}
my $location = $opts{'l'} || ".";
my $logdir = $opts{'d'} || 'logs';
my $setsize = $opts{'c'} || 20;
my $dockerlogin = $opts{'u'} || 'docker';
my $dockerpw = $opts{'p'} || 'docker';

my $onap_docker_repo = $opts{'r'} || "nexus3.onap.org:10001";

print "Location: $location\n";

my @file_list = `/usr/bin/find $location -name values.yaml 2>/dev/null`;
my %docker_images = ();
my $in_image = 0;
my $last_unindented = "";

sub usage {
    my $msg = shift;
    print STDERR <<EOF

Usage: $0 [OPTION]...

This utility will scan for values.yaml files, compile of list of
docker iamges to pull, fire off CONCURRENT_PULLS docker pull operations
and provide feedback to the user of progress and log output of docker
pull, one logfile per docker image.

  -l OOM_SRC_LOCATION          location of OOM src directory 
                                 (default: ".")
  -c CONCURRENT_PULLS          sets the number of concurrent docker pulls 
                                 (default: 20)
  -u DOCKER_USER               sets the docker username
     			         (default: docker)
  -p DOCKER_PASS	       sets the docker password
  -r DOCKER_REPO	       sets the docker repo
                                 (default: nexus3.onap.org:10001)
  -d LOG_DIR		       sets the location for the logfiles
     			         (default: ./logs)

EOF

}
for my $filename (@file_list) {
    chomp($filename);
    my @path = split(/\//, $filename);
    my $system = $path[-2];
    #print STDERR "Looking for images under: $system ($filename)\n";
    open FILE, "$filename";
    while (<FILE>) {
	my $line = $_;
	chomp($line);

	if ($line =~ /^(\S+):/) {
	    $last_unindented = $1;
	}
	if ($line =~ /\simage: (.+)/) {
	    $docker_images{"${system}-${last_unindented}"}{'full_repo_name'} = $1;
	    next;
	}
	if ($line =~ /^image:/) {
	    $in_image = 1;
	    next;
	}
	if ($in_image == 1 && $line =~/^\S/) {
	    $in_image = 0;
	    next;
	}
	if ($in_image == 1) {
	    if ($line =~ /(\S+)\: (.+)/) {
		my ($key, $val) = ($1, $2);
		if ($key =~ /(\S+)Image$/) {
		    $docker_images{"${system}-${1}"}{'docker_name'} = $val;
		} elsif ($key =~ /(\S+)Version$/) {
		    $docker_images{"${system}-${1}"}{'docker_version'} = $val;
		} else {
		    $docker_images{"${system}-${key}"}{'docker_truncated_name'} = $val;
		}
	    }
	}
    }
}

my $i = 0;

my %pids_to_docker_image = ();

system("docker login -u $dockerlogin -p $dockerpw nexus3.onap.org:10001");
sleep 5;
foreach my $name (sort {$a cmp $b} keys %docker_images) {
    if (not defined $docker_images{$name}{'full_repo_name'}) {
	#try this
	if (defined $docker_images{$name}{'docker_version'}) {
	    if (defined $docker_images{$name}{'docker_name'}) {
		$docker_images{$name}{'full_repo_name'} =
		    "$docker_images{$name}{'docker_name'}:$docker_images{$name}{'docker_version'}";
	    } else {
		$docker_images{$name}{'full_repo_name'} =
		    "$docker_images{$name}{'docker_truncated_name'}:$docker_images{$name}{'docker_version'}";
	    }
	} elsif ($docker_images{$name}{'docker_truncated_name'}) {
	    $docker_images{$name}{'full_repo_name'} =  "$docker_images{$name}{'docker_truncated_name'}";
	} else {
	    $docker_images{$name}{'full_repo_name'} =
		"$docker_images{$name}{'docker_name'}";
	}
    }

    if ( $docker_images{$name}{'full_repo_name'} ne "") {
	my $repo = $docker_images{$name}{'full_repo_name'};
	if ($repo =~ /^$onap_docker_repo/) {
	    print "$i Pulling $repo\n";

	    my $pid = fork();
	    $pids_to_docker_image{$pid}{'repo'} = $repo;
	    if ($pid) {
		$i++;
		if ($i >= $setsize) {
		    print "Waiting for one to finish...\n";
		    wait_for_one();
		    print "Continuing...\n";
		}
	    } else {
		exec("docker pull $repo > $logdir/$name.out 2>&1");
		exit;
	    }
	}
    }
}

while (1) {
    my $pid = wait_for_one();
    last if $pid == -1;
    printf "Waiting for %d pulls to finish...\n", scalar keys %pids_to_docker_image;
    sleep 1;
}

sub wait_for_one {
    my $pid = wait();
    print "Saw $pid finish ($pids_to_docker_image{$pid}{'repo'})\n";
    delete $pids_to_docker_image{$pid};
    return $pid;
}

