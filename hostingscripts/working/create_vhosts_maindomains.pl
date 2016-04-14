#!/usr/bin/perl -w

#filename create_vhosts_maindomain.pl

use File::Copy;
use File::Path;

### READ ME ####
# *Script checks to see if /etc/httpd/conf/vhosts/maindomains/domainname exists
# *If it exists, exits. If not...
# 	
#  Normally in apache config you list all the virtual domains in the main config. I have set out a folder called vhosts, that each domain has its own vhost  file.
#  This ensures better setup and less likely to break the main config file.
#
# *Create virtual host file for apache at  /etc/httpd/conf/vhosts/
# *Check to see if apache log paths exist /var/log/httpd/maindomains/domain exists, if it does exit, else..
# *Create the path and log files domain_error_log and domain_access_log, path permisions 0755 and file permissions are currently 0644, owner root:root
# *Last part of the script inserts the info that makes up the vhost file for apache.

print "Enter domain:- ";
$domain=<STDIN>;
chomp $domain;

#maybe use combined paths into 1 variable, tidy up script.

### DECLARE VARS ###
$basevhost='/etc/httpd/conf/vhosts/maindomains/';
$path_maindomain = "$basevhost$domain";
$path_maindomain_logs ='/var/log/httpd/maindomains/'.$domain;
$error_log = '/'.$domain.'_error_log';
$access_log = '/'.$domain.'_access_log common';
$null ='';

#If the domain doesnt already exist..... /etc/httpd/conf/vhosts/maindomains/$domain ###

if ( -d $path_maindomain)
	{
		print "$path_maindomain Already exists, Exiting\n";
		exit 0;
	}
else
	{

		$file = "
		<VirtualHost *:80>\n
	        DocumentRoot \/home\/www\/html\/maindomains\/$domain\/public_html\/\n
	        ServerName $domain\n
		ServerAlias www.$domain
	        ErrorLog logs\/maindomains\/$domain\/$domain"."_error_log\n
	        CustomLog logs\/maindomains\/$domain\/$domain"."_access_log common\n
		</VirtualHost>\n
		";
		
		#### CONFIRM AND CREATE LOG FILES ###

                if ( -d $path_maindomain_logs)

                        {
                                print "Path $path_maindomain_logs already exists, skipping...\n\n";

                                ##print $path_subdomain_logs.$error_log ;
                        }

                else
                        {
                                mkdir ( $path_maindomain_logs, 0755 );
                                print "Path $path_maindomain_logs does not exist, created with 0755 Permissions\n\n";

                                if( -f $path_maindomain_logs.$error_log )

                                        {
                                                print "Error log $error_log exists, skipping...";
                                        }
                                else
                                        {

                                                open(LOG1,">", "$path_maindomain_logs$error_log");
                                                print LOG1 $null;
                                                print "$path_maindomain_logs$error_log doesnt exist, creating...\n\n";
                                        }

                                if( -f $path_maindomain_logs.$access_log )

                                        {
                                                print "Error log $access_log exists, skipping...\n\n";
                                        }

                                else
                                        {

                                                open(LOG2,">", "$path_maindomain_logs$access_log");
                                                print LOG2 $null;
                                                print "$path_maindomain_logs$access_log doesnt exist, creating...\n\n";
					}
			}
			
	
		#copy($ftp2,$ftp."/".$domain)or die "Cannot copy vsftpd file";
		open(FTP,">",  '/etc/httpd/conf/vhosts/maindomains/'.$domain.'.conf');
		print FTP $file;

		print "VirtualHost file created:-\n";
		print  '/etc/httpd/conf/vhosts/maindomains/'.$domain.'.conf';
		print "\n DONT FORGET TO RELOAD OR RESTART APACHE\n";

		exit;

	}
