#!/usr/bin/perl

use Getopt::Long;

my $test_only;
my $force;
my $help;

GetOptions
(
    "n|test|test_only|test-only" => \$test_only,
    "f|force"                    => \$force,
    "h|?|help"                   => \$help
);

usage() && exit 0 if $help;

my $regex = shift(@ARGV);
my $exp   = "(\$new=\$_) =~ $regex";
LOOP: foreach (@ARGV) 
{
    my $new;
    eval $exp;

    next LOOP if $_ eq $new;

    print "$_ -> $new\n";

    next LOOP if $test_only;

    if ((! -e $new) || $force)
    {
        rename $_, $new;
    }
    else
    {
        print "Overwrite (Y|N)?: ";
        chomp(my $input = <STDIN>);
        rename $_, $new
            if ($input =~ /^[Y]?$/i);
    }
}

sub usage
{
    print "Rename a file or set of files by applying a regular expression ";
    print "to the filename(s).\n";
    print "\n";
    print "Usage:\n";
    print "\tregex_rename.pl [options] regex filename[,filename,...]\n";
    print "\n";
    print "Options:\n";
    print "\t-n  Do everything except for renaming the file(s). Useful\n";
    print "\t    to see how the regex will be applied before making changes.\n";
    print "\n";
    print "\t-f  Do not prompt the user for confirmation before overwriting\n";
    print "\t    existing files.\n";
    print "\n";
    print "\t-h  Print this message.\n";
    print "\n";
    print "Example:\n";
    print "\tRename all files of the form file<#>.txt to <#>_filename.txt\n";
    print "\n";
    print "\t\$ regex_rename.pl \"s/file(\\d+).txt/\\\$1_filename.txt/\" *.txt";
    print "\n";
}

