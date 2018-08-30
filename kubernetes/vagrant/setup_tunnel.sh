sudo ip link add tunnel0 type gretap local <local> remote <remote>
sudo ifconfig tunnel0 up
sudo brctl addif <br> tunnel0
