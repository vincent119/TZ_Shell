#!/bin/bash
####################################
#
#
#
#
#
#
####################################






F_FTP(){

ftp -in 192.168.40.51 << end
user reportsync travelzen
bin
mput *.import
bye
end


}
