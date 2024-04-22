set fish_greeting ""

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Use bass to have fish inherit system-wide envvars on startup, from bash
bass source /etc/profile
