=head1 LICENSE

See the NOTICE file distributed with this work for additional information
regarding copyright ownership.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

package Bio::EnsEMBL::EGPipeline::BRC4Aligner::WriteMetadata;

use strict;
use warnings;
use base ('Bio::EnsEMBL::EGPipeline::Common::RunnableDB::Base');

use Capture::Tiny ':all';
use Path::Tiny qw(path);
use File::Basename qw(dirname);
use File::Spec::Functions qw(catdir);
use JSON;

sub write_output {
  my ($self) = @_;

  my $results_dir = $self->param_required('results_dir');
  my $meta_file = catdir($results_dir, 'metadata.json');

  my %metadata = (
    studyName => $self->param_required("study_name"),
    sraQueryString => $self->param_required("sample_name"),
  );
  if (defined $self->param("is_paired")) {
    $metadata{hasPairedEnds} = $self->param('is_paired') ? JSON::true : JSON::false;
  }
  if (defined $self->param("is_stranded")) {
    $metadata{isStrandSpecific} = $self->param('is_stranded') ? JSON::true : JSON::false;

    if ($self->param('is_stranded')) {
      my $strand_direction = $self->param('strand_direction');
      $metadata{strandDirection} = $strand_direction;
    }
  }
  if (defined $self->param("dnaseq")) {
    $metadata{dnaseq} = $self->param('dnaseq') ? JSON::true : JSON::false;
  }

  open my $meta_fh, '>', $meta_file;
  print $meta_fh encode_json(\%metadata);
  close $meta_fh;
}
1;

