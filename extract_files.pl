
use File::Copy;
use warnings;

my @args = @ARGV;
my $src_dir = $args[0];
my $des_dir = $args[1];
my $extensions = $args[2];
my $copy_or_move = $args[3];

# print parameters
print "$_\n" for @args;

my $extension_regexp = qr/(?<=.\.)$extensions/;

my ($files,$cnt) = get_files($src_dir);
$filtered_files = extension_filter($files,$extension_regexp);

if($copy_or_move == "move"){
	move_files_to_dest($filtered_files,$des_dir);
}else if($copy_or_move == "copy"){
	copy_files_to_dest($filtered_files,$des_dir);
}else{
	print "error: Wrong operation type.";
}

# use File::Copy to move
sub move_files_to_dest{
	$files = shift;
	$ds = shift;
	for $file (@$files){
		$filename = extract_filename_from_dir($file);
		move("$file","$ds/$filename");
	}
}

sub copy_files_to_dest{
	$files = shift;
	$ds = shift;
	for $file (@$files){
		$filename = extract_filename_from_dir($file);
		copy("$file","$ds/$filename");
	}
}

sub extract_filename_from_dir{
	my $dir = shift;
	my $reg = qr/(?<=\/)?[^\/]+$/;
	if($dir =~ $reg){
		$filename = $&;
		return $filename;
	}else{
		return "";
	}
}

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

# must use / instead of \ in the path
sub file_cp_test{
	copy("C:/Work/Education/Perl/VisualizingData.pdf","C:/Work/Education/VisualizingData.pdf")  or die "Copy failed: $!";
}
