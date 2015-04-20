
my @args = @ARGV;
my $src_dir = $args[0];
my $des_dri = $args[1];
my $extensions = $args[2];

# print parameters
print "$_\n" for @args;

my $extension_regexp = qr/(?<=.\.)mp4|avi|rmvb|wmv/;
my @files;
my $cnt = 0;

my @t = get_files($src_dir);

print "$cnt\n";
print "$_\n" for @t;

#print "@files\n";
#for my $f (@files){
#	print "$f\n";
#}

sub get_files{
	my $diretory = shift;
	stat @temp;
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
	return @temp;
	#print "==================================\n";
}












