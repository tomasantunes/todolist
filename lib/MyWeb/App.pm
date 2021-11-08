package MyWeb::App;
use Dancer2;
use strict;
use DBI;

our $VERSION = '0.1';

my $dbh = DBI->connect('dbi:Pg:dbname=todolist;host=localhost','user','password',{AutoCommit=>1,RaiseError=>1,PrintError=>0});

if (!defined $dbh) {
    die "Cannot connect to database!\n";
}

get '/' => sub {
    template 'index' => { 'title' => 'ToDoList' };
};

get '/tasks/list' => sub {
    my $sth = $dbh->prepare("SELECT * FROM tasks");
    my $result = $sth->execute();
    # $sth->finish();
    my $ary_ref = $sth->fetchall_arrayref;
    return encode_json($ary_ref);
};

get '/tasks/add' => sub {
    my $title = param('title');
    my $isDone = param('isDone');
    my $sth = $dbh->prepare("INSERT INTO tasks (title, isDone) values (?, ?)");
    $sth->execute($title, $isDone) or die $DBI::errstr;
    $sth->finish();
    return 'OK';
};

get '/tasks/delete' => sub {
    my $id = param('id');
    my $sth = $dbh->prepare("DELETE FROM tasks WHERE id = ?");
    $sth->execute($id);
    $sth->finish();
    return 'OK'
};

get '/tasks/update' => sub {
    my $id = param('id');
    my $title = param('title');
    my $isDone = param('isDone');
    my $sth = $dbh->prepare("UPDATE tasks SET title = ?, isDone = ? WHERE id = ?");
    $sth->execute($title, $isDone, $id);
    $sth->finish();
    return 'OK'
};

true;
