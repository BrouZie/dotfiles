# Til KasperBby

### Nedlasting av repository:

Du kan starte med å clone dotfiles!
```bash
git clone https://github.com/BrouZie/dotfiles.git
```
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

Aller først bør du gjøre som følger:
(kan skippes hvis nvim er up to date)

#### Slett din nåværende nvim config:
```bash
rm -rf ~/.config/nvim
```


#### cd inn i repo ´´dotfiles´´ og kjør kommando:
```bash
stow nvim
```
Åpne nvim og sørg for at alt er lastet ned av plugins
```:Lazy``` vil åpne pluginmanager for nvim



#### Nå kan tmux legges til også! (samme som med nvim):
```bash
stow tmux
```
Åpne tmux ved å skrive ```tmux``` i terminalen!

For å laste ned tmux plugins --> "ctrl + space + I"  (NB: stor I, ikke liten)



### Tmux info:

ANBEFALT!: Se informativ youtube video på tmux:
[Se den her:](https://www.youtube.com/watch?v=Yl7NFenTgIo)


Så og si alle keybinds starter med en <prefix>!

Default prefix er <ctrl-b>, men når du har fått oppdatert tmux vil din nye prefix
være <ctrl-space>

## Keybinds / Kommandoer

Default **prefix**: <kbd>Ctrl+b</kbd>.
Etter pluginsoppdatering!:

**Prefix**: <kbd>Ctrl+Space</kbd>

### Konfigurasjon & plugins (TPM)
- <kbd>prefix</kbd> + <kbd>r</kbd>: Reload tmux-config  
- <kbd>prefix</kbd> + <kbd>I</kbd>: Installer/oppdater plugins (TPM) :contentReference[oaicite:0]{index=0}  
- <kbd>prefix</kbd> + <kbd>U</kbd>: Oppdater alle plugins (TPM) :contentReference[oaicite:1]{index=1}  
- <kbd>prefix</kbd> + <kbd>Alt+u</kbd>: Avinstaller plugins ikke i listen (TPM) :contentReference[oaicite:2]{index=2}  

### Deling av vinduer (panes)
- <kbd>prefix</kbd> + <kbd>v</kbd>: Horisontal split (side-ved-side)  
- <kbd>prefix</kbd> + <kbd>s</kbd>: Vertikal split (oppe/nede)  

### Navigering
- <kbd>prefix</kbd> + <kbd>h</kbd>/<kbd>j</kbd>/<kbd>k</kbd>/<kbd>l</kbd>: Flytt fokus pane venstre/ned/opp/høyre  
- <kbd>Alt+h</kbd>: Forrige vindu  
- <kbd>Alt+l</kbd>: Neste vindu  

### Lukk & bytt størrelse
- <kbd>Ctrl+c</kbd>: Kill window  
- <kbd>Ctrl+q</kbd>: Kill pane  
- <kbd>prefix</kbd> + <kbd>h</kbd>/<kbd>j</kbd>/<kbd>k</kbd>/<kbd>l</kbd> (holdbar): Resize pane 5 celler i valgt retning  

### Nye vinduer & omdøping
- <kbd>prefix</kbd> + <kbd>Enter</kbd>: Nytt vindu  
- <kbd>prefix</kbd> + <kbd>%</kbd>: Rename vindu via prompt  

### Copy-mode & utklippstavle
- <kbd>prefix</kbd> + <kbd>Escape</kbd>: Gå inn i copy-mode  
- I copy-mode: <kbd>v</kbd> (start markering), <kbd>y</kbd> (kopier markering)  

### Plugin-spesifikke binds
- <kbd>prefix</kbd> + <kbd>o</kbd>: Åpne SessionX (session-manager) :contentReference[oaicite:3]{index=3}  
  - I SessionX: <kbd>Ctrl+p</kbd>/<kbd>Ctrl+n</kbd> naviger opp/ned i listen :contentReference[oaicite:4]{index=4}  
- <kbd>Ctrl+h</kbd>/<kbd>Ctrl+j</kbd>/<kbd>Ctrl+k</kbd>/<kbd>Ctrl+l</kbd>: SØmløs navigering mellom Vim-splitt og tmux-pane (vim-tmux-navigator) :contentReference[oaicite:5]{index=5}  
- <kbd>prefix</kbd> + <kbd>Ctrl+s</kbd>: Lagre sesjon (tmux-resurrect) :contentReference[oaicite:6]{index=6}  
- <kbd>prefix</kbd> + <kbd>Ctrl+r</kbd>: Gjenopprett sesjon (tmux-resurrect) :contentReference[oaicite:7]{index=7}  
- Automatisk lagring hver 15. minutt & automatisk restore ved oppstart (tmux-continuum)  




