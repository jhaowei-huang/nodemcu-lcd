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

## 說明
```lua
lcd.start(deviceAddress, sda, scl)
  -- 初始化
  -- deviceAddress：裝置位置，HD44780U皆為0x27
  -- sda：資料線pin腳
  -- scl：時脈線pin腳
  
lcd.locate(row, column)
  -- 給予螢幕上位置，計算DDRAM address
  -- row：16x2 LCD有2列，編號從0~1
  -- column：16x2 LCD一列最多有16字元，編號從0~15

lcd.put(locate, string)
  -- 印出字串
  -- locate：LCD DDRAM的位置
  -- string：印出的字串
  
lcd.clear()
  -- 清空螢幕所有字元
  
lcd.backgroundLight(onoff)
  -- LCD背光開啟或關閉
  -- onoff： lcd.ON為開，lcd.OFF為關
  
lcd.scrollToRight(row, colStart, colEnd, s, interval, timer)
  -- 向右跑馬燈，若給予起點小於終點則會呈現從最左至最右的效果
  -- row：在第0或1列上
  -- colStart：column的起始位置，不可大於column終點位置
  -- colEnd：column的終點位置，不可小於column起始位置
  -- s：顯示的字串
  -- interval：更新時間間距，單位ms
  -- timer：使用NodeMCU 0~6號計時器
  
lcd.scrollToLeft(row, colStart, colEnd, s, interval, timer)
  -- 向左跑馬燈，若給予終點小於起點則會呈現從最右至最左的效果
  -- row：在第0或1列上
  -- colStart：column的起始位置，不可小於column終點位置
  -- colEnd：column的終點位置，不可大於column起始位置
  -- s：顯示的字串
  -- interval：更新時間間距，單位ms
  -- timer：使用NodeMCU 0~6號計時器
```


## Reference
[dvv/nodemcu-thingies/lcd1602.lua](https://github.com/dvv/nodemcu-thingies/blob/master/lcd1602.lua)

[Hitachi HD44780U dot-matrix LCD](https://www.sparkfun.com/datasheets/LCD/HD44780.pdf)
