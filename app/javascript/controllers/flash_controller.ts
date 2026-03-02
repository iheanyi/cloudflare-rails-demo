import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.dismiss()
    }, 4000)
  }

  dismiss() {
    const el = this.element as HTMLElement
    el.classList.add("opacity-0", "transition-opacity", "duration-300")
    setTimeout(() => {
      el.remove()
    }, 300)
  }
}
