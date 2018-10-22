
import "../css/app.scss"
import "materialize-css"

import "phoenix_html"


import { Dragger } from  "./dragger"

import { Mastermind } from "./mastermind"

(<any>window).Dragger = Dragger;

Mastermind.initialize(makeGuess)

// import "./socket"

import {Socket, Channel} from "phoenix"


function makeGuess(guess: number[]) {
  console.dir({guess})
  channel.push("make_move", guess)
}

function startNewGame(gameData: string) {
  Mastermind.newGame(gameData);
}

function kickoff(channel: Channel) {
  channel.push("new_game", {})
}

let socket = new Socket("/socket", {params: {token: 'wibble'}})

socket.connect()

let channel = socket.channel("mm:game", {})

channel.on("new_game_setup", msg => startNewGame(msg))

channel.on("update_board", msg => Mastermind.update_game(msg))

channel.join()
  .receive("ok", resp => kickoff(channel))
  .receive("error", resp => { console.log("Unable to join", resp) })
