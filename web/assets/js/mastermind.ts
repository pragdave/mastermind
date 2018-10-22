import Vue  from "vue"

interface GameData extends Vue {
  game: any;
  guess: number[]
}

type MakeGuessFunction = (guess: number[]) => void

let app: GameData;

export module Mastermind {

  function notAllGuessesFilled(): boolean {
    return app.guess.some( i => i == 0 )
  }

  export function initialize(makeGuessFunction: MakeGuessFunction) {
    app = new Vue({
      el: '#app',
      data: {
        game: null,
        guess: [],
      },
      methods: {
        notAllGuessesFilled: notAllGuessesFilled,
        makeGuess: makeGuessFunction,
      }
    });
    (<any>window).app = app

  }

  export function newGame(gameData: any) {
    app.game = gameData.game;
    resetGuesses(gameData)
    console.dir(app.guess)
    console.dir(app.game)
  }

  export function setGuess(column: number, color: number) {
    app.guess.splice(column-1, 1, color)
    console.dir(app.guess)
  }

  export function update_game(gameData: any) {
    app.game = gameData.game
    resetGuesses(gameData)
  }

  function resetGuesses(gameData: any) {
    app.guess = Array(gameData.game.width).fill(0)
  }
}

(<any>window).mastermind = Mastermind;