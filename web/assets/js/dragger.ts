
import { Mastermind} from "./mastermind"

export module Dragger {

  export function start(event: DragEvent) {
    if (event.dataTransfer && event.target) {
      let color: string = <string>((<HTMLOrSVGElement><unknown>event.target).dataset.color)
      event.dataTransfer.setData("text/plain", color)
      event.dataTransfer.dropEffect = "copy";
    }
  }

  export function dragover(event: DragEvent) {
    event.preventDefault();
    if (event.dataTransfer) {
      event.dataTransfer.dropEffect = "copy"
    }
  }

  export function drop(event: DragEvent) {
    event.preventDefault();
    if (event.dataTransfer) {
      let colorString = event.dataTransfer.getData("text/plain");
      let color = parseInt(colorString);
      let columnString = <string>((<HTMLOrSVGElement><unknown>event.target).dataset.column)
      let column = parseInt(columnString)
      Mastermind.setGuess(column, color)
    }
   }
}
