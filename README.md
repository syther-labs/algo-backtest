[![Build Status](https://travis-ci.org/mikeroher/algo-backtest.svg?branch=master)](https://travis-ci.org/mikeroher/algo-backtest)

# Tree-Based Algorithmic Backtester

A modular, tree-based algorithmic backtester. The backtester is event-driven, has a historical stock price downloader via Tiingo's API and integrates with TA-Lib to integrate technical analysis into strategies. 

## Installation

Add `algo-backtester` to your `shards.yml`.

### TA-Lib

To use the TA-Lib integration, you need to have the [TA-Lib](http://ta-lib.org/hdr_dw.html) already installed. You should
probably follow their installation directions for your platform, but some
suggestions are included below for reference.

##### Mac OS X

```
$ brew install ta-lib
```

##### Windows

Download [ta-lib-0.4.0-msvc.zip](http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-msvc.zip)
and unzip to ``C:\ta-lib``.

> This is a 32-bit binary release.  If you want to use 64-bit Python, you will
> need to build a 64-bit version of the library. Some unofficial (**and
> unsupported**) instructions for building on 64-bit Windows 10, here for
> reference:
>
> 1. Download and Unzip ``ta-lib-0.4.0-msvc.zip``
> 2. Move the Unzipped Folder ``ta-lib`` to ``C:\``
> 3. Download and Install Visual Studio Community 2015
>    * Remember to Select ``[Visual C++]`` Feature
> 4. Build TA-Lib Library
>    * From Windows Start Menu, Start ``[VS2015 x64 Native Tools Command
>      Prompt]``
>    * Move to ``C:\ta-lib\c\make\cdr\win32\msvc``
>    * Build the Library ``nmake``

You might also try these unofficial windows binaries for both 32-bit and
64-bit:

https://www.lfd.uci.edu/~gohlke/pythonlibs/#ta-lib

##### Linux

Download [ta-lib-0.4.0-src.tar.gz](http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz) and:

```
$ tar -xzf ta-lib-0.4.0-src.tar.gz
$ cd ta-lib/
$ ./configure --prefix=/usr
$ make
$ sudo make install
```

> If you build ``TA-Lib`` using ``make -jX`` it will fail but that's OK!
> Simply rerun ``make -jX`` followed by ``[sudo] make install``.

## Dependencies

+ TA-Lib
+ Crystal dependencies (installed automatically via `shards install`):
    + `VCR` (for caching API requests)
    + `halite` (HTTP requests)
    + `crystal_talib`  (TA-Lib C bindings)


## Usage

```crystal
require 'algo-backtester'


  bars = TiingoDataDownloader.new.query("AAPL", 3.months.ago, Time.now)

  data = DataHandler.new(stream: bars)

  strategy = Strategy.new("buy_and_hold")
  strategy.set_algo(
    RunMonthlyAlgorithm.new,
    SignalAlgorithm.new(direction: :buy)
  )
  strategy.add_child Asset.new("AAPL")

  backtest = Backtest.new(initial_cash: 1000.0_f64, data: data, strategy: strategy)

  backtest.run

  backtest.statistics.print_summary
```

## Alternatives

+ [pmorissette's bt Python library](https://github.com/pmorissette/bt)
+ [dirk olbrich's gobacktest Golang package](https://github.com/dirkolbrich/gobacktest)


## TODO

- [ ] Add more specs (currently specs exist for non-algorithm classes/structs; need to extend to Algorithms)
- [ ] Add better documentation
- [ ] Add algorithms for more TA-Lib functions (currently just shows SMA as a prototype)
- [ ] Compute + print more statistics (currently only shows Sharpe, Sortino and Cumulative Return)

## Contributing

1. Fork it (<https://github.com/mikeroher/algo-backtester/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Acknowledgements

+ TA Lib Installation instructions from [mrjbq7/ta-lib Python Library](https://github.com/mrjbq7/ta-lib/blob/master/README.md)
+ Implementation inspired by the two alternatives listed above.

