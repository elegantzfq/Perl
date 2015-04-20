
my @args = @ARGV;
my $src_dir = $args[0];
my $des_dir = $args[1];
my $extensions = $args[1];

# print parameters
print "$_\n" for @args;

my $extension_regexp = qr/(?<=.\.)$extensions/;
#print "$extension_regexp\n";
#my $cnt = 0;

my ($files,$cnt) = get_files($src_dir);

#print "$cnt\n";
#print "$_\n" for @$t;

$filtered_files = extension_filter($files,$extension_regexp);

print "$_\n" for @$filtered_files;

sub extension_filter{
	my $files = shift;
	my $reg= shift;
	my @filterd;
	my $cnt = 0;
	
	for my $file (@$files){
		if(-f "$file"){
			if($file =~ $reg){
				@filterd[$cnt++] = $file;
			}
		}else{
			print "error:input is not a legal file.";
			return;
		}
	}
	if($cnt > 0){
		return \@filterd;
	}else{
		return 0;
	}
}

sub get_files{
	my $diretory = shift;
	stat @temp;
	stat $cnt;
	opendir(my $dh,"$diretory")
		or die "Cannot open '$diretory' for reading: $!";
	my @entries = grep {!/^\./} readdir($dh);
	#print "@entries\n";
	closedir $dh
		or die "Cannot close '$diretory': $!";
	for my $entry (@entries){
		$file = "$diretory/$entry";
		#print "$file\n";
		if(-f "$file"){
			#print "$file\n";
			@temp[$cnt++] = "$file";
		}
		if(-d "$file"){
			get_files($file);
		}
	}
	return \@temp,$cnt;
	#print "==================================\n";
}












