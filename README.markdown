# Metafas3 #

Metafas3 (pronounced "metaphase") is a small [MVP](http://martinfowler.com/eaaDev/uiArchs.html#Model-view-presentermvp) framework for AS3, inspired by [Ruby on Rails](http://rubyonrails.org/), implementing the [Supervising Controller/Presenter](http://martinfowler.com/eaaDev/SupervisingPresenter.html) pattern. Metafas3 is built upon the [Sprouts](http://projectsprouts.org) project-generation tool for ActionScript/Flash/Flex/AIR.

## Why Metafas3? ##

* **MVP:** Metafas3 implements the [Supervising Controller/Presenter](http://martinfowler.com/eaaDev/SupervisingPresenter.html) pattern as defined by Martin Fowler. Metafas3 is [opinionated](http://gettingreal.37signals.com/ch04_Make_Opinionated_Software.php) software, where Views are meant to be declarative and "dumb", Controllers to be event handlers for user gestures, and Models to provide business logic and data validation.
* **Runtime Views:** Metafas3 X/HTML5 views may be compiled into the .swf, or loaded and rendered at *runtime*.
* **Lightweight:** Less than 70k for a fully-loaded .swf compiled with fl.controls.ComboBox, RadioButton, CheckBox, TextInput, Button and UILoader. The equivalent .swf built with Flex exceeds 400k.
* **Declarative:** Like Flex, Metafas3 provides a declarative markup language (X/HTML5) for views.
* **Data Bindings:** Like Flex, Metafas3 provides a simple declarative data-binding syntax.
* **Validations:** Like Flex, Metafas3 provides in-UX validations. Unlike Flex, Metafas3 applies validations in the Model layer, not in the View layer. The only exception: Like Flex, Metafas3 provides a shortcut 'required="true"' syntax for simple view-defined validations.
* **REST:** Inspired, and partially copied from, Ruby on Rails, Metafas3's ReactiveResource models provide a simple method for interacting with REST web services.
* **BDD/TDD Unit Testing:** Thanks to [Sprouts](http://projectsprouts.org), Metafas3 provides *two* automated testing suites:[AS3spec](http://github.com/fantasticmf/as3spec) and [AsUnit](http://github.com/lukebayes/asunit/).

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