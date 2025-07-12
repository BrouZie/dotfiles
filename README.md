# Til KasperBby

### Nedlasting av repository:

Du kan starte med å clone dotfiles!
´´´bash
git clone https://github.com/BrouZie/dotfiles.git
´´´
- Denne kan plasseres der du selv ønsker

### Viktige nedlastinger:

Aller først:
```bash
sudo dnf tmux
```

Deretter trenger vi en jøvla tmux pluginmanager:
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

(Valgfritt):
git pull nyeste neovim-homebrew - dette er valgfritt ettersom du
kan velge å stowe nvim config fra dotfiles på lik linje som tmux

- Uavhengig av metode bør du oppdatere nvim for at tmux skal
  funke best mulig

### Stow configs:

Aller først bør du gjør som følger:
(kan skippes hvis nvim er up to date)

- Slett din nåværende nvim config:
```bash
rm -rf ~/.config/nvim
```

- cd inn i repo ´´dotfiles´´ og kjør kommando:
```bash
stow nvim
```
Åpne nvim og sørg for at alt er lastet ned av plugins
```:Lazy``` vil åpne pluginmanager for nvim


- Nå kan tmux legges til også! (samme som med nvim):
```bash
stow tmux
```
Åpne tmux ved å skrive ´´´tmux´´´ i terminalen!

Trykk på: "'ctrl + space' I" (NB: stor I, ikke liten)

### Tmux info:
