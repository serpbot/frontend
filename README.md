# Serpbot-frontend

## Generating CSS

The CSS for this project needs to be built for the specific elements found on the page. This is to minimize the size of the css file.

The primary css library used is Tailwind for this application.

### Generate CSS

Note: The tailwindcss library wasn't playing nice with Elm, so the css must be generated manually. For licensing purposes, simply use the genrated css file in the public/css folder.

## Installation

1. Install elm
> npm install -g elm@latest

2. Install elm-spa
> npm install -g elm-spa@latest

## Dependencies

All the elm dependencies can be found in the elm.json file. No external installation is required, it is automatically fetched at compile time.

## Starting

Starting the application in dev mode is extremely easy. You just need to run the command found below.

> elm-spa server