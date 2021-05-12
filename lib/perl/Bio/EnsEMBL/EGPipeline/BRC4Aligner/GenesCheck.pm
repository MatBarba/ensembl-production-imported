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

package Bio::EnsEMBL::EGPipeline::BRC4Aligner::GenesCheck;

use strict;
use warnings;

use base ('Bio::EnsEMBL::EGPipeline::Common::RunnableDB::Base');

sub run {
  my ($self) = @_;

  # Check that there are genes!
  my $dba = $self->core_dba();
  if ($self->has_genes($dba)) {
    $self->dataflow_output_id({ "has_genes" => 1 }, 2);
  } else {
    $self->dataflow_output_id({ "has_genes" => 0 }, 3);
  }
}

1;
