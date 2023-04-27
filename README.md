# Overview

This is a flutter application that allows you to have conversations in German with a chatbot. The chatbot makes use of openAi's gpt3.5 model to generate responses. It provides german to english translations as well as corrections for your german sentences. 

# Getting Started

## Pre-requisites:

* install flutter SDK
* (Android) install Android Studio
* (IOS) install XCode

## Running the app

* Android:

        - connect your device via USB
        - ensure USB debugging is enabled
        - in the terminal, cd into the app dir
        - run: flutter run
        - choose your device from the options

## Updating the settings

Once the app is running, click on the gear icon in the top right to go to the settings page. The following settings will be available:

* API Key
        
    This is an API key obtained from OpenAi that allows the app to make use of their API endpoints. You will need to sign up for an account and generate a secret api key. Once this is done, enter it in this field and save.

* Max tokens

    OpenAi APIs charge for usage by the number of tokens used in requests. This includes both the prompt and output generated. This setting sets the maximum number of output tokens to generate per request.

    1000 tokens equal around 750 words.

* Context count

    This is the number of messages in a conversation to send when a new request is made. These messages provide context about the conversation.

    The messages are taken starting from the last message in the conversation.

    These messages are also counted when calculating the number of tokens a request used. Increasing this count can result in a larger monthly bill.

## Creating a new conversation

In the home page, click on the plus icon button. This will take you to a page where a topic should be chosen. You can either enter a topic of your choosing or pick from one of the 3 randomly generated ones

## Sending messages

Once a conversation is created, you will be taken to the conversation page. Enter a message in german in the message field and click on the send button.

A response will be generated including a correction of whatever you said. Each message has a button that generates a translation.