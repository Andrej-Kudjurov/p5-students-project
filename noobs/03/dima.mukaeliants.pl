#!/usr/bin/perl -w
use strict;

my $res = "";
my $errType = undef;
my $entry = '';
my $dataString = '';
my @arr = ();
my @resArr = ();
my %hash = ();
#����� ��������� ���� ����� ��������� �� ������� ���������� ������
#if(){print "!!!	Too much Entry point."}		������� ��� ������ ��������
my $test_file_path = $ARGV[0];
open( FH, "<", "$test_file_path") or die "Can not open test file: $!";
while ( defined(my $file_string = <FH>)) {
	if($file_string =~ m/[\w=>,]+/){
		if(!$entry){
			$file_string =~ s/\s*//g;
			$entry = $file_string;
		}
		else{
			$dataString .= $file_string;
		}
		#print "OK		$entry\n$dataString\n"
	}
	else{
		#print "NO\n";
	}
}
close ( FH );

if(!$entry || !$dataString){
	$res = "error";
	$errType = "Incorrect Data in this file!";
}
elsif($entry !~ m/^\s*?\w+?\s*?$/){
	$res = "error";
	$errType = "Incorrect Entry point.";
}
else{
	@arr = split(',',$dataString);
	for(my $i=0;$i < scalar(@arr);$i++){
		if($arr[$i]!~/\s*?\w+?\s*?=>\s*?\w+?\s*?/){
			$res = "error";
			$errType = "Incorrect Hash. [wrong way data: '$arr[$i]']";
			last;
		}
		elsif($arr[$i]=~/.+?=.+?=.+?/){
			$res = "error";
			$errType = "Incorrect Hash. [two or more '=>' at one hash waypoint: '$arr[$i]']";
			last;
		}
		elsif(!$res){
			$arr[$i] =~ s/\s*//g;
		}
	}
};
if(!$res){
	#print "My HASH:\n";
	for(my $i=0; $i<scalar(@arr); $i++){
		my($key,$val) = split('=>',$arr[$i]);
		$hash{$key}=$val;
		#print "$key	=>	$val\n";
	}
	@resArr = ($entry);
	my $tmpKey = '';
	my @tmpArr = ();
	while(scalar(@resArr)<=(scalar(keys %hash))){
		@tmpArr = @resArr;
		$tmpKey = pop @tmpArr;
		if(exists $hash{$tmpKey}){
			if( index( scalar( "#".join("#", @resArr)."#"), ("#".$hash{$tmpKey}."#"))>=0){
				push (@resArr, $hash{$tmpKey});
				$res = 'looped';
				$errType = "Cicle found.";
				last;
			}
			push (@resArr, $hash{$tmpKey});
		}
		else{
			$res = 'error';
			$errType = "Couldn't find next waypoint in the Hash. Way is interrupted: ".join('-',@resArr)."-!!!";
			last;
		}
	}
}		
if(!$res || $res=~/^looped/){$res = join('-',@resArr)."\n".$res."\n"};

print STDOUT "$res\n";
print STDERR "ERROR: $test_file_path : $errType \n\n" if ($res=~/(error|looped)/);	

























