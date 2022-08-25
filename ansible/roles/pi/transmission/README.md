This makes transmission-daemon run as a systemd service. transmission binds over a bridge interface, which traffic is routed to the wireguard interface, and traffic is then masqueraded by iptables, in the postrouting step.

```
[ [ transmission ] - [ bridge ] - [ wg0 ] ] -> ( internet )
```
