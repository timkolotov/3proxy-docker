# We can configure nservers to avoid unsafe gethostbyname() usage
nserver 8.8.8.8
nserver 8.8.4.4
nserver 1.1.1.1

# nscache is good to save speed, traffic and bandwidth
nscache 65536
# Here we can change timeout values3
timeouts 1 5 30 60 180 1800 15 60

# include passwd file wieh users
users $/etc/3proxy/passwd

log /dev/stdout
logformat "- +_L%t.%.  %N.%p %E %U %C:%c %R:%r %O %I %h %T"

# internal and external interfaces
internal __INET__
external __INET__

# http proxy configuration
flush
auth strong
maxconn 32
# allow only HTTP and HTTPS traffic.
allow * * * 80-88,8080-8088 HTTP
allow * * * 443,8443 HTTPS
proxy -n -p__HTTP_PORT__

# socks5 proxy configuration
flush
auth strong
maxconn 32
socks -p__SOCKS_PORT__

setgid __NOBODY__
setuid __NOBODY__
