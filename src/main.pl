#!/usr/bin/perl

use strict;
use warnings;
use JSON;
use Term::Menus;
use "./scripts/setup.pl";

open my $json, "<", "variables.json" or die "Failed to open $!\n.";
my $variables = decode_json(do { local $/; <$json> });
close $json;

package main;

our $intro = <<INTRO;
aurutilsinstaller v${$variables->["version"]}
A shell script to deploy aurutils scripts for Arch Linux systems
INTRO

our %options = (
  "Setup aurutils and dependencies (git, vifm/vicmd)" => \&setup->main
  # ["Setup aurutils and dependencies (git, vifm/vicmd)"]
  # ["Scripts (aur-remove, aur-gc, ...)"]
  # ["Repository management"]
  # ["Quit"]
);


sub main {
  $ENV{ROOT} = system("whoami") eq "root"; 
  
  print $intro;
  my @items = ();
  foreach my $key (keys %options) {
    push @items, $key;
  }
  my $select = menu(@items);

  &{$options{$select}}();
  return 0;
};

main();
