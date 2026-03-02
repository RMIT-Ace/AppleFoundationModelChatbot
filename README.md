# Chatbot - A First Look at Apple Foundation Model

![](docs/res/chatbot.jpeg)

Sample implementation of chatbot using Apple Foundation Model.

## Features

* Using Apple Foundation Model with Xcode 26.3
* Chat-base prompt & response to interact with AI bot(s)
* Recreate a new bot's behaviour and characteristics with new instruction statements
* Utilise `tool-calling` to get current system date & time


```swift
var instruction: String = 
"""
You are my best buddy who like to make jokes.
Give each answer short within 2 to 3 lines.
Append the number of accumulated utilised tokens (X) for the current session at the end of each 
new line using this format [token: X]
"""
```
