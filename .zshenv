export PATH=$PATH:/usr/local/bin/
export PATH=$PATH:$HOME/bin/

KERNEL=`uname`
# OsX specific stuff
if [ $KERNEL = "Darwin" ]; then
  # macports
  export PATH=/opt/local/bin:/opt/local/sbin/:$PATH
  export MANPATH=/opt/local/share/man:$MANPATH
fi
