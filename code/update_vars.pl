#!/usr/bin/perl
use strict;
use warnings;

# Specify the input Rmarkdown file
my $input_file = 'social_learning_type_token_sequential_results.Rmd';
my $output_file = 'social_learning_type_token_sequential_results_new.Rmd';

# Open the input Rmarkdown file for reading
open(my $in, '<', $input_file) or die "Cannot open file $input_file: $!";

# Open the output file for writing
open(my $out, '>', $output_file) or die "Cannot open file $output_file: $!";

# Define the old column names and the new column names
my %column_changes = (
    'd.vs.single_highTypeFreq_prevalence_bin' => 'd.single.vs.highTypeFreq_prevalence_bin',
    'd.vs.single_lowTypeFreq_prevalence_bin' => 'd.single.vs.lowTypeFreq_prevalence_bin',
    'd.vs.single_highTypeFreq_first.party.acceptability_bin' => 'd.single.vs.highTypeFreq_first.party.acceptability_bin',
    'd.vs.single_lowTypeFreq_first.party.acceptability_bin' => 'd.single.vs.lowTypeFreq_first.party.acceptability_bin',
    'd.vs.single_highTypeFreq_third.party.acceptability_bin' => 'd.single.vs.highTypeFreq_third.party.acceptability_bin',
    'd.vs.single_lowTypeFreq_third.party.acceptability_bin' => 'd.single.vs.lowTypeFreq_third.party.acceptability_bin',
    'd.high.vs.low.TypeFreq_prevalence_bin' => 'd.highTypeFreq.vs.lowTypeFreq_prevalence_bin',
    'd.high.vs.low.TypeFreq_first.party.acceptablity_bin' => 'd.highTypeFreq.vs.lowTypeFreq_first.party.acceptability_bin',
    'd.high.vs.low.TypeFreq_third.party.acceptablity_bin' => 'd.highTypeFreq.vs.lowTypeFreq_third.party.acceptability_bin',
    # Repeat this for raw score columns as well
    'd.vs.single_highTypeFreq_prevalence_raw' => 'd.single.vs.highTypeFreq_prevalence_raw',
    'd.vs.single_lowTypeFreq_prevalence_raw' => 'd.single.vs.lowTypeFreq_prevalence_raw',
    'd.vs.single_highTypeFreq_first.party.acceptability_raw' => 'd.single.vs.highTypeFreq_first.party.acceptability_raw',
    'd.vs.single_lowTypeFreq_first.party.acceptability_raw' => 'd.single.vs.lowTypeFreq_first.party.acceptability_raw',
    'd.vs.single_highTypeFreq_third.party.acceptability_raw' => 'd.single.vs.highTypeFreq_third.party.acceptability_raw',
    'd.vs.single_lowTypeFreq_third.party.acceptability_raw' => 'd.single.vs.lowTypeFreq_third.party.acceptability_raw',
    'd.high.vs.low.TypeFreq_prevalence_raw' => 'd.highTypeFreq.vs.lowTypeFreq_prevalence_raw',
    'd.high.vs.low.TypeFreq_first.party.acceptablity_raw' => 'd.highTypeFreq.vs.lowTypeFreq_first.party.acceptability_raw',
    'd.high.vs.low.TypeFreq_third.party.acceptablity_raw' => 'd.highTypeFreq.vs.lowTypeFreq_third.party.acceptability_raw'
);

# Read each line of the file
while (my $line = <$in>) {
    # Apply the column name replacements
    foreach my $old_col (keys %column_changes) {
        my $new_col = $column_changes{$old_col};
        $line =~ s/\b\Q$old_col\E\b/$new_col/g;
    }
    # Write the modified line to the output file
    print $out $line;
}

# Close the input and output files
close($in);
close($out);

print "Column names updated successfully. Output written to $output_file\n";

