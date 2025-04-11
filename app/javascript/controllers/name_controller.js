import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "touchable",
    "voteNo",
    "voteYes",
    "voteNoLink",
    "voteYesLink",
    "cardBody",
    "spinner"
  ]

  static startX = null
  static swipeDirection = null
  static distX = 0
  static moved = false

  connect() {
    this.#reset()
  }

  setup(event) {
    this.startX = event.changedTouches[0].pageX
  }

  submit(event) {
    if (!this.moved) {
      const elem = event.changedTouches[0]
      let target = elem.target

      if (target.tagName.toLowerCase() === "svg") {
        target = target.parentElement
      }

      if (target.tagName.toLowerCase() === "a") {
        this.#postVote(target.href)
        return
      }
    }

    if (this.swipeDirection === "left" && this.distX < -100) {
      this.#postVote(this.voteNoLinkTarget.href)
    } else if (this.swipeDirection === "right" && this.distX > 100) {
      this.#postVote(this.voteYesLinkTarget.href)
    }
  }

  rotate(event) {
    this.moved = true
    this.distX = event.changedTouches[0].pageX - this.startX
    this.swipeDirection = this.distX > 0 ? "right" : "left"

    this.touchableTarget.style.setProperty("left", `${this.distX}px`)
    this.touchableTarget.style.setProperty("transform", `rotate(${this.distX / 20}deg`)

    if (this.swipeDirection === "left") {
      if (this.distX < -100) {
        document.querySelector("html").style.setProperty("background", "var(--color-accent)");
        this.voteNoTarget.classList.remove("hidden")
      } else {
        document.querySelector("html").style.removeProperty("background")
        this.voteNoTarget.classList.add("hidden")
      }
    } else if (this.swipeDirection === "right") {
      if (this.distX > 100) {
        document.querySelector("html").style.setProperty("background", "var(--color-primary)");
        this.voteYesTarget.classList.remove("hidden")
      } else {
        document.querySelector("html").style.removeProperty("background")
        this.voteYesTarget.classList.add("hidden")
      }
    }
  }

  #reset() {
    this.startX = null
    this.swipeDirection = null
    this.distX = 0
    this.moved = false

    this.touchableTarget.style.removeProperty("left")
    this.touchableTarget.style.removeProperty("transform")
    this.voteNoTarget.classList.add("hidden")
    this.voteYesTarget.classList.add("hidden")
    document.querySelector("html").style.removeProperty("background")
  }

  #postVote(url) {
    this.cardBodyTarget.classList.add("hidden")
    this.spinnerTarget.classList.remove("hidden")

    const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
    fetch(url, {
      method: "POST",
      headers: {
        "X-CSRF-Token": csrfToken,
        "Accept": "text/vnd.turbo-stream.html",
      },
    })
      .then(response => response.text())
      .then(text => Turbo.renderStreamMessage(text))
  }
}
