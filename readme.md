# Done

A simple helper script to send a notification when a long-running command completes

## Installation

### Requirements

* ZSH 5.0+

### [Zulu](https://github.com/zulu-zsh/zulu)

```sh
zulu install done
```

### Manual

Simply source the `done.zsh` script in your `.zshrc`.

```sh
git clone https://github.com/molovo/done
echo "source $PWD/done/done.zsh" >> ~/.zshrc
```

## Usage

One the script is sourced, it handles everything for you. The time limit before a notification is triggered can be set by using the `DONE_MAX_EXEC_TIME` environment variable.

## License

Copyright (c) 2017 James Dinsdale <hi@molovo.co> (molovo.co)

Done is licensed under The MIT License (MIT)

## Team

* [James Dinsdale](http://molovo.co)
