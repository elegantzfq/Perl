
use File::Copy;
#use warnings;

my @args = @ARGV;				# get all arguments
my $src_dir = $args[0];			# source directory
my $des_dir = $args[1];			# destination directory
my $extensions = $args[2];		# extensions to match
my $copy_or_move = $args[3];	# indicates copy or move

# print parameters
print "\n***************\tParameters\t****************\n";
print "$_\n" for @args;
print "***************\tEnd of Parameters\t****************\n\n";

# check parameter
if(! (-d "$des_dir" && -d $src_dir ) ){
	print "the source/destination directory does not exist.\n\n";
	exit -1;
}

if($extensions eq "*"){
	$extensions = "[^\.,/,\\,:]+";
}else{
	$extensions =~ s/\|/\$\|/g;
}

my $extension_regexp = qr/(?<=.\.)($extensions$)/;

my ($files,$cnt) = get_files($src_dir,$extension_regexp);
print "matched files: $cnt\n\n";

do_copy_or_move($copy_or_move,$files,$des_dir);

print "\n";

sub do_copy_or_move{
	my $flag = shift;
	my $files_do = shift;
	my $des = shift;
	
	if($flag eq "move"){
		print "move files to $des...... \n\n";
		move_files_to_dest($files_do,$des);
	}elsif($flag eq "copy"){
		print "copy files to $des...... \n\n";
		copy_files_to_dest($files_do,$des);
	}else{
		print "error: Wrong operation type.";
	}
}

# use File::Copy to move
sub move_files_to_dest{
	$files = shift;
	$ds = shift;
	for $file (@$files){
		my $filename = extract_filename_from_dir($file);
		my $dest_file = "$ds/$filename";
		while(-f "$dest_file"){
			$dest_file =~ s/(?<=\/)*([^\/]+)(\.[^\/]+$)/$1_1$2/;
			#print "$dest_file\n";
		}
		print "copying $file to $ds\n";
		move("$file","$dest_file");
	}
}

sub copy_files_to_dest{
	$files = shift;
	$ds = shift;
	for $file (@$files){
		my $filename = extract_filename_from_dir($file);
		my $dest_file = "$ds/$filename";
		while(-f "$dest_file"){
			$dest_file =~ s/(?<=\/)*([^\/]+)(\.[^\/]+$)/$1_1$2/;
			#print "$dest_file\n";
		}
		print "copying $file to $ds\n";
		copy("$file","$dest_file");
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
	my $file = shift;
	my $reg= shift;
	
	if(-f "$file"){
		if("$file" =~ $reg){
			return 1;
		}else{
			return 0;
		}
	}else{
		print "error:input is not a legal file.";
		return -1;
	}
}

sub get_files{
	my $diretory = shift;
	my $reg = shift;
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
			if(extension_filter($file,$reg)){
				@temp[$cnt++] = "$file";
			}
		}
		if(-d "$file"){
			get_files($file,$reg);
		}
	}
	return \@temp,$cnt;
}
