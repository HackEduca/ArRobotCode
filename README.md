# AR Robot Code

## Video demo
[![](http://img.youtube.com/vi/tUlizjq5xOg/0.jpg)](http://www.youtube.com/watch?v=tUlizjq5xOg "AWBeta | Demo")

## Screens
![Demo Image ](https://github.com/msorins/ArRobotCode/blob/master/0.jpeg?raw=true "Demo Image")

![Demo Image ](https://github.com/msorins/ArRobotCode/blob/master/1.jpeg?raw=true "Demo Image")

![Demo Image ](https://github.com/msorins/ArRobotCode/blob/master/2.jpeg?raw=true "Demo Image")

![Demo Image ](https://github.com/msorins/ArRobotCode/blob/master/3.jpeg?raw=true "Demo Image")

# Idea
The way that people acquire new knowledge and interact with the information has remained more or less the same in the modern history of humans, from paper-based books to digital ebooks. The interaction with the information is practically non-existent, even more, the medium of showing the information is only two-dimensional, making the understanding of the real world, three-dimensional concepts more difficult. Augmented reality, as a technology, has greatly improved in the past few years and now has the power to redesign the process of learning and teaching in ways that are still not contoured. 

So, I picked a specific field that could benefit from a redefinition of the classical means of learning, more exactly computer science.

Using an IOS IPad, ARKit, and ScratchBlocks I have developed a solution that uses Augmented Reality in which the user (a child between 6 and 15 years) has to complete an array of levels (organized by complexity and topic) in which his / her role is to fly a spaceship from Earth to Moon. This can be done by providing a list of instructions so that the spaceship follows the given route (and does not deviate).

On the grounds that the presence of Gamification is mandatory for my target audience, by solving levels you unlock characters and achievements so that you get a sentiment of accomplishment and a purpose.

Also, to boost creativity, everybody can create and play their own levels.

# How does it work
The screen for each level is split into two parts:
* On the left, there is presented a heavily modified version of scratch blocks, a visual drag and drop environment created by Google and MIT (running in a WebView)
* On the right, the device camera shows an augmented version of the real world, that displays the spaceship and its route

By running the instructions, you can see step by step how the spaceship changes its position so that you can learn by doing.

Before the code runs, WebView compiles the code and sends a list of all the final moving instructions (for the spaceship) to the native part, that actually executes them once per second (running the animations and the spaceship's translations).


# Technologies used

### Mobile:
* Swift
* SwiftRX
* ArKit
* [Scratch Blocks](https://github.com/LLK/scratch-blocks)

### BackEnd:
* Firebase
* Firebase Cloud functions


> The Project was realized in the 3rd year of University for my Bachelor's Degree