import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["cancelLink"]

  declare hasCancelLinkTarget: boolean
  declare cancelLinkTarget: HTMLAnchorElement

  cancel(event: KeyboardEvent) {
    if (event.key === "Escape" && this.hasCancelLinkTarget) {
      event.preventDefault()
      this.cancelLinkTarget.click()
    }
  }
}
