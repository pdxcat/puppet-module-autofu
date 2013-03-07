# Autofu

This puppet module installs a pseudo-service for Ubuntu called "autofu". It
was designed to plug a hole in autofs functionality when a solaris server
running a legacy FTP service needed to be replaced. Solaris autofs is a heck
of a lot more full-featured than linux as it turns out, and if you don't
have the option of restructuring your storage to conform to linux autofs'
limitations, you write hackjob "services" to do the job. Hail autofu.

Thanks to JeroenHoek on ubuntuforums.org for the idea and code example.
http://ubuntuforums.org/showthread.php?t=1389291

Example usage:

    autofu::mount { 'ftpserver':
      mountpoint => '/ftp',
      location   => 'ftpserver.cat.pdx.edu:/volumes/ftp',
      options    => 'rw,hard,intr,nosuid',
    }
