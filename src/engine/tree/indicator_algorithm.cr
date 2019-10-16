require "crystal_talib"

# AVAILABLE INDICATORS ARE
###############################
# ["ADD",
#  "DIV",
#  "MAX",
#  "MAXINDEX",
#  "MIN",
#  "MININDEX",
#  "MINMAX",
#  "MINMAXINDEX",
#  "MULT",
#  "SUB",
#  "SUM",
#  "ACOS",
#  "ASIN",
#  "ATAN",
#  "CEIL",
#  "COS",
#  "COSH",
#  "EXP",
#  "FLOOR",
#  "LN",
#  "LOG10",
#  "SIN",
#  "SINH",
#  "SQRT",
#  "TAN",
#  "TANH",
#  "BBANDS",
#  "DEMA",
#  "EMA",
#  "HT_TRENDLINE",
#  "KAMA",
#  "MA",
#  "MAMA",
#  "MAVP",
#  "MIDPOINT",
#  "MIDPRICE",
#  "SAR",
#  "SAREXT",
#  "SMA",
#  "T3",
#  "TEMA",
#  "TRIMA",
#  "WMA",
#  "ATR",
#  "NATR",
#  "TRANGE",
#  "ADX",
#  "ADXR",
#  "APO",
#  "AROON",
#  "AROONOSC",
#  "BOP",
#  "CCI",
#  "CMO",
#  "DX",
#  "MACD",
#  "MACDEXT",
#  "MACDFIX",
#  "MFI",
#  "MINUS_DI",
#  "MINUS_DM",
#  "MOM",
#  "PLUS_DI",
#  "PLUS_DM",
#  "PPO",
#  "ROC",
#  "ROCP",
#  "ROCR",
#  "ROCR100",
#  "RSI",
#  "STOCH",
#  "STOCHF",
#  "STOCHRSI",
#  "TRIX",
#  "ULTOSC",
#  "WILLR",
#  "HT_DCPERIOD",
#  "HT_DCPHASE",
#  "HT_PHASOR",
#  "HT_SINE",
#  "HT_TRENDMODE",
#  "AD",
#  "ADOSC",
#  "OBV",
#  "CDL2CROWS",
#  "CDL3BLACKCROWS",
#  "CDL3INSIDE",
#  "CDL3LINESTRIKE",
#  "CDL3OUTSIDE",
#  "CDL3STARSINSOUTH",
#  "CDL3WHITESOLDIERS",
#  "CDLABANDONEDBABY",
#  "CDLADVANCEBLOCK",
#  "CDLBELTHOLD",
#  "CDLBREAKAWAY",
#  "CDLCLOSINGMARUBOZU",
#  "CDLCONCEALBABYSWALL",
#  "CDLCOUNTERATTACK",
#  "CDLDARKCLOUDCOVER",
#  "CDLDOJI",
#  "CDLDOJISTAR",
#  "CDLDRAGONFLYDOJI",
#  "CDLENGULFING",
#  "CDLEVENINGDOJISTAR",
#  "CDLEVENINGSTAR",
#  "CDLGAPSIDESIDEWHITE",
#  "CDLGRAVESTONEDOJI",
#  "CDLHAMMER",
#  "CDLHANGINGMAN",
#  "CDLHARAMI",
#  "CDLHARAMICROSS",
#  "CDLHIGHWAVE",
#  "CDLHIKKAKE",
#  "CDLHIKKAKEMOD",
#  "CDLHOMINGPIGEON",
#  "CDLIDENTICAL3CROWS",
#  "CDLINNECK",
#  "CDLINVERTEDHAMMER",
#  "CDLKICKING",
#  "CDLKICKINGBYLENGTH",
#  "CDLLADDERBOTTOM",
#  "CDLLONGLEGGEDDOJI",
#  "CDLLONGLINE",
#  "CDLMARUBOZU",
#  "CDLMATCHINGLOW",
#  "CDLMATHOLD",
#  "CDLMORNINGDOJISTAR",
#  "CDLMORNINGSTAR",
#  "CDLONNECK",
#  "CDLPIERCING",
#  "CDLRICKSHAWMAN",
#  "CDLRISEFALL3METHODS",
#  "CDLSEPARATINGLINES",
#  "CDLSHOOTINGSTAR",
#  "CDLSHORTLINE",
#  "CDLSPINNINGTOP",
#  "CDLSTALLEDPATTERN",
#  "CDLSTICKSANDWICH",
#  "CDLTAKURI",
#  "CDLTASUKIGAP",
#  "CDLTHRUSTING",
#  "CDLTRISTAR",
#  "CDLUNIQUE3RIVER",
#  "CDLUPSIDEGAP2CROWS",
#  "CDLXSIDEGAP3METHODS",
#  "BETA",
#  "CORREL",
#  "LINEARREG",
#  "LINEARREG_ANGLE",
#  "LINEARREG_INTERCEPT",
#  "LINEARREG_SLOPE",
#  "STDDEV",
#  "TSF",
#  "VAR",
#  "AVGPRICE",
#  "MEDPRICE",
#  "TYPPRICE",
#  "WCLPRICE"]

module AlgoBacktester::Tree
    abstract class IndicatorAlgorithm < AbstractAlgorithm
  
      # Returns a simple true/false algo
      def initialize(@run_always = false, @value = 0_i64)
        super(@run_always, @value)
      end
  
      # Runs the algorithm, returning the bool value of the algorithm
      def run(strategy : AbstractStrategy) : {Bool, AlgorithmError?}
        return {true, nil}
      end
    end

    class SMA < IndicatorAlgorithm
        def initialize(@time_period : Float64 = 30.0)
            @run_always = true
            @value = 0_i64
        end

        def run(strategy : AbstractStrategy) : {Bool, AlgorithmError?}
            return {false, AlgorithmError.new("Indicator failed because data was nil")} if (data = strategy.data).nil?
            return {false, AlgorithmError.new("Indicator failed because event was nil")} if (event = strategy.event).nil?
            
            symbol = event.symbol

            holding_list = data.list(symbol)

            # It returns nil if the symbol doesn't exist.
            return {false, AlgorithmError.new("Indicator failed because no data was found for holding")} if holding_list.nil?

            return {false, AlgorithmError.new("Indicator failed because SMA requires > #{@time_period} data entries.")} if holding_list.size < @time_period

            prices = holding_list.map(&.price)

            result = CrystalTalib.execute(
                name: "SMA",
                start_idx: 0,
                end_idx: prices.size - 1,
                in_real: prices,
                opt_in_time_period: @time_period
            )
            puts "SMA======================>"
            pp result
            
            return {true, nil}
        end
    end
end