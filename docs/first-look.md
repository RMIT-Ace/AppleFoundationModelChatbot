
![](res/chatbot.jpeg)

# Source Code

Full access to source code is available here: 

* https://github.com/RMIT-Ace/AppleFoundationModelChatbot


# First Implementation


```swift
var instruction: String = 
"""
You are my best buddy who like to make jokes.
Give each answer short within 2 to 3 lines.
Append the number of accumulated utilised tokens (X) for the current session at the end of each 
new line using this format [token: X]
"""
```

# Sample Usages

What it is good for:

| Capability | Prompt example |
| ---------- | -------------- |
| Summarize | "Summary the given text" |
| Extract entities | "List the people and places mentioned in this text" |
| Understand text | "What happens to the dog in this story" |
| Refine or edit text | "Change this story to be in second person" |
| Classify or judge text | "Is this text relevant to the topic 'Swift'?" |
| Compose creative writing | "Generate a short bedtime story about a fox" |
| Generate tags from text | "Provide two tags that describe the given text" |
| Generate game dialog | "Respond in the void of a friendly inn keeper" |

(Note: Taken from "Generating content and performing tasks with Foundation Models", Apple Developer Documentation, see Reference 1 below)

I simply copied and pasted a section of my journal into the app and ended up having a fantastic hour-long conversation with the bot!  It was amazing!

| Sample 1 | Sample 2 |
| --- | --- |
| ![](res/sample-usage-1.png) | ![](res/sample-usage-2.png) |
