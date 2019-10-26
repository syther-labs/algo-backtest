[![Build Status](https://travis-ci.org/mikeroher/algo-backtest.svg?branch=master)](https://travis-ci.org/mikeroher/algo-backtest)

# Tree-Based Algorithmic Backtester

A modular, tree-based algorithmic backtester. The backtester is event-driven, has a historical stock price downloader via Tiingo's API and integrates with TA-Lib to integrate technical analysis into strategies. 

## Installation

Add `algo-backtester` to your `shards.yml`.

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

