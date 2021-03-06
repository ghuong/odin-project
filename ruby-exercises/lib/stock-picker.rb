def stock_picker(prices)
  best_profit = 0
  best_buy_day = 0
  best_sell_day = 0
  prices.each_with_index do |buy_price, buy_day|
    for sell_day in (buy_day+1)...prices.length
      profit = prices[sell_day] - buy_price
      if profit > best_profit
        best_profit = profit
        best_buy_day = buy_day
        best_sell_day = sell_day
      end
    end
  end
  return [best_buy_day, best_sell_day]
end
