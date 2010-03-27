# Ras3r #

Ras3r is a small MVC/P framework for AS3, inspired by [Ruby on Rails](http://rubyonrails.org/), implementing the [Supervising Controller/Presenter](http://martinfowler.com/eaaDev/SupervisingPresenter.html) pattern. Ras3r is built upon the [Sprouts](http://projectsprouts.org) project-generation tool for ActionScript/Flash/Flex/AIR.

## Why Ras3r? ##

* **MVC/P:** Ras3r implements the [Supervising Controller/Presenter](http://martinfowler.com/eaaDev/SupervisingPresenter.html) pattern as defined by Martin Fowler. Ras3r is [opinionated](http://gettingreal.37signals.com/ch04_Make_Opinionated_Software.php) software, where Views are meant to be declarative and "dumb", Controllers to be event handlers and delegates, and Models to be data validators and API consumers.
* **Lightweight:** Less than 70k for a fully-loaded .swf compiled with fl.controls.ComboBox, RadioButton, CheckBox, TextInput, Button and UILoader. The equivalent .swf built with Flex exceeds 400k.
* **Declarative:** Like Flex, Ras3r provides a declarative XML syntax for views. Unlike Flex, Ras3r also provides a declarative AS3 syntax for views.
* **Data Bindings:** Like Flex, Ras3r provides a simple declarative data-binding syntax.
* **Validations:** Like Flex, Ras3r provides in-UX validations. Unlike Flex, Ras3r applies validations in the Model layer, not in the View layer. The only exception: Like Flex, Ras3r provides a shortcut 'required="true"' syntax for simple view-defined validations.
* **REST:** Inpsired, and partially copied from, Ruby on Rails, Ras3r's ReactiveResource models provide a simple method for interacting with REST web services.
* **Runtime Views:** Ras3r XML views may be compiled into the .swf, or loaded and rendered at *runtime*.
* **BDD/TDD Unit Testing:** Thanks to [Sprouts](http://projectsprouts.org), Ras3r provides *two* automated testing suites:[AS3spec](http://github.com/fantasticmf/as3spec) and [AsUnit](http://github.com/lukebayes/asunit/).

## Quick Start ##

### Install Ruby, RubyGems ###

#### Windows XP, Vista, 7? ####

The [Ruby Installer for Windows](http://rubyinstaller.org/) provides Ruby and RubyGems.

#### OSX 10.5, 10.6 (Leopard, Snow Leopard) ####

[Xcode](http://developer.apple.com/technology/xcode.html) provides Ruby and RubyGems. Download from Apple or install from Developer Tools DVD.

#### OSX 10.4 (Tiger), 10.3 (Panther) ####

The [Ruby One-Click Installer for OSX](http://rubyosx.rubyforge.org/) provides Ruby and RubyGems.

#### Other operating systems ####

[Ruby installation instructions for other platforms](http://www.ruby-lang.org/en/downloads/)

[RubyGems installation instructions for other platforms](http://docs.rubygems.org/read/chapter/3)

### Install Sprouts ###

Open your favorite terminal emulator (Win: [Console](http://console.sourceforge.net), [PuTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/); Mac:  [iTerm](http://console.sourceforge.net), Terminal):

    $ sudo gem install sprout

Windows users do not type "sudo". Mac users should also install the rb-appscript gem:

    $ sudo gem install rb-appscript

#### Why Sprouts? ####

The [Sprouts project](http://www.projectsprouts.org) provides a well written answer to that question. I'm not going to copy the *entire* Sprouts manual here. ;P