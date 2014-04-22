
tmp_file=`mktemp`

grep -v '^# End of file' /etc/security/limits.conf > $tmp_file
cat $tmp_file > /etc/security/limits.conf

echo '
@sapsys         hard    nofile          32800
@sapsys         soft    nofile          32800
@dba            hard    nofile          32800
@dba            soft    nofile          32800

# End of file' >> /etc/security/limits.conf


