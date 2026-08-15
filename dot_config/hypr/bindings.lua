o.bind(
  "code:66",
  "Talon toggle listen",
  [[sh -c 'printf "%s\n" "from talon import actions; actions.speech.toggle()" | "$HOME/.talon/bin/repl" >/dev/null']]
)

-- Disable SUPER + scroll workspace switching from Omarchy defaults.
hl.unbind("SUPER + mouse_down")
hl.unbind("SUPER + mouse_up")

-- Suspend directly instead of opening Omarchy's power menu.
hl.unbind("XF86PowerOff")
o.bind("XF86PowerOff", "Suspend", "systemctl suspend", { locked = true })
