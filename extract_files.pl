
my @args = @ARGV;
my $counter = 0;
my $src_dir = $args[0];
my $des_dri = $args[1];
my $extensions = $args[2];

my $extension_regexp = qr/(?<=.\.)mp4|avi|rmvb|wmv/;
my @files;
my $cnt = 0;

get_files($src_dir);





print "$cnt\n";
#print "@files\n";
for my $f (@files){
	print "$f\n";
}

sub get_files{
	my $src = shift;
	
	opendir(my $dir,$src)
		or die "Cannot open '$src' for reading: $!";
	my @entries = grep {!/^\./} readdir($dir);
	#print "@entries\n";
	closedir $dir
		or die "Cannot close '$diretory': $!";
	for my $entry (@entries){
		$file = "$src/$entry";
		#print "$file\n";
		if(-f "$file"){
			#print "$file\n";
			@files[$cnt++] = "$file";
		}
		if(-d "$file"){
			get_files($file);
		}
	}
	#print "==================================\n";
}












