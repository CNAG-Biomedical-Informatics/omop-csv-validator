package OMOP::CSV::Validator;

use strict;
use warnings;
use utf8;
use JSON::Validator;
use Text::CSV_XS;
use Scalar::Util qw(looks_like_number);
use Path::Tiny;

our $VERSION = '0.03';
our @DETECTABLE_SEPARATORS = ( ',', "\t", ';', '|' );

=head1 NAME

OMOP::CSV::Validator - Validates OMOP CDM CSV files against their expected data types

=head1 SYNOPSIS

    use OMOP::CSV::Validator;

    my $validator = OMOP::CSV::Validator->new();

    # Load schemas from DDL
    my $schemas = $validator->load_schemas_from_ddl($ddl_text);

    # Retrieve specific table schema for a CSV file
    my $schema = $validator->get_schema_from_csv_filename($csv_file, $schemas);

    # Validate CSV file
    my $errors  = $validator->validate_csv_file($csv_file, $schema);
    if (@$errors) {
        print "Validation errors found:\n";
        for my $err_info (@$errors) {
            print "Row $err_info->{row}:\n";
            for my $e (@{ $err_info->{errors} }) {
                print "  $e\n";
            }
        }
    } else {
        print "CSV is valid.\n";
    }

=head1 DESCRIPTION

OMOP::CSV::Validator is a CLI tool and Perl module designed to validate OMOP Common Data Model (CDM) CSV files. It auto-generates JSON schemas from PostgreSQL DDL files and then validates CSV rows against those schemas.

=head1 METHODS

=cut

##########################################################################
# Constructor: new()
##########################################################################
sub new {
    my ( $class, %args ) = @_;
    my $self = bless {}, $class;
    return $self;
}

##########################################################################
# load_schemas_from_ddl($ddl_text)
#
# Parses all CREATE TABLE definitions from a PostgreSQL OMOP DDL
# and returns a hashref of JSON schemas keyed by table name (lowercase).
##########################################################################
sub load_schemas_from_ddl {
    my ( $self, $ddl_text ) = @_;
    return $self->_ddl_to_json_schemas($ddl_text);
}

##########################################################################
# _ddl_to_json_schemas($ddl_text) - private
#
# Internal subroutine that iterates over all CREATE TABLE blocks.
##########################################################################
sub _ddl_to_json_schemas {
    my ( $self, $ddl_text ) = @_;
    my %schemas;
    while (
        $ddl_text =~ /
        CREATE\s+TABLE\s+
        (?:
            [^\s(]+?\.
        )?
        "?(\w+)"?\s*\(                    # capture table name with optional schema qualifier
        (.*?)                             # capture everything inside parentheses
        \)\s*;                            # until the closing parenthesis and semicolon
    /gisx
      )
    {
        my ( $table, $cols_block ) = ( lc $1, $2 );
        $schemas{$table} = $self->_build_schema( $table, $cols_block );
    }
    return \%schemas;
}

##########################################################################
# _build_schema($table_name, $cols_block) - private
#
# Builds a JSON schema for one table from the column definitions.
##########################################################################
sub _build_schema {
    my ( $self, $table_name, $cols_block ) = @_;
    my $schema = {
        '$schema'            => 'http://json-schema.org/draft-07/schema#',
        title                => $table_name,
        type                 => 'object',
        properties           => {},
        required             => [],
        additionalProperties => 0,
    };

    for my $line ( grep /\S/, split /\n/, $cols_block ) {
        $line         =~ s/^\s+|\s+$//g;
        $line         =~ s/,$//;
        next if $line =~ /^--/;            # Skip comment lines

        if ( $line =~
            /^"?(\w+)"?\s+([A-Za-z]+)(?:\((\d+(?:,\d+)?)\))?(?:\s+(NOT NULL))?/i )
        {
            my ( $col, $type, $length, $notnull ) =
              ( lc $1, lc $2, $3, defined $4 );
            my $prop = {};

            if ( $type =~ /int/ ) {
                $prop->{type}    = 'integer';
                $prop->{_coerce} = 1;
            }
            elsif ( $type =~ /numeric|real|double/ ) {
                $prop->{type}    = 'number';
                $prop->{_coerce} = 1;

            }
            elsif ( $type eq 'date' ) {
                $prop->{type}   = 'string';
                $prop->{format} = 'date';
            }
            elsif ( $type =~ /timestamp/ ) {
                $prop->{type}   = 'string';
                $prop->{format} = 'date-time';
            }
            elsif ( $type eq 'varchar' ) {
                $prop->{type} = 'string';
                if ( defined $length ) {

                    # Capture only the first number if a comma is present (e.g., varchar(10,2))
                    if ( $length =~ /^(\d+)/ ) {
                        $prop->{maxLength} = int($1);
                    }
                }
            }
            else {
                $prop->{type} = 'string';
            }

            # If the column is not marked as NOT NULL, allow null values
            unless ($notnull) {
                $prop->{type} = [ $prop->{type}, 'null' ];
            }

            $schema->{properties}{$col} = $prop;
            push @{ $schema->{required} }, $col if $notnull;
        }
    }
    return $schema;
}

##########################################################################
# get_schema_from_csv_filename($csv_filename, $schemas)
#
# Derives the table name from the CSV file's basename (e.g. PERSON.csv → person)
# and returns the corresponding schema from the provided hashref.
##########################################################################
sub get_schema_from_csv_filename {
    my ( $self, $csv_filename, $schemas ) = @_;
    my $table = $self->_table_name_from_csv_filename($csv_filename);
    return $schemas->{$table};
}

##########################################################################
# validate_csv_file($csv_file, $schema, $sep)
#
# Reads the CSV file, coerces numeric fields, and validates each row against
# the provided JSON schema. Returns an arrayref of error info (each entry is a
# hashref with keys 'row' and 'errors').
##########################################################################
sub validate_csv_file {
    my ( $self, $csv_file, $schema, $sep ) = @_;
    my $analysis = $self->_analyze_csv_file( $csv_file, $schema, $sep );
    return [
        map {
            {
                row    => $_->{row},
                errors => $_->{errors},
            }
        } grep { @{ $_->{errors} } } @{ $analysis->{rows} }
    ];
}

##########################################################################
# normalize_csv_value($val)
#
# Normalizes CSV null markers to undef.
##########################################################################
sub _table_name_from_csv_filename {
    my ( $self, $csv_filename ) = @_;
    ( my $table = lc $csv_filename ) =~ s{^.*/}{};      # remove any path
    $table =~ s/\.csv$//i;                              # remove .csv extension
    return $table;
}

##########################################################################
# _build_json_validator($schema)
#
# Returns a JSON::Validator instance for a pre-built schema.
##########################################################################
sub _build_json_validator {
    my ( $self, $schema ) = @_;
    my $validator = JSON::Validator->new;
    $validator->schema($schema);
    return $validator;
}

##########################################################################
# _csv_parser_for_sep($sep)
#
# Returns a Text::CSV_XS parser configured for a separator.
##########################################################################
sub _csv_parser_for_sep {
    my ( $self, $sep, %args ) = @_;
    my $csv = Text::CSV_XS->new(
        {
            binary         => 1,
            sep_char       => $sep,
            auto_diag      => $args{auto_diag} // 1,
            blank_is_undef => 1,
        }
    );
    die "Cannot use CSV: " . Text::CSV_XS->error_diag() unless $csv;
    return $csv;
}

##########################################################################
# _sample_csv_lines($csv_file, $max_lines)
#
# Returns up to $max_lines non-empty lines for separator detection.
##########################################################################
sub _sample_csv_lines {
    my ( $self, $csv_file, $max_lines ) = @_;
    $max_lines //= 6;

    my $handle = path($csv_file)->openr_utf8;
    my @lines;
    while ( defined( my $line = <$handle> ) ) {
        next if $line =~ /^\s*$/;
        chomp $line;
        push @lines, $line;
        last if @lines >= $max_lines;
    }
    $handle->close;
    return \@lines;
}

##########################################################################
# _candidate_score_for_sep($lines, $sep)
#
# Scores a separator candidate based on consistent parsed column counts.
##########################################################################
sub _candidate_score_for_sep {
    my ( $self, $lines, $sep ) = @_;
    my $parser = eval { $self->_csv_parser_for_sep( $sep, auto_diag => 0 ) };
    return undef if !$parser;

    my @counts;
    for my $line ( @{$lines} ) {
        my $ok = $parser->parse($line);
        return undef if !$ok;
        my @fields = $parser->fields();
        return undef if !@fields;
        push @counts, scalar(@fields);
    }

    my $header_count = $counts[0];
    return undef if !defined $header_count || $header_count < 2;

    for my $count (@counts) {
        return undef if $count != $header_count;
    }

    return {
        sep         => $sep,
        column_count => $header_count,
        sample_rows  => scalar(@counts),
    };
}

##########################################################################
# detect_csv_separator($csv_file)
#
# Attempts to infer the separator from a small file sample.
##########################################################################
sub detect_csv_separator {
    my ( $self, $csv_file ) = @_;
    my $lines = $self->_sample_csv_lines($csv_file);
    die "Input CSV has no header row\n" unless @{$lines};

    my @candidates =
      grep { defined $_ }
      map { $self->_candidate_score_for_sep( $lines, $_ ) } @DETECTABLE_SEPARATORS;

    die "Could not infer a field separator for '$csv_file'. Please pass --sep explicitly.\n"
      unless @candidates;

    @candidates = sort {
             $b->{column_count} <=> $a->{column_count}
          || $b->{sample_rows}  <=> $a->{sample_rows}
    } @candidates;

    my $best = $candidates[0];
    my @tied = grep {
           $_->{column_count} == $best->{column_count}
        && $_->{sample_rows}  == $best->{sample_rows}
    } @candidates;

    die "Ambiguous field separator for '$csv_file'. Please pass --sep explicitly.\n"
      if @tied > 1;

    return $best->{sep};
}

##########################################################################
# _read_csv_data($csv_file, $sep)
#
# Reads a CSV file and returns an arrayref of hashrefs keyed by the header row.
##########################################################################
sub _read_csv_data {
    my ( $self, $csv_file, $sep ) = @_;
    $sep = defined $sep ? $sep : $self->detect_csv_separator($csv_file);
    my $csv_handle = path($csv_file)->openr_utf8;
    my $csv = $self->_csv_parser_for_sep($sep);

    my $header = $csv->getline($csv_handle)
      or die "Input CSV has no header row\n";
    $csv->column_names(@$header);

    my $records = $csv->getline_hr_all($csv_handle);
    $csv_handle->close;
    return {
        header  => $header,
        records => $records,
    };
}

##########################################################################
# _analyze_csv_file($csv_file, $schema, $sep)
#
# Reads a CSV file and returns header + per-row validation results.
##########################################################################
sub _analyze_csv_file {
    my ( $self, $csv_file, $schema, $sep ) = @_;
    die "Schema is required for CSV validation\n"
      unless defined $schema && ref($schema) eq 'HASH';

    my $csv_data   = $self->_read_csv_data( $csv_file, $sep );
    my $validator  = $self->_build_json_validator($schema);
    my @row_results;

    for my $i ( 0 .. $#{ $csv_data->{records} } ) {
        my $raw_record =
          { %{ $csv_data->{records}->[$i] } };
        my $record =
          $self->_normalize_record_for_schema( $csv_data->{records}->[$i], $schema );
        my $errs = $self->_validation_messages_for_record( $validator, $record );

        push @row_results,
          {
            row    => $i + 1,
            ok     => @$errs ? 0 : 1,
            raw    => $raw_record,
            errors => $errs,
          };
    }

    return {
        header => $csv_data->{header},
        rows   => \@row_results,
    };
}

##########################################################################
# _normalize_record_for_schema($record, $schema)
#
# Applies null normalization and numeric coercion according to the schema.
##########################################################################
sub _normalize_record_for_schema {
    my ( $self, $record, $schema ) = @_;
    my %normalized = %{$record};

    for my $col ( keys %{ $schema->{properties} } ) {
        next unless exists $normalized{$col};
        my $prop = $schema->{properties}->{$col};
        $normalized{$col} = $self->normalize_csv_value( $normalized{$col} );
        if ( defined $prop->{_coerce} && $prop->{_coerce} ) {
            $normalized{$col} =
              $self->dotify_and_coerce_number( $normalized{$col} );
        }
    }

    return \%normalized;
}

##########################################################################
# _validation_messages_for_record($validator, $record)
#
# Returns stringified validation messages for a record.
##########################################################################
sub _validation_messages_for_record {
    my ( $self, $validator, $record ) = @_;
    return [ map { "$_" } $validator->validate($record) ];
}

##########################################################################
# normalize_csv_value($val)
#
# Converts CSV null markers to undef.
##########################################################################
sub normalize_csv_value {
    my ( $self, $val ) = @_;
    return undef unless defined $val;
    return undef if $val eq '\\N';
    return $val;
}

##########################################################################
# dotify_and_coerce_number($val)
#
# Converts a CSV string value to a number if it looks numeric.
# Returns undef if the value is empty or "\N".
##########################################################################
sub dotify_and_coerce_number {
    my ( $self, $val ) = @_;
    return undef unless ( defined $val && $val ne '' && $val ne '\\N' );
    ( my $tr_val = $val ) =~ tr/,/./;
    return looks_like_number($tr_val) ? 0 + $tr_val : $val;
}

=head1 AUTHOR

Written by Manuel Rueda, PhD. Info about CNAG can be found at L<https://www.cnag.eu>.

=head1 LICENSE

This module is free software; you may redistribute it and/or modify it under the same terms as Perl itself.

=cut

1;
