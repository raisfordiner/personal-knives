#!/usr/bin/perl
use strict;
use warnings;

if (@ARGV != 2) {
    die "Usage: $0 <input_file> <output_file>\n";
}

my ($input_file, $output_file) = @ARGV;

open my $fh_in, '<', $input_file
    or die "Error: Could not open input file '$input_file': $!\n";

open my $fh_out, '>', $output_file
    or die "Error: Could not open output file '$output_file': $!\n";

print "Processing '$input_file'...\n";

while (my $line = <$fh_in>) {

    #BG only
    $line =~ s/#1e1e2e/#000000/ig;
    $line =~ s/#181825/#000000/ig;
    $line =~ s/#11111b/#000000/ig;

    $line =~ s/https:\/\/userstyles.catppuccin.com\/lib\/lib.less/https:\/\/raw.githubusercontent.com\/raisfordiner\/dotfiles\/refs\/heads\/main\/colors\/cat-espr.less/ig;

    print $fh_out $line;
}

close $fh_in;
close $fh_out;

print "Conversion complete. Output written to '$output_file'.\n";
