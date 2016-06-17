## 燒入NodeMCU
1. 下載 lcd1602.lua
2. 開啟ESPlorer，按下Save to ESP
3. 燒入到NodeMCU成功後即可使用

##範例
```lua
-- 使用lcd1602 module
lcd = dofile("lcd1602.lua")()
-- lcd起始設定，裝置位置0x27，D2為sda，D3為scl
lcd.start(0x27, 2, 3)
-- 清除lce螢幕
lcd.clear()
-- 在lcd螢幕第0列第2行開始，印出Hello World!
lcd.put(lcd.locate(0, 2), "Hello World!")
-- 跑馬燈，在第1列第2行到第10行間向右邊滑，顯示Hello World!
-- 600為更新速度，單位ms；使用NodeMCU的2號timer
lcd.scrollToRight(1, 2, 10, "Hello World!", 600, 2)
```

## 函式
| 函式名稱        | 功能          | 範例  |
|---	|---	|---	|
| ```lcd.start()```     | 初始化，設定裝置位置、sda腳位、scl腳位|```lcd.start(0x27, 2, 3)``` |
| ```lcd.locate()```   | 回傳lcd游標實際位置|```lcd.locate(0, 0))``` |
| ```lcd.put()```     | 印出字串|```lcd.put(lcd.locate(0, 0), "hello world!")``` |
| ```lcd.clear()```   | 清除lcd螢幕|```lcd.clear() ``` |
| ```lcd.backgroundLight()```| lcd背景亮或暗|```lcd.backgroundLight(lcd.ON)```|
| ```lcd.scrollToRight()```|往右邊的跑馬燈效果，能夠設定起點終點位置|```lcd.scrollToRight(1, 2, 10, "Hello World!", 600, 2)```|
| ```lcd.scrollToLeft()```|往左邊的跑馬燈效果，能夠設定起點終點位置|```lcd.scrollToLeft(1, 10, 2, "Hello World!", 600, 2)```|
