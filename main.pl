#!/usr/bin/perl

#######################################################
### main.pl											###
### This is the starting point for running test		###
### scripts.										###
### A. Caravello 7/25/2015							###
#######################################################

# Load Modules
use strict;
use DBI;
use LWP::UserAgent;
use Data::Dumper;

#######################################################
### User Configurable Parameters					###
#######################################################
# Web Site Connection Info
our %config = (
	"hostname"	=> "",
	"login"		=> "",
	"password"	=> "",
);

#######################################################
### Connect to Site									###
#######################################################
my $site = LWP::UserAgent->new;
$site->timeout(10);
$site->{agent} = "PorkchopTestSuitePerl/0.1";

#######################################################
### Main Procedure									###
#######################################################
# Monitoring Tests
require("monitor.pl");
