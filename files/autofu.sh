#/bin/sh
# Check every X seconds (60 is a good default):
INTERVAL=300
CONFFILE='/etc/auto.fu'
# The shares that need to be mounted:

while true; do
  while read MOUNTPOINT OPTIONS LOCATION; do
    if echo $OPTIONS | grep '^[^-]'; then
      LOCATION=$OPTIONS
      OPTIONS=
    else
      OPTIONS="-o `echo $OPTIONS | cut -b 2-`"
    fi
    FILESERVER=`echo $LOCATION | sed 's/\(.*\):.*/\1/'`
    SHARE=`echo $LOCATION | sed 's/.*:\(.*\)/\1/'`
    ping -c 1 "$FILESERVER" 1>/dev/null 2>&1
    if [ $? -eq 0 ]; then
      mount | grep -E "^${LOCATION} on ${MOUNTPOINT} " 1>/dev/null 2>&1
      if [ $? -ne 0 ]; then
        # NFS mount not mounted, attempt mount
        logger "$LOCATION not mounted; attempting mount"
        mount -t nfs $OPTIONS ${LOCATION} ${MOUNTPOINT}
      fi
    else
      # Fileserver is down.
      logger "$FILESERVER is down. Mount attempt aborted for $LOCATION"
      mount | grep -E "^$LOCATION on .*$" 1>/dev/null 2>&1
      if [ $? -eq 0 ]; then
        # NFS mount is still mounted
        logger "Cannot reach ${FILESERVER}, NFS share ${SHARE} likely borked"
      fi
    fi
  done < $CONFFILE
  sleep $INTERVAL
done

# Example upstart job:
#
# # autofu - mount NFS shares on fileserver, if present
#
# description "Mount NFS-shares"
#
# start on (filesystem)
# respawn
#
# exec /usr/local/bin/mount_nfs_shares
