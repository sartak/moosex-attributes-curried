# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name     'MooseX-Attributes-Curried';
all_from 'lib/MooseX/Attributes/Curried.pm';
githubmeta;

requires 'Moose'         => 0.74;
requires 'Sub::Exporter' => 0.01;

WriteAll;

