import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = {
    boardId: Number
  }
  static targets = ["count"]

  declare boardIdValue: number
  declare countTarget: HTMLElement
  private subscription: any = null

  connect() {
    const consumer = createConsumer()
    this.subscription = consumer.subscriptions.create(
      { channel: "PresenceChannel", board_id: this.boardIdValue },
      {
        received: (data: { count: number }) => {
          this.countTarget.textContent = `${data.count} viewing`
        }
      }
    )
  }

  disconnect() {
    this.subscription?.unsubscribe()
  }
}
