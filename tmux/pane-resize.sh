
#!/bin/bash

cat << EOF >> ~/.tmux.conf

# Resize panes with Ctrl + arrow keys
bind -n C-Left resize-pane -L 5
bind -n C-Right resize-pane -R 5
bind -n C-Up resize-pane -U 5
bind -n C-Down resize-pane -D 5
EOF

echo "Configuration added to ~/.tmux.conf"
echo "Restart tmux or run 'tmux source-file ~/.tmux.conf' to apply changes"
