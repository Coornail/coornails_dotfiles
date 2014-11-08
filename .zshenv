export PATH=$PATH:/usr/local/bin/
export PATH=$PATH:$HOME/bin/

KERNEL=`uname`
skip_global_compinit=1

# OsX specific stuff
if [ $KERNEL = "Darwin" ]; then
  # macports
  export PATH=/opt/local/bin:/opt/local/sbin/:$PATH
  export MANPATH=/opt/local/share/man:$MANPATH
fi
