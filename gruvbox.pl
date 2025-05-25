#!/usr/bin/perl
use strict;
use warnings;

if (@ARGV != 2) {
    die "Usage: $0 <input_catppuccin_file> <output_gruvbox_file>\n";
}

my ($input_file, $output_file) = @ARGV;

open my $fh_in, '<', $input_file
    or die "Error: Could not open input file '$input_file': $!\n";

open my $fh_out, '>', $output_file
    or die "Error: Could not open output file '$output_file': $!\n";

print "Processing '$input_file'...\n";

while (my $line = <$fh_in>) {

    # $line =~ s/latte/gruvbox/ig;       
    # $line =~ s/Latte/Gruvbox/ig;       
    #
    # $line =~ s/rosewater/gyellow/g;
    # $line =~ s/flamingo/gyellow_b/g;
    # $line =~ s/pink/purple/g;
    # $line =~ s/mauve/purple_b/g;
    # #Red is red
    # $line =~ s/maroon/red_b/g;
    # $line =~ s/peach/orange/g;
    # $line =~ s/yellow/orange_b/g;
    # #Green is green
    # $line =~ s/teal/green_b/g;
    # $line =~ s/sky/aqua/g;
    # $line =~ s/sapphire/aqua_b/g;
    # #Blue is blue
    # $line =~ s/Lavender/blue_b/g;
    #
    # $line =~ s/Rosewater/Yellow/g;
    # $line =~ s/Flamingo/Yellow_b/g;
    # $line =~ s/Pink/Purple/g;
    # $line =~ s/Mauve/Purple_b/g;
    # #Red is red
    # $line =~ s/Maroon/Red_b/g;
    # $line =~ s/Peach/Orange/g;
    # $line =~ s/Yellow/Orange_b/g;
    # #Green is green
    # $line =~ s/Teal/Green_b/g;
    # $line =~ s/Sky/Aqua/g;
    # $line =~ s/Sapphire/Aqua_b/g;
    # #Blue is blue
    # $line =~ s/lavender/Blue_b/g;

    $line =~ s/#dc8a78/#d79921/ig;
    $line =~ s/#dd7878/#b57614/ig;
    $line =~ s/#ea76cb/#b16286/ig;
    $line =~ s/#8839ef/#8f3f71/ig;
    $line =~ s/#d20f39/#cc241d/ig;
    $line =~ s/#e64553/#9d0006/ig;
    $line =~ s/#fe640b/#d65d0e/ig;
    $line =~ s/#df8e1d/#af3a03/ig;
    $line =~ s/#40a02b/#6c782e/ig;
    $line =~ s/#179299/#618352/ig;
    $line =~ s/#04a5e5/#689d6a/ig;
    $line =~ s/#209fb5/#427b58/ig;
    $line =~ s/#1e66f5/#458588/ig;
    $line =~ s/#7287fd/#076678/ig;

    $line =~ s/#4c4f69/#282828/ig;
    $line =~ s/#5c5f77/#3c3836/ig;
    $line =~ s/#6c6f85/#504945/ig;
    $line =~ s/#7c7f93/#665c54/ig;
    $line =~ s/#8c8fa1/#7c6f64/ig;
    $line =~ s/#9ca0b0/#928374/ig;
    $line =~ s/#acb0be/#a89984/ig;
    $line =~ s/#bcc0cc/#bdae93/ig;
    $line =~ s/#ccd0da/#d5c4a1/ig;
    $line =~ s/#dce0e8/#ebdbb2/ig;
    $line =~ s/#e6e9ef/#f2e5bc/ig;
    $line =~ s/#eff1f5/#fbf1c7/ig;

    #Additional
    $line =~ s/#191724/#ebdbb2/ig;

    print $fh_out $line;
}

close $fh_in;
close $fh_out;

print "Conversion complete. Output written to '$output_file'.\n";
