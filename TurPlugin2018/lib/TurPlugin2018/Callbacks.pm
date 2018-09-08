package TurPlugin2018::Callbacks;
use strict;
use Encode 'decode';
use Data::Dumper;

sub post_save_entry {
    # enviroment and object data
    my ($cb, $app, $obj, $org_obj) = @_;

    # origin
    my $id = $obj->id;
    my $title = $obj->title;

    require MT::Entry;
    my $entry = MT::Entry->load($id);
       $entry->blog_id($obj->blog_id);
       $entry->status(MT::Entry::RELEASE());
       $entry->author_id($obj->author);
       $entry->title($obj->title);
       $entry->text($obj->text);

    require MT::Category;
    
    my @placement_s = $entry->__load_category_data;

    my $Temp_Category="";
    my $T_cat="";
    my $value = "";
    my @value = "";
    my $are;


    eval {
        if (defined($org_obj->id)) {

            for $value (@placement_s) {
                for $are (@$value){
                    $T_cat = MT::Category->load($are->[0]);
                    $Temp_Category = $Temp_Category . $T_cat->label . ",";
                }
            }

        $entry->keywords( $Temp_Category );
        $entry->save
        or die $entry->errstr;

            #debug用
            #doLog(Dumper @placement_s);


        }
    };
    if ( $@ ) {

            for $value (@placement_s) {
                for $are (@$value){
                    $T_cat = MT::Category->load($are->[0]);
                    $Temp_Category = $Temp_Category . $T_cat->label . ",";
                }
            }

        $entry->keywords( $Temp_Category );
        $entry->save
        or die $entry->errstr;

            #debug用
            #doLog(Dumper @placement_s);

    }
}

sub doLog {
    my ($msg, $class) = @_;
    return unless defined($msg);

    require MT::Log;
    my $log = new MT::Log;
    $log->message($msg);
    $log->level(MT::Log::DEBUG());
    $log->class($class) if $class;
    $log->save or die $log->errstr;

}

1;