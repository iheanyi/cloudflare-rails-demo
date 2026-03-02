import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "form", "input"]

  declare buttonTarget: HTMLElement
  declare formTarget: HTMLFormElement
  declare inputTarget: HTMLInputElement

  toggle() {
    this.buttonTarget.classList.toggle("hidden")
    this.formTarget.classList.toggle("hidden")
    this.inputTarget.focus()
  }

  reset() {
    this.formTarget.classList.add("hidden")
    this.buttonTarget.classList.remove("hidden")
    this.inputTarget.value = ""
  }

  submitEnd(event: CustomEvent) {
    if (event.detail.success) {
      this.reset()
    }
  }
}
