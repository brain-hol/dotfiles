# Dotfiles

Use [GNU Stow](https://www.gnu.org/software/stow/) to load or unload each feature as needed.

## Quick Snippets

Load feature

```shell
stow -d $HOME/Source/dotfiles -t $HOME -S <feature_name>
```

Unload feature

```shell
stow -d $HOME/Source/dotfiles -t $HOME -D <feature_name>
```
