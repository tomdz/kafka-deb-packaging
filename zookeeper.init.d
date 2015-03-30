#! /bin/sh
### BEGIN INIT INFO
# Provides:          zookeeper
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: centralized coordination service
# Description:       ZooKeeper is a centralized service for maintaining
#                    configuration information, naming, providing distributed
#                    synchronization, and providing group services.
### END INIT INFO

# Authors:            Josh Skidmore <josh@josh.sc>
#                     Brandon Brown <brandon@bbrownsound.com>
#                     Brandon Froehlich <brandon@froeh.org>
#                     Taylor Brockman <taylor.brockman@gmail.com>

# Revision History:   2015-02-12 - Initial commit
# 	         2015-03-06 - Porting to nop-bigress
#                2015-03-20 - Contribution to tomdz/kafka-deb-packaging
#                2015-03-30 - Changed PID directory after running in AWS prod

# Variables
PATH=$PATH
DESC="Apache Zookeeper Server"
NAME=zookeeper
DAEMON=/usr/lib/kafka/bin/zookeeper-server-start.sh
PIDFILE=/var/run/zookeeper-server.pid
USER=app
CONFIG=/etc/kafka/zookeeper.properties
LOG=/var/log/zookeeper-server.log


# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.2-14) to ensure that this file is present
# and status_of_proc is working.
. /lib/lsb/init-functions


#
# Function that starts the daemon/service
#
do_start()
{
  # Return
  #   0 if daemon has been started
  #   1 if daemon was already running
  #   2 if daemon could not be started

  start-stop-daemon --chuid $USER --background --start --quiet --make-pidfile --pidfile $PIDFILE --no-close --startas $DAEMON -- $CONFIG >> $LOG 2>&1 || return 2
}


#
# Function that stops the daemon/service
#
do_stop()
{
  #   0 if daemon has been stopped
  #   1 if daemon was already stopped
  #   2 if daemon could not be stopped
  #   other if a failure occurred

  start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 --pidfile $PIDFILE
  RETVAL="$?"

  # Many daemons don't delete their pidfiles when they exit.
  rm -f $PIDFILE
  return "$RETVAL"
}


case "$1" in
  start)
  log_daemon_msg "Starting $DESC" "$NAME"
  do_start
  case "$?" in
    0|1) log_end_msg 0 ;;
    2) log_end_msg 1 ;;
  esac
  ;;

  stop)
  log_daemon_msg "Stopping $DESC" "$NAME"
  do_stop
  case "$?" in
    0) log_end_msg 0 ;;
    1|2) log_end_msg 1 ;;
  esac
  ;;

  # status)
  # status_of_proc "$DAEMON" "$NAME" && exit 0 || exit $?
  # ;;

  #reload|force-reload)
  #
  # If do_reload() is not implemented then leave this commented out
  # and leave 'force-reload' as an alias for 'restart'.
  #
  #log_daemon_msg "Reloading $DESC" "$NAME"
  #do_reload
  #log_end_msg $?
  #;;

  restart|force-reload)
  #
  # If the "reload" option is implemented then remove the
  # 'force-reload' alias
  #
  log_daemon_msg "Restarting $DESC" "$NAME"
  do_stop
  case "$?" in
    0|1)
    do_start
    case "$?" in
      0) log_end_msg 0 ;;
      1) log_end_msg 1 ;; # Old process is still running
      *) log_end_msg 1 ;; # Failed to start
    esac
    ;;
    *)
    # Failed to stop
    log_end_msg 1
    ;;
  esac
  ;;
  *)
  #echo "Usage: $SCRIPTNAME {start|stop|restart|reload|force-reload}" >&2
  echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload}" >&2
  exit 3
  ;;
esac

:
