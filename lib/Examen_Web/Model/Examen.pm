package Examen_Web::Model::Examen;
use Mojo::Base -base;
use List::Util qw/first/;

# A revisar amb exemple:
# https://github.com/kraih/mojo-pg/tree/master/examples/blog

has 'db';

sub table {
	my ($self, $table) = @_;
	return $self->db->resultset($table);
}

sub find_pregunta {
	my ($self, $id) = @_;
	return $self->db->resultset('Pregunte')->find({ id_pregunta => $id });
}

sub find_resposta {
	my ($self, $id) = @_;
	return $self->db->resultset('Resposte')->find({ id	=> $id });
}

sub find_respostes {
	my ($self, $id) = @_;
	return $self->db->resultset('Resposte')->search_rs({ id_pregunta	=> $id });
}

sub find_bloc {
	my ($self, $bloc) = @_;
	return $self->db->resultset('Pregunte')->search_rs(
			{ bloc => $bloc },
			{ order_by => {-asc => 'pregunta_cat'} },
	);
}

sub find_examen {
	my ($self, $examen) = @_;
	return $self->db->resultset('Pregunte')->search_rs({ examen   => '1'}) if $examen eq 1;
	return $self->db->resultset('Pregunte')->search_rs({ examen_2 => '1'}) if $examen eq 2;
}

sub count_examen {
	my ($self, $examen) = @_;
	return $self->db->resultset('Pregunte')->search_rs({ examen   => '1'})->count if $examen eq 1;
	return $self->db->resultset('Pregunte')->search_rs({ examen_2 => '1'})->count if $examen eq 2;
}

sub count_bloc {
	my ($self, $bloc) = @_;
	return $self->db->resultset('Pregunte')->search_rs({ bloc => $bloc})->count;
}

sub count_examen_bloc {
	my ($self, $examen, $bloc) = @_;
	return $self->db->resultset('Pregunte')->search_rs({ examen   => '1' })->search({ bloc => $bloc})->count if $examen eq 1;
	return $self->db->resultset('Pregunte')->search_rs({ examen_2 => '1' })->search({ bloc => $bloc})->count if $examen eq 2;
}

# Mirar existeix la permutació
sub is_permuta {
	my ($self, $id_permuta) = @_;
	my @permutas = $self->db->resultset('Permuta')->get_column( 'id_permuta' )->all;
	return 1 if first {$_ eq $id_permuta} @permutas;
	return 0;
}

sub permutacio {
	my ($self, $id_permuta) = @_;
	return $self->db->resultset('Permuta')->find({ id_permuta => $id_permuta});
}

sub permutacions {
	my ($self, $id_permuta) = @_;
	return $self->db->resultset('Permutacion')->search({ id_permuta => $id_permuta});
}

1;
# vim: tabstop=2
